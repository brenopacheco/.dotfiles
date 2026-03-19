--- gpg.lua
---
--- Opens encrypted .gpg / .asc files as decrypted, editable buffers using a
--- custom `gpg://` URI scheme. The original encrypted file is never directly
--- edited or loaded into a normal buffer.
---
--- Behavior:
---   - Intercepts *.gpg and *.asc via BufReadCmd
---   - Redirects to a `gpg://` buffer representation
---   - Inspects encryption metadata via `gpg --list-packets`
---   - Decrypts file contents using `gpg -dq`
---   - Displays metadata as virtual extmark lines above the buffer
---   - Stores encryption metadata in `vim.b.gpg`
---   - Ensures deterministic re-encryption on save
---
--- Open flow:
---   *.gpg / *.asc
---     → inspect packet metadata
---     → decrypt via gpg
---     → open editable buffer gpg://path with virtual metadata header
---
--- Save flow:
---   gpg:// buffer
---     → confirm overwrite
---     → conflict check (warns if externally modified)
---     → re-encrypt using original metadata (recipients / mode)
---     → atomic write via temp file + rename (cross-device copy fallback)
---
--- Monitoring:
---   - Detects external file changes on FocusGained / CursorHold and warns
---   - BufWriteCmd asks for extra confirmation when file was modified externally
---
--- Requirements:
---   - gpg must be available in PATH
---
--- Notes:
---   - Plaintext exists only in memory inside the gpg:// buffer
---   - Encryption behavior is preserved from original file
---   - No reliance on ambient gpg configuration for recipients
---   - Symmetric re-encryption uses --batch --pinentry-mode loopback; this
---     bypasses the agent's pinentry dialog and routes the passphrase prompt
---     through stdin, enabling headless / non-TTY use. The GPG agent still
---     supplies any cached passphrase; only the prompt path changes.

local group = vim.api.nvim_create_augroup('my/gpg', { clear = true })

-- Namespace for the virtual extmark header; created once at module load.
local header_ns = vim.api.nvim_create_namespace('gpg-header')

-- Highlight groups linked to semantic theme groups rather than hard-coded hex.
vim.api.nvim_set_hl(0, 'GPGHeaderTitle', { link = 'Title' })
vim.api.nvim_set_hl(0, 'GPGHeaderLabel', { link = 'Identifier' })
vim.api.nvim_set_hl(0, 'GPGHeaderValue', { link = 'Comment' })

----------------------------------------------------------------------
-- Utilities
----------------------------------------------------------------------

local function gpg_uri(path) return 'gpg://' .. vim.fn.fnamemodify(path, ':p') end

local function path_from_uri(name) return name:gsub('^gpg://', '') end

----------------------------------------------------------------------
-- Algorithm name mappings
----------------------------------------------------------------------

local PUBKEY_ALGO = {
  [1] = 'RSA',
  [2] = 'RSA (encrypt-only)',
  [3] = 'RSA (sign-only)',
  [16] = 'ElGamal',
  [17] = 'DSA',
  [18] = 'ECDH',
  [19] = 'ECDSA',
  [20] = 'ElGamal',
  [22] = 'EdDSA',
}

local CIPHER_ALGO = {
  [1] = 'IDEA',
  [2] = '3DES',
  [3] = 'CAST5',
  [4] = 'Blowfish',
  [7] = 'AES128',
  [8] = 'AES192',
  [9] = 'AES256',
  [10] = 'Twofish',
  [11] = 'Camellia128',
  [12] = 'Camellia192',
  [13] = 'Camellia256',
}

local HASH_ALGO = {
  [1] = 'MD5',
  [2] = 'SHA1',
  [3] = 'RIPEMD160',
  [8] = 'SHA256',
  [9] = 'SHA384',
  [10] = 'SHA512',
  [11] = 'SHA224',
}

----------------------------------------------------------------------
-- Metadata extraction
----------------------------------------------------------------------

---@class GPGMeta
---@field symmetric boolean            true when encrypted with a symmetric passphrase
---@field recipients string[]          list of key-id hex strings for public-key encryption
---@field pubkey_algo integer|nil      public-key algorithm number (see PUBKEY_ALGO)
---@field cipher integer|nil           symmetric cipher algorithm number (see CIPHER_ALGO)
---@field hash integer|nil             S2K hash algorithm number (see HASH_ALGO)
---@field version integer|nil          packet format version
---@field signatures { algo: integer|nil, keyid: string|nil }[]
---@field armor boolean                true when the source file uses ASCII armor (.asc)

---@param packet_output string
---@return GPGMeta
local function parse_packets(packet_output)
  ---@type GPGMeta
  local meta = {
    symmetric = false,
    recipients = {},
    pubkey_algo = nil,
    cipher = nil,
    hash = nil,
    version = nil,
    signatures = {},
    armor = false,
  }

  for line in packet_output:gmatch('[^\n]+') do
    -- Symmetric-key encrypted session key.
    if line:match('symkey enc packet') then
      meta.symmetric = true
      local v = line:match('version%s+(%d+)')
      if v then meta.version = tonumber(v) end
      local c = line:match('cipher%s+(%d+)')
      if c then meta.cipher = tonumber(c) end
      local h = line:match('hash%s+(%d+)')
      if h then meta.hash = tonumber(h) end
    end

    -- Public-key encrypted session key.
    if line:match('pubkey enc packet') then
      local a = line:match('algo%s+(%d+)')
      if a then meta.pubkey_algo = tonumber(a) end
      local v = line:match('version%s+(%d+)')
      if v then meta.version = tonumber(v) end
      local kid = line:match('keyid%s+([%x]+)')
      if kid then table.insert(meta.recipients, kid) end
    end

    -- Signature packet.
    if line:match('signature packet') then
      local sig = {}
      local a = line:match('algo%s+(%d+)')
      if a then sig.algo = tonumber(a) end
      local kid = line:match('keyid%s+([%x]+)')
      if kid then sig.keyid = kid end
      if sig.algo or sig.keyid then table.insert(meta.signatures, sig) end
    end
  end

  return meta
end

---@param path string
---@return GPGMeta|nil
local function inspect_gpg_file(path)
  local res = vim
    .system({
      'gpg',
      '--list-packets',
      path,
    }, { text = true })
    :wait()

  -- gpg --list-packets writes packet metadata to stderr; stdout is empty
  -- (or contains raw decrypted data with --dump-session-keys). Use stderr.
  -- Exit code 2 is returned for warnings (expired subkeys, key not in local
  -- keyring) even when the packet data was fully emitted. Attempt to parse
  -- regardless; only return nil when there is nothing useful to parse.
  local meta = parse_packets(res.stderr)

  -- If gpg exited with a hard failure (code ~= 0) and we found nothing
  -- meaningful in the output, there is no encryption metadata to work with.
  if
    res.code ~= 0
    and not meta.symmetric
    and #meta.recipients == 0
    and #meta.signatures == 0
  then
    return nil
  end

  meta.armor = path:match('%.asc$') ~= nil

  return meta
end

----------------------------------------------------------------------
-- Decrypt
----------------------------------------------------------------------

---@param path string
---@return string[]|nil lines, string|nil err
local function decrypt(path)
  local res = vim
    .system({
      'gpg',
      '-dq',
      path,
    }, { text = true })
    :wait()

  if res.code ~= 0 then return nil, res.stderr end

  local lines = vim.split(res.stdout, '\n', { plain = true })
  -- Remove exactly one trailing empty entry produced by the final newline,
  -- but preserve intentional trailing blank lines in the original content.
  -- A file ending with \n produces ["...", ""] after split; drop only that
  -- last empty entry when the original stdout ended with exactly one newline.
  if lines[#lines] == '' and res.stdout:sub(-1) == '\n' then
    table.remove(lines)
  end

  return lines, nil
end

----------------------------------------------------------------------
-- Extmark header builder
----------------------------------------------------------------------

---@class GPGHeaderChunk : { [1]: string, [2]: string }

---@param meta GPGMeta
---@param path string
---@return GPGHeaderChunk[][]  rows of {text, hl_group} chunks
local function build_header_lines(meta, path)
  local header_rows = {}

  local function add(label, value)
    if value then
      table.insert(header_rows, {
        { label .. ' ', 'GPGHeaderLabel' },
        { value, 'GPGHeaderValue' },
      })
    end
  end

  table.insert(header_rows, {
    { 'GPG (decrypted)', 'GPGHeaderTitle' },
  })
  table.insert(header_rows, {
    { 'Source: ' .. path, 'GPGHeaderValue' },
  })

  local enc_type
  if meta.symmetric then
    enc_type = 'Symmetric passphrase'
  else
    enc_type = 'Public-key'
  end
  add('Encryption:', enc_type)

  if meta.version then add('Version:', tostring(meta.version)) end

  if meta.pubkey_algo then
    local name = PUBKEY_ALGO[meta.pubkey_algo] or ('algo ' .. meta.pubkey_algo)
    add('Algorithm:', name)
  end

  if meta.cipher then
    local name = CIPHER_ALGO[meta.cipher] or ('cipher ' .. meta.cipher)
    add('Cipher:', name)
  end

  if meta.hash then
    local name = HASH_ALGO[meta.hash] or ('hash ' .. meta.hash)
    add('S2K hash:', name)
  end

  if #meta.recipients > 0 then
    table.insert(header_rows, {
      { 'Recipients:', 'GPGHeaderLabel' },
    })
    for _, r in ipairs(meta.recipients) do
      table.insert(header_rows, {
        { '  ' .. r, 'GPGHeaderValue' },
      })
    end
  end

  if #meta.signatures > 0 then
    table.insert(header_rows, {
      { 'Signatures:', 'GPGHeaderLabel' },
    })
    for _, s in ipairs(meta.signatures) do
      local text = s.keyid or ''
      if s.algo then
        local name = PUBKEY_ALGO[s.algo] or ('algo ' .. s.algo)
        text = text .. '  ' .. name
      end
      table.insert(header_rows, {
        { '  ' .. text, 'GPGHeaderValue' },
      })
    end
  end

  return header_rows
end

----------------------------------------------------------------------
-- Footer placement
----------------------------------------------------------------------

--- Places (or replaces) the virtual-text GPG metadata footer below the last
--- buffer line. Reads meta from vim.b[bufnr].gpg and the source path from the
--- buffer's gpg:// name when no explicit path is given, so it is safe to call
--- after buffer-local variables are updated (e.g. on reload).
---@param bufnr integer
---@param path   string|nil  absolute source path; derived from buffer name when nil
---@return nil
local function place_gpg_footer(bufnr, path)
  path = path or path_from_uri(vim.api.nvim_buf_get_name(bufnr))
  local meta = vim.b[bufnr].gpg
  if not meta then return end

  vim.api.nvim_buf_clear_namespace(bufnr, header_ns, 0, -1)
  local last_row = math.max(0, vim.api.nvim_buf_line_count(bufnr) - 1)

  local footer_lines = build_header_lines(meta, path)
  local max_width = 0
  for _, row in ipairs(footer_lines) do
    local text = ''
    for _, chunk in ipairs(row) do
      text = text .. chunk[1]
    end
    local w = vim.fn.strdisplaywidth(text)
    if w > max_width then max_width = w end
  end
  local tw = vim.bo[bufnr].textwidth
  local min_width = (tw and tw > 0) and tw or 78
  local sep =
    { { string.rep('─', math.max(max_width, min_width)), 'GPGHeaderValue' } }

  vim.api.nvim_buf_set_extmark(bufnr, header_ns, last_row, 0, {
    virt_lines = { sep, unpack(footer_lines) },
  })
end

----------------------------------------------------------------------
-- Buffer creation
----------------------------------------------------------------------

-- Fills an existing buffer (typically ev.buf from BufReadCmd) with decrypted
-- content and metadata. Works in-place so the calling window does not need to
-- switch buffers — the same pattern used by pdf.lua. Calling nvim_set_current_buf
-- from inside a BufReadCmd callback causes Neovim's post-read state reconciliation
-- to redraw the buffer without extmarks; reusing ev.buf avoids that entirely.
---@param bufnr integer   existing buffer to fill (usually ev.buf)
---@param path  string    absolute path to the encrypted file
---@param lines string[]  decrypted plaintext lines
---@param meta  GPGMeta   encryption metadata
local function fill_gpg_buffer(bufnr, path, lines, meta)
  vim.bo[bufnr].buftype = 'acwrite'
  vim.bo[bufnr].bufhidden = 'hide'
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].undofile = false

  -- Detect filetype from the inner filename (e.g. "secret.yaml" from
  -- "secret.yaml.gpg") so syntax highlighting reflects the plaintext format.
  -- Some Neovim filetype detectors (e.g. conf, sh) probe buffer content and
  -- crash on empty buffers. Move set_lines before match and guard with pcall.
  local inner = vim.fn.fnamemodify(path, ':r') -- strip .gpg / .asc
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  local ok, ft = pcall(vim.filetype.match, { buf = bufnr, filename = inner })
  vim.bo[bufnr].filetype = (ok and ft) or 'text'

  -- Virtual footer: separator + metadata, always anchored to the last line.
  -- TODO: ideally this header would appear at the top of the buffer, but
  -- virt_lines_above=true at row 0 is clipped in Neovim 0.13 when topline=1
  -- and no workaround (scheduling, BufWinEnter timing) resolved it. Revisit
  -- when a Neovim fix or API for pre-buffer virtual lines is available.
  -- For now we attach below the last row and re-place on every change so the
  -- footer tracks the actual end of the buffer as lines are added/removed.
  vim.b[bufnr].gpg = meta

  place_gpg_footer(bufnr, path)

  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    group = group,
    buffer = bufnr,
    desc = 'Keep GPG footer anchored to last line',
    callback = function() place_gpg_footer(bufnr) end,
  })

  vim.api.nvim_buf_set_name(bufnr, gpg_uri(path))
  -- nvim_buf_set_name creates a ghost entry for the old (empty) name as a side
  -- effect (see neovim/neovim#20349). Delete it to avoid stale buffer clutter.
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= bufnr and vim.api.nvim_buf_get_name(b) == path then
      vim.api.nvim_buf_delete(b, { force = true })
    end
  end

  vim.bo[bufnr].modified = false

  -- Record the file's mtime (unix timestamp seconds, via vim.uv.fs_stat)
  -- so external-change detection (FocusGained / BufWriteCmd) can compare.
  local stat = vim.uv.fs_stat(path)
  vim.b[bufnr].gpg_mtime = stat and stat.mtime.sec or nil
end

----------------------------------------------------------------------
-- Open flow
----------------------------------------------------------------------

--- Reads and decrypts a GPG-encrypted file. Performs all pre-flight
--- checks (gpg available, file readable, parseable encryption metadata,
--- successful decryption) and returns the plaintext lines and metadata.
--- The caller is responsible for notifying the user on error.
---@param path string
---@return string[]|nil lines
---@return GPGMeta|nil   meta
---@return string|nil    err
local function read_gpg_file(path)
  if vim.fn.executable('gpg') == 0 then
    return nil, nil, 'GPG: gpg not found in PATH'
  end

  if vim.fn.filereadable(path) == 0 then
    return nil, nil, ('GPG: file not readable: %s'):format(path)
  end

  local meta = inspect_gpg_file(path)
  if not meta then
    return nil, nil, 'GPG: failed to inspect encryption metadata'
  end

  local lines, decrypt_err = decrypt(path)
  if not lines then
    local msg = 'GPG: decryption failed'
    if decrypt_err and decrypt_err ~= '' then
      msg = msg .. ': ' .. decrypt_err:match('[^\n]+')
    end
    return nil, nil, msg
  end

  return lines, meta, nil
end

---@param bufnr integer  buffer to fill (ev.buf from BufReadCmd)
---@param path  string   absolute path to the .gpg / .asc file
---@return boolean       true on success, false on any failure
local function open_file(bufnr, path)
  local lines, meta, err = read_gpg_file(path)
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return false
  end

  fill_gpg_buffer(bufnr, path, lines, meta)
  return true
end

----------------------------------------------------------------------
-- Dedup
----------------------------------------------------------------------

---@param path string
---@return integer|nil
local function find_existing(path)
  local target = gpg_uri(path)

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == target then return buf end
  end
end

----------------------------------------------------------------------
-- External change detection
----------------------------------------------------------------------

vim.api.nvim_create_autocmd({ 'FocusGained', 'CursorHold' }, {
  group = group,
  pattern = 'gpg://*',
  desc = 'Warn when the underlying GPG file has been modified externally',
  callback = function(ev)
    local path = path_from_uri(vim.api.nvim_buf_get_name(ev.buf))
    local stored_mtime = vim.b[ev.buf].gpg_mtime
    if not stored_mtime then return end

    local stat = vim.uv.fs_stat(path)
    if not stat then return end

    if stat.mtime.sec ~= stored_mtime then
      vim.notify(
        ('GPG: %s was modified externally'):format(
          vim.fn.fnamemodify(path, ':t')
        ),
        vim.log.levels.WARN
      )
      -- Update so the warning fires once per external change, not on
      -- every subsequent CursorHold.
      vim.b[ev.buf].gpg_mtime = stat.mtime.sec
    end
  end,
})

----------------------------------------------------------------------
-- BufReadCmd: intercept encrypted files
----------------------------------------------------------------------

vim.api.nvim_create_autocmd('BufReadCmd', {
  group = group,
  pattern = { '*.gpg', '*.asc' },
  desc = 'Decrypt GPG files into editable buffers',
  callback = function(ev)
    -- When :e! is used on a gpg:// buffer whose name ends with .asc/.gpg,
    -- the gpg://* BufReadCmd also matches. Skip here so it takes over.
    if ev.match:match('^gpg://') then return end

    local path = vim.fn.fnamemodify(ev.match, ':p')

    local existing = find_existing(path)
    if existing then
      vim.api.nvim_set_current_buf(existing)
      vim.api.nvim_buf_delete(ev.buf, { force = true })
      return
    end

    if not open_file(ev.buf, path) then
      vim.api.nvim_buf_delete(ev.buf, { force = true })
    end
  end,
})

vim.api.nvim_create_autocmd('BufReadCmd', {
  group = group,
  pattern = 'gpg://*',
  desc = 'Reload decrypted GPG buffer contents on :edit / :e!',
  callback = function(ev)
    local path = path_from_uri(ev.match)

    local lines, meta, err = read_gpg_file(path)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end

    vim.api.nvim_buf_set_lines(ev.buf, 0, -1, true, lines)
    vim.b[ev.buf].gpg = meta

    local stat = vim.uv.fs_stat(path)
    vim.b[ev.buf].gpg_mtime = stat and stat.mtime.sec or nil

    place_gpg_footer(ev.buf)

    vim.bo[ev.buf].modified = false
  end,
})

----------------------------------------------------------------------
-- Save flow
----------------------------------------------------------------------

vim.api.nvim_create_autocmd('BufWriteCmd', {
  group = group,
  pattern = 'gpg://*',
  desc = 'Encrypt and write GPG buffers back to disk',
  callback = function(ev)
    local buf = ev.buf
    local path = path_from_uri(vim.api.nvim_buf_get_name(buf))

    local meta = vim.b[buf].gpg or {}

    if not meta.symmetric and #(meta.recipients or {}) == 0 then
      vim.notify(
        'GPG: no encryption metadata (missing vim.b.gpg) — cannot save',
        vim.log.levels.ERROR
      )
      return
    end

    if vim.fn.executable('gpg') == 0 then
      vim.notify('GPG: gpg not found in PATH', vim.log.levels.ERROR)
      return
    end

    if
      vim.fn.confirm(
        ('Encrypt and overwrite %s?'):format(vim.fn.fnamemodify(path, ':t')),
        '&Yes\n&No',
        2
      ) ~= 1
    then
      return
    end

    -- Conflict check: if the encrypted file was modified externally since
    -- we last opened or saved it, require explicit confirmation before
    -- overwriting — the external change would be silently destroyed otherwise.
    local stored_mtime = vim.b[buf].gpg_mtime
    if stored_mtime then
      local stat = vim.uv.fs_stat(path)
      if stat and stat.mtime.sec ~= stored_mtime then
        if
          vim.fn.confirm(
            ('WARNING: %s was modified externally. Overwrite anyway?'):format(
              vim.fn.fnamemodify(path, ':t')
            ),
            '&Overwrite\n&Cancel',
            2
          ) ~= 1
        then
          return
        end
      end
    end

    -- All buffer lines are content (no header lines to strip).
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    local tmp = vim.fn.tempname()

    local cmd

    if meta.symmetric then
      -- --batch suppresses interactive prompts.
      -- --pinentry-mode loopback bypasses the agent's pinentry dialog and
      -- routes the passphrase prompt through stdin, enabling headless use.
      -- A running agent still supplies cached passphrases; only the prompt
      -- path is redirected away from any GUI / TTY pinentry program.
      cmd = {
        'gpg',
        '--batch',
        '--pinentry-mode',
        'loopback',
        '-c',
      }
      if meta.armor then table.insert(cmd, '--armor') end
      table.insert(cmd, '-o')
      table.insert(cmd, tmp)
    else
      local args = { 'gpg', '--batch', '-e', '--yes' }
      if meta.armor then table.insert(args, '--armor') end
      table.insert(args, '-o')
      table.insert(args, tmp)

      for _, r in ipairs(meta.recipients or {}) do
        table.insert(args, '-r')
        table.insert(args, r)
      end

      cmd = args
    end

    local text = table.concat(lines, '\n')
    local res = vim
      .system(cmd, {
        text = true,
        stdin = (text == '' and text or (text .. '\n')),
      })
      :wait()

    if res.code ~= 0 then
      vim.uv.fs_unlink(tmp)
      local msg = 'GPG: encryption failed'
      if res.stderr and res.stderr ~= '' then
        msg = msg .. ': ' .. res.stderr:match('[^\n]+')
      end
      vim.notify(msg, vim.log.levels.ERROR)
      return
    end

    local ok, err = vim.uv.fs_rename(tmp, path)
    if not ok then
      -- EXDEV (cross-device) or other rename failure; fall back to copy.
      local stat = vim.uv.fs_stat(tmp)
      if stat then
        local fd = vim.uv.fs_open(tmp, 'r', 0)
        if fd then
          local data = vim.uv.fs_read(fd, stat.size, 0)
          vim.uv.fs_close(fd)
          if data then
            fd = vim.uv.fs_open(path, 'w', stat.mode or 420)
            if fd then
              vim.uv.fs_write(fd, data, 0)
              vim.uv.fs_close(fd)
              ok = true
            end
          end
        end
      end
      vim.uv.fs_unlink(tmp)
      if not ok then
        vim.notify(
          'GPG: write failed: ' .. (err or 'unknown'),
          vim.log.levels.ERROR
        )
        return
      end
    end

    vim.bo[buf].modified = false

    -- Update stored mtime to the newly written file so subsequent
    -- FocusGained / BufWriteCmd checks don't false-positive on our own write.
    local new_stat = vim.uv.fs_stat(path)
    vim.b[buf].gpg_mtime = new_stat and new_stat.mtime.sec or nil

    vim.notify(
      'Encrypted: ' .. vim.fn.fnamemodify(path, ':t'),
      vim.log.levels.INFO
    )
  end,
})

-- Export private helpers for unit tests when NVIM_TEST=1.
-- This block has zero effect in normal Neovim sessions.
if vim.env.NVIM_TEST == '1' then
  return {
    _parse_packets = parse_packets,
    _build_header_lines = build_header_lines,
    _find_existing = find_existing,
    _path_from_uri = path_from_uri,
    _gpg_uri = gpg_uri,
  }
end

return {}
