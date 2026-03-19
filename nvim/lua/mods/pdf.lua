--- pdf.lua
---
--- Opens PDF files as read-only, non-modifiable text buffers using `pdftotext`.
---
--- Behavior:
---   - Intercepts attempts to open `*.pdf` files via BufReadCmd
---   - If a pdf:// buffer for the same file is already open, switches to it
---   - Never loads PDF bytes into a buffer
---   - Buffers are read-only and non-modifiable
---   - Converts PDFs to text using `pdftotext -layout`
---   - Displays source path in a virtual extmark header
---   - Closing the window hides the buffer (bufhidden=hide); re-opening the same PDF reuses it
---   - `:e!` on an open pdf:// buffer reloads the PDF from disk
---
--- URI Scheme:
---   pdf://absolute/path/to/file.pdf
---
--- Requirements:
---   - `pdftotext` must be available in $PATH
---
--- Limitations:
---   - `-layout` mode preserves physical layout but may produce uneven
---     results for complex PDFs with tables, columns, or forms.
---
--- Examples:
---   :edit paper.pdf
---   :find report.pdf
---   nvim thesis.pdf

local group = vim.api.nvim_create_augroup('my/pdf', { clear = true })

-- Namespace for the virtual extmark header; created once at module load.
local header_ns = vim.api.nvim_create_namespace('pdf-header')

-- Capability flags evaluated once at module load.
local has_pdftotext = vim.fn.executable('pdftotext') == 1

----------------------------------------------------------------------
-- Highlight groups
----------------------------------------------------------------------

vim.api.nvim_set_hl(0, 'PDFHeaderTitle', { link = 'Title' })
vim.api.nvim_set_hl(0, 'PDFHeaderValue', { link = 'Comment' })

----------------------------------------------------------------------
-- URI helpers
----------------------------------------------------------------------

-- Callers must supply a canonicalised absolute path (resolved at BufReadCmd time).
---@param path string  absolute, symlink-resolved path
---@return string
local function pdf_uri(path) return 'pdf://' .. path end

---@param uri string
---@return string
local function strip_pdf_uri(uri) return uri:sub(#'pdf://' + 1) end

---@param path string
---@return integer|nil
local function find_existing(path)
  local target = pdf_uri(path)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == target then return buf end
  end
end

----------------------------------------------------------------------
-- PDF loading
----------------------------------------------------------------------

---@param bufnr integer
---@param path string  absolute, symlink-resolved path
local function load_pdf(bufnr, path)
  -- Configure the buffer and show a placeholder immediately so Neovim
  -- remains responsive while pdftotext runs in the background.
  -- modifiable must be reset first: on :e! reload the buffer is already
  -- read-only from the previous load, and nvim_buf_set_lines would error.
  local bo = vim.bo[bufnr]
  bo.modifiable = true
  bo.readonly = false
  bo.buftype = 'nowrite'
  bo.bufhidden = 'hide'
  bo.buflisted = true
  bo.swapfile = false
  bo.filetype = 'text'
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, { 'Loading…' })
  bo.modifiable = false
  bo.modified = false

  vim.system({
    'pdftotext',
    '-layout',
    '-eol',
    'unix',
    path,
    '-',
  }, { text = true }, function(result)
    -- pdftotext's on_exit fires in a libuv fast-event context where nvim
    -- API calls are forbidden.  Defer to the main loop when needed;
    -- run synchronously otherwise (e.g. when invoked from a test shim).
    local function apply()
      if not vim.api.nvim_buf_is_valid(bufnr) then return end

      if result.code ~= 0 then
        vim.notify(
          ('pdftotext failed for %s'):format(path),
          vim.log.levels.ERROR
        )
        vim.api.nvim_buf_delete(bufnr, { force = true })
        return
      end

      -- pdftotext appends a trailing newline; drop the resulting empty
      -- last entry while preserving interior blank lines.
      local text_lines =
        vim.split(result.stdout, '\n', { plain = true, keepempty = true })
      if text_lines[#text_lines] == '' then table.remove(text_lines) end

      -- Clear any existing header extmarks (e.g. from a previous load on :e!).
      vim.api.nvim_buf_clear_namespace(bufnr, header_ns, 0, -1)

      -- Virtual extmark header (above line 1 — position is stable regardless
      -- of buffer content, so this can be placed before nvim_buf_set_lines).
      vim.api.nvim_buf_set_extmark(bufnr, header_ns, 0, 0, {
        virt_lines = {
          { { 'PDF (readonly)', 'PDFHeaderTitle' } },
          { { 'Source: ' .. path, 'PDFHeaderValue' } },
        },
        virt_lines_above = true,
      })

      bo.modifiable = true
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, text_lines)

      bo.readonly = true
      bo.modifiable = false
      bo.modified = false

      vim.api.nvim_buf_set_name(bufnr, pdf_uri(path))
      -- nvim_buf_set_name is a wrapper around Vim's rename_buffer(), which
      -- always creates a ghost buffer entry for the old name as a side effect.
      -- This is intentional, inherited behaviour — not a bug — documented in
      -- https://github.com/neovim/neovim/issues/20349. The recommended
      -- workaround (lewis6991) is to delete the ghost explicitly afterward.
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if b ~= bufnr and vim.api.nvim_buf_get_name(b) == path then
          vim.api.nvim_buf_delete(b, { force = true })
        end
      end
    end

    if vim.in_fast_event() then
      vim.schedule(apply)
    else
      apply()
    end
  end)
end

----------------------------------------------------------------------
-- Window options applied via BufWinEnter
----------------------------------------------------------------------

-- `vim.wo` targets the current window at call time, which is unreliable during
-- BufReadCmd callbacks and does not cover buffers opened in additional windows.
-- BufWinEnter fires whenever the buffer appears in any window, so we use it
-- to set window-local options reliably.
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = group,
  pattern = 'pdf://*',
  desc = 'Apply window-local options to PDF buffers',
  callback = function() vim.wo.wrap = false end,
})

----------------------------------------------------------------------
-- BufReadCmd
----------------------------------------------------------------------

vim.api.nvim_create_autocmd('BufReadCmd', {
  group = group,
  pattern = '*.pdf',
  desc = 'Open PDF files as text via pdftotext',
  callback = function(ev)
    if ev.match:match('^pdf://') then return end

    if not has_pdftotext then
      vim.notify('pdftotext not found in PATH', vim.log.levels.ERROR)
      vim.api.nvim_buf_delete(ev.buf, { force = true })
      return
    end

    -- Resolve symlinks so buffer names are always the canonical path.
    -- On macOS /tmp → /private/tmp; without this find_existing misses
    -- already-open buffers and the ghost-buffer cleanup misses the ghost.
    local path = vim.uv.fs_realpath(vim.fn.fnamemodify(ev.match, ':p'))
      or vim.fn.fnamemodify(ev.match, ':p')

    local existing = find_existing(path)
    if existing then
      -- Switch before deleting ev.buf so the window does not collapse.
      vim.api.nvim_set_current_buf(existing)
      vim.api.nvim_buf_delete(ev.buf, { force = true })
      return
    end

    if vim.fn.filereadable(path) == 0 then
      vim.notify(('PDF not found: %s'):format(path), vim.log.levels.ERROR)
      vim.api.nvim_buf_delete(ev.buf, { force = true })
      return
    end

    load_pdf(ev.buf, path)
  end,
})

vim.api.nvim_create_autocmd('BufReadCmd', {
  group = group,
  pattern = 'pdf://*',
  desc = 'Reload PDF buffers on :e!',
  callback = function(ev)
    if not has_pdftotext then
      vim.notify('pdftotext not found in PATH', vim.log.levels.ERROR)
      return -- keep existing buffer content rather than deleting it
    end

    local path = strip_pdf_uri(ev.match)

    if vim.fn.filereadable(path) == 0 then
      vim.notify(('PDF not found: %s'):format(path), vim.log.levels.ERROR)
      vim.api.nvim_buf_delete(ev.buf, { force = true })
      return
    end

    load_pdf(ev.buf, path)
  end,
})

----------------------------------------------------------------------
-- BufWriteCmd
----------------------------------------------------------------------

vim.api.nvim_create_autocmd('BufWriteCmd', {
  group = group,
  pattern = 'pdf://*',
  desc = 'Reject writes to PDF buffers',
  callback = function()
    vim.notify('PDF buffers are read-only', vim.log.levels.WARN)
    vim.bo.modified = false
  end,
})

return {}
