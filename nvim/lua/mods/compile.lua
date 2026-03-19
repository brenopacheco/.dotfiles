-- compile.nvim — run shell commands in a terminal buffer, rerun them easily.
--
-- SETUP
--   require("compile").setup({
--     mappings = {
--       recompile = "r",   -- key to rerun; set to false to disable
--       close     = "q",   -- key to close compile window; set to false to disable
--     }
--   })
--
-- COMMANDS
--   :Compile [dir] {cmd}
--     Run {cmd} in the given directory. If dir is omitted, uses the current
--     working directory. The dir argument must be prefixed with @ and come first:
--
--       :Compile make                  -- cwd
--       :Compile @/other/dir make      -- absolute path
--       :Compile @../  make            -- relative to cwd
--       :Compile @~/project make       -- home-relative
--       :Compile @src make             -- relative to cwd
--       :Compile @@ make               -- git root of cwd, or cwd if not in a repo
--
--     Tab completion: after @, directories are completed. After the dir token
--     (or from the start if no @), shell command completion applies.
--
--     Each run opens (or reuses) the compile window at the bottom of the screen
--     and focuses it. The command is recorded in Neovim's command history in
--     canonical form (@/abs/path) so it persists across sessions via ShaDa.
--
--     With no arguments, opens a picker (session entries + ShaDa history) and
--     pre-populates the command line with the selection for editing.
--
--   :Compiled [name]
--     Without {name}: opens a picker (vim.ui.select) listing all compile buffers
--     in the current session, each showing [status] cmd (dir). Select an entry
--     to open it in the compile window.
--     With {name}: jump directly to the first compile buffer whose name contains
--     {name} as a substring. Tab-completes against compile buffer names.
--
--   :Recompile
--     Immediately rerun the most recently started compile entry in this session.
--     Creates a new entry (new buffer). If the entry is still running, prompts
--     for confirmation before stopping it. Takes no arguments.
--
-- COMPILE WINDOW
--   At most one compile window is open at a time (bottom split). Running a new
--   compile or calling compile.open() always focuses it. Closing it with :q or
--   q (default mapping) keeps the buffer; the next compile reopens the window.
--
-- COMPILE BUFFERS
--   Each compile run produces a terminal buffer named compile://{dir}//{pid}:{cmd}.
--   Buffers carry a b:compile variable with the entry data (see below). Buffers
--   manage their listed state automatically:
--     - Listed while the entry is running.
--     - Unlisted when the entry finishes and the buffer is already visible,
--       or when the user enters the buffer after it has finished.
--     - Unlisted immediately when the entry is rerun.
--
--   b:compile fields:
--     id          integer, unique per session
--     dir         string, absolute path
--     cmd         string
--     status      "running" | "success" | "failure" | "stopped"
--     started_at  ISO 8601 string
--     finished_at ISO 8601 string, or nil if still running
--     exit_code   integer, or nil if running or stopped
--     bufnr       integer
--
-- BUFFER MAPPINGS (in compile buffers)
--   n  r    Rerun this buffer's compile entry (prompts if still running)
--   n  q    Close the compile window (keep buffer)
--   r and q are configurable or disableable via setup().
--
-- HIGHLIGHTS (for picker and statusline use)
--   CompileRunning  (default: DiagnosticInfo)
--   CompileSuccess  (default: DiagnosticOk)
--   CompileFailure  (default: DiagnosticError)
--   CompileStopped  (default: Comment)
--   Access current status via vim.b.compile.status.
--
-- NOTIFICATIONS
--   vim.notify is called on finish/stop:
--     success → INFO level
--     failure → ERROR level
--     stopped → WARN level
--
-- EVENTS (User autocmds)
--   CompileStarted   after jobstart(); b:compile is set
--   CompileFinished  after exit (success or failure); b:compile is final
--   CompileStopped   after jobstop(); b:compile is final
--
--   All events provide:
--     ev.data          snapshot of b:compile at the moment of firing
--     ev.data.bufnr    compile buffer number
--
-- PUBLIC API
--   compile.run(cmd, opts)    start a compile; opts.dir must be an absolute path
--   compile.recompile(id?)    rerun by id or latest; new entry created; prompts if running
--   compile.list()            list of all in-session entries with valid buffers
--   compile.open(id?)         show entry in compile window (current entry if omitted)
--   compile.close()           close compile window, keep buffer
--   compile.last()            most recently started entry, or nil

local M = {}

local _config = {}
local _last_bufnr = nil -- bufnr of the most recently started compile buffer

-- ---------------------------------------------------------------------------
-- Timestamp helpers
-- ---------------------------------------------------------------------------

local function _now() return os.date('!%Y-%m-%dT%H:%M:%SZ') end

-- ---------------------------------------------------------------------------
-- Buffer / window scanning
-- ---------------------------------------------------------------------------

-- Returns the bufnr of the compile buffer with the given id, or nil.
local function _find_bufnr_by_id(id)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local entry = vim.b[bufnr].compile
      if type(entry) == 'table' and entry.id == id then return bufnr end
    end
  end
end

-- Returns the winid of the compile window, or nil.
local function _find_compile_win()
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    if vim.w[winid].compile_window == true then return winid end
  end
end

-- Returns the next available compile entry id (max existing + 1, or 1).
local function _next_id()
  local max = 0
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local entry = vim.b[bufnr].compile
      if
        type(entry) == 'table'
        and type(entry.id) == 'number'
        and entry.id > max
      then
        max = entry.id
      end
    end
  end
  return max + 1
end

-- ---------------------------------------------------------------------------
-- Entry state helpers
-- ---------------------------------------------------------------------------

-- Read-modify-write b:compile (vim.b returns a copy, must reassign to persist).
local function _update_compile(bufnr, fields)
  local t = vim.b[bufnr].compile
  for k, v in pairs(fields) do
    t[k] = v
  end
  vim.b[bufnr].compile = t
end

-- Unlist a buffer (idempotent).
local function _unlist(bufnr)
  if vim.api.nvim_buf_is_valid(bufnr) then vim.bo[bufnr].buflisted = false end
end

-- ---------------------------------------------------------------------------
-- Events
-- ---------------------------------------------------------------------------

local function _fire_event(pattern, bufnr)
  -- 'pattern' and 'buf' are mutually exclusive in nvim_exec_autocmds.
  -- bufnr is available to handlers via ev.data.bufnr (it is a b:compile field).
  vim.api.nvim_exec_autocmds('User', {
    pattern = pattern,
    data = vim.deepcopy(vim.b[bufnr].compile),
    modeline = false,
  })
end

-- ---------------------------------------------------------------------------
-- Directory resolution
-- ---------------------------------------------------------------------------

-- Takes the @-prefixed dir argument as typed (e.g. "@src", "@@"), or nil.
-- Returns an absolute path string.
local function _resolve_dir(dir_arg)
  if dir_arg == nil or dir_arg == '@' or dir_arg == '@.' then
    return vim.fn.getcwd()
  end

  if dir_arg == '@@' then
    local git_root = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null')
    git_root = vim.trim(git_root)
    if git_root == '' or vim.v.shell_error ~= 0 then return vim.fn.getcwd() end
    return git_root
  end

  -- Strip leading @ and resolve relative/home paths to absolute.
  local path = dir_arg:sub(2)
  local resolved = vim.fn.fnamemodify(path, ':p')
  -- Strip trailing slash (unless it's the filesystem root).
  if #resolved > 1 then resolved = resolved:gsub('/$', '') end
  return resolved
end

-- ---------------------------------------------------------------------------
-- Completion
-- ---------------------------------------------------------------------------

-- Custom completion for :Compile. Returns directory completions when arglead
-- starts with @, otherwise shell command completions.
local function _compile_complete(arglead, _cmdline, _curpos)
  -- If typing the @dir token: directory completion.
  if arglead:sub(1, 1) == '@' then
    local dir_part = arglead:sub(2)
    local completions = vim.fn.getcompletion(dir_part, 'dir')
    return vim.tbl_map(function(c) return '@' .. c end, completions)
  end

  -- Everything else (command after @dir, or bare command): shell command completion.
  return vim.fn.getcompletion(arglead, 'shellcmd')
end

-- Completion for :Compiled — completes against compile buffer names.
local function _compiled_complete(arglead, cmdline, _curpos)
  -- Stop completing once one argument has already been provided.
  local args_str = cmdline:gsub('^%s*Compiled%s*', '')
  local prefix = args_str:sub(1, #args_str - #arglead)
  if prefix:match('%S') then return {} end

  local names = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_valid(bufnr)
      and type(vim.b[bufnr].compile) == 'table'
    then
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name ~= '' and (arglead == '' or name:find(arglead, 1, true)) then
        table.insert(names, name)
      end
    end
  end
  return names
end

-- ---------------------------------------------------------------------------
-- History normalization
-- ---------------------------------------------------------------------------

-- After :Compile runs, replace the typed form in command history with the
-- canonical "Compile @/abs/path cmd" form. This ensures ShaDa persistence
-- is cwd-independent across sessions.
local function _normalize_history(dir, cmd)
  -- Escape spaces in dir so the canonical form is unambiguously parseable.
  local canonical = 'Compile @' .. dir:gsub(' ', '\\ ') .. ' ' .. cmd
  local n = vim.fn.histnr('cmd')
  local last = vim.fn.histget('cmd', n)
  -- Only replace if the most recent history entry looks like our command.
  if last:match('^Compile%s') then vim.fn.histdel('cmd', n) end
  vim.fn.histadd('cmd', canonical)
end

-- ---------------------------------------------------------------------------
-- Window management
-- ---------------------------------------------------------------------------

-- Returns the compile window id, creating a bottom split if needed.
-- Sets w:compile_window = true to mark it.
local function _get_or_create_window()
  local winid = _find_compile_win()
  if winid then return winid end
  vim.cmd('botright split')
  winid = vim.api.nvim_get_current_win()
  vim.w[winid].compile_window = true
  return winid
end

-- ---------------------------------------------------------------------------
-- Buffer-local mappings
-- ---------------------------------------------------------------------------

local function _apply_mappings(bufnr)
  local actions = {
    recompile = function() M.recompile(vim.b[bufnr].compile.id) end,
    close = M.close,
  }
  for action, fn in pairs(actions) do
    local key = _config.mappings[action]
    if key then
      vim.keymap.set(
        'n',
        key,
        fn,
        { buffer = bufnr, silent = true, nowait = true }
      )
    end
  end
end

-- ---------------------------------------------------------------------------
-- Job lifecycle handlers
-- ---------------------------------------------------------------------------

-- Called from the BufEnter autocmd on a compile buffer.
-- Unlists the buffer once the user enters it after the entry has finished.
local function _on_buf_enter(bufnr)
  local entry = vim.b[bufnr].compile
  if type(entry) ~= 'table' then return end
  if entry.status ~= 'running' then _unlist(bufnr) end
end

-- Called from the TermClose autocmd (once) on a compile buffer.
local function _on_term_close(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end

  local entry = vim.b[bufnr].compile
  if type(entry) ~= 'table' then return end

  -- _stop_entry() sets status='stopped' before jobstop(), so TermClose fires
  -- after the process exits. Bail out to avoid overwriting the stopped state.
  if entry.status == 'stopped' then return end

  local exit_code = vim.v.event.status
  local status = exit_code == 0 and 'success' or 'failure'

  _update_compile(bufnr, {
    status = status,
    exit_code = exit_code,
    finished_at = _now(),
  })

  -- Unlist immediately if the buffer is already visible.
  if vim.fn.bufwinid(bufnr) ~= -1 then _unlist(bufnr) end

  -- Exit terminal mode so the user isn't left in t-mode on a dead terminal.
  if
    vim.api.nvim_get_mode().mode == 't'
    and vim.api.nvim_get_current_buf() == bufnr
  then
    vim.cmd('stopinsert')
  end

  -- Defer notification and event firing to after the TermClose handler returns.
  -- Calling nvim_err_writeln (used by ERROR-level notify) inside an autocmd
  -- callback causes Neovim to prepend "Error in TermClose Autocommands".
  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    pcall(function() vim.bo[bufnr].modifiable = false end)
    local cmd = vim.b[bufnr].compile.cmd
    if status == 'success' then
      vim.notify(
        ('compile: %s finished successfully'):format(cmd),
        vim.log.levels.INFO
      )
    else
      vim.notify(
        ('compile: %s failed (exit %d)'):format(cmd, exit_code),
        vim.log.levels.ERROR
      )
    end
    _fire_event('CompileFinished', bufnr)
  end)
end

-- Stops a running compile entry. Sets status before jobstop() so the async
-- TermClose handler sees 'stopped' and returns early.
local function _stop_entry(bufnr)
  local cmd = vim.b[bufnr].compile.cmd

  _update_compile(bufnr, {
    status = 'stopped',
    finished_at = _now(),
    exit_code = vim.NIL,
  })

  local job_id = vim.b[bufnr].terminal_job_id
  if job_id then vim.fn.jobstop(job_id) end

  _unlist(bufnr)
  pcall(function() vim.bo[bufnr].modifiable = false end)

  vim.notify(('compile: %s stopped'):format(cmd), vim.log.levels.WARN)

  -- CompileStopped fires synchronously (unlike CompileFinished which is deferred
  -- via vim.schedule). _stop_entry is never called from a TermClose autocmd, so
  -- nvim_err_writeln inside ERROR-level notify is safe here.
  _fire_event('CompileStopped', bufnr)
end

-- Returns _last_bufnr if it is still valid, else nil.
local function _last_valid_bufnr()
  if _last_bufnr and vim.api.nvim_buf_is_valid(_last_bufnr) then
    return _last_bufnr
  end
end

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

-- Run cmd (string) in opts.dir (absolute path). Opens/reuses the compile
-- window. Returns true on success, false on failure.
function M.run(cmd, opts)
  opts = opts or {}
  local dir = opts.dir or vim.fn.getcwd()

  local entry_id = _next_id()
  local is_new_win = not _find_compile_win()
  local winid = _get_or_create_window()
  local prev_bufnr = vim.api.nvim_win_get_buf(winid)
  vim.api.nvim_set_current_win(winid)
  local lcd_ok, lcd_err = pcall(vim.cmd, 'lcd ' .. vim.fn.fnameescape(dir))
  if not lcd_ok then
    if is_new_win then
      if vim.api.nvim_win_is_valid(winid) then
        vim.api.nvim_win_close(winid, false)
      end
    elseif
      vim.api.nvim_win_is_valid(winid) and vim.api.nvim_buf_is_valid(prev_bufnr)
    then
      vim.api.nvim_win_set_buf(winid, prev_bufnr)
    end
    vim.notify(('compile: %s'):format(lcd_err), vim.log.levels.ERROR)
    return false
  end

  local bufnr = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_win_set_buf(winid, bufnr)

  local job_id = vim.fn.jobstart(cmd, { term = true, cwd = dir })
  if job_id <= 0 then
    vim.api.nvim_buf_delete(bufnr, { force = true })
    -- Undo window changes: close if newly created, restore previous buffer otherwise.
    -- Guard with win_is_valid: nvim_buf_delete may have already closed the window
    -- (e.g. when the scratch buffer was the only thing in the split).
    if is_new_win then
      if vim.api.nvim_win_is_valid(winid) then
        vim.api.nvim_win_close(winid, false)
      end
    elseif
      vim.api.nvim_win_is_valid(winid) and vim.api.nvim_buf_is_valid(prev_bufnr)
    then
      vim.api.nvim_win_set_buf(winid, prev_bufnr)
    end
    vim.notify(
      ('compile: failed to start job (jobstart returned %d)'):format(job_id),
      vim.log.levels.ERROR
    )
    return false
  end

  -- jobstart({term=true}) may set bufhidden=wipe; override so the buffer
  -- survives when the compile window is closed.
  vim.bo[bufnr].bufhidden = 'hide'

  -- Rename from term:// to compile://.
  local buf_name = vim.api.nvim_buf_get_name(bufnr)
  local compile_name = buf_name:gsub('^term://', 'compile://')
  vim.api.nvim_buf_set_name(bufnr, compile_name)
  -- nvim_buf_set_name on a terminal buffer leaves a stray buffer carrying the
  -- old term:// name. Delete it immediately.
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= bufnr and vim.api.nvim_buf_get_name(b) == buf_name then
      vim.api.nvim_buf_delete(b, { force = true })
      break
    end
  end

  -- Write entry data to b:compile.
  vim.b[bufnr].compile = {
    id = entry_id,
    dir = dir,
    cmd = cmd,
    status = 'running',
    started_at = _now(),
    finished_at = vim.NIL,
    exit_code = vim.NIL,
    bufnr = bufnr,
  }
  vim.bo[bufnr].buflisted = true
  _last_bufnr = bufnr

  _apply_mappings(bufnr)

  -- TermClose fires once when the process exits (or after jobstop()).
  vim.api.nvim_create_autocmd('TermClose', {
    buffer = bufnr,
    once = true,
    callback = function() _on_term_close(bufnr) end,
  })

  -- BufEnter fires every time the user enters this buffer.
  vim.api.nvim_create_autocmd('BufEnter', {
    buffer = bufnr,
    callback = function() _on_buf_enter(bufnr) end,
  })

  -- Prevent entering terminal mode on a finished buffer.
  vim.api.nvim_create_autocmd('TermEnter', {
    buffer = bufnr,
    callback = function()
      local entry = vim.b[bufnr].compile
      if type(entry) == 'table' and entry.status ~= 'running' then
        vim.schedule(function()
          vim.cmd('stopinsert')
          vim.fn.getchar()
          M.close()
        end)
      end
    end,
  })

  _fire_event('CompileStarted', bufnr)
  return true
end

-- Rerun the entry identified by id, or the most recently started entry.
-- Always creates a new entry. Prompts for confirmation only if running.
function M.recompile(id)
  local bufnr
  if id then
    bufnr = _find_bufnr_by_id(id)
  else
    bufnr = _last_valid_bufnr()
  end
  if not bufnr then
    vim.notify('compile: no compile entry found', vim.log.levels.WARN)
    return
  end

  local entry = vim.b[bufnr].compile
  if type(entry) ~= 'table' then
    vim.notify('compile: entry data missing', vim.log.levels.WARN)
    return
  end

  if entry.status == 'running' then
    local choice = vim.fn.confirm(
      ('compile: "%s" is still running. Stop and rerun?'):format(entry.cmd),
      '&Yes\n&No',
      2
    )
    if choice ~= 1 then return end
    _stop_entry(bufnr)
  else
    -- Unlist the old buffer immediately on rerun.
    _unlist(bufnr)
  end

  M.run(entry.cmd, { dir = entry.dir })
end

-- Returns a list of all in-session compile entries (sorted by id, ascending).
function M.list()
  local entries = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local entry = vim.b[bufnr].compile
      if type(entry) == 'table' then table.insert(entries, entry) end
    end
  end
  table.sort(entries, function(a, b) return a.id < b.id end)
  return entries
end

-- Show the compile buffer for the given entry id (or current entry) in the
-- compile window. Opens the window if needed.
function M.open(id)
  local bufnr
  if id then
    bufnr = _find_bufnr_by_id(id)
    if not bufnr then
      vim.notify(
        ('compile: entry %d not found'):format(id),
        vim.log.levels.WARN
      )
      return
    end
  else
    bufnr = _last_valid_bufnr()
  end
  if not bufnr then return end

  local winid = _get_or_create_window()
  vim.api.nvim_win_set_buf(winid, bufnr)
  vim.api.nvim_set_current_win(winid)
  local entry = vim.b[bufnr].compile
  if type(entry) == 'table' then
    vim.cmd('lcd ' .. vim.fn.fnameescape(entry.dir))
  end
end

-- Close the compile window without deleting the buffer.
function M.close()
  local winid = _find_compile_win()
  if winid then
    if vim.fn.winnr('$') > 1 then
      vim.api.nvim_win_close(winid, false)
    else
      local alt = vim.fn.bufnr('#')
      if alt ~= -1 and vim.fn.buflisted(alt) == 1 then
        vim.cmd('buffer #')
      else
        vim.cmd('bnext')
      end
    end
  end
end

-- Returns the most recently started compile entry in this session, or nil.
function M.last()
  local bufnr = _last_valid_bufnr()
  return bufnr and vim.b[bufnr].compile or nil
end

-- ---------------------------------------------------------------------------
-- Command setup
-- ---------------------------------------------------------------------------

-- Split "escaped-dir cmd" where spaces in dir are backslash-escaped.
-- Returns (dir, cmd) with dir unescaped, or nothing on parse failure.
local function _split_dir_cmd(s)
  local i = 1
  while i <= #s do
    if s:sub(i, i) == '\\' then
      i = i + 2 -- skip escape sequence
    elseif s:sub(i, i) == ' ' then
      local dir = s:sub(1, i - 1):gsub('\\ ', ' ')
      local cmd = s:sub(i + 1)
      if cmd ~= '' then return dir, cmd end
      return
    else
      i = i + 1
    end
  end
end

-- Deduplicated candidate list for the :Compile picker: session entries
-- (newest first) followed by ShaDa history entries not already seen.
local function _recompile_candidates()
  local session_entries = M.list()
  local seen = {}
  local items = {}

  for i = #session_entries, 1, -1 do
    local entry = session_entries[i]
    local key = entry.dir .. '\0' .. entry.cmd
    if not seen[key] then
      seen[key] = true
      table.insert(items, {
        label = ('[%s] %s (%s)'):format(entry.status, entry.cmd, entry.dir),
        dir = entry.dir,
        cmd = entry.cmd,
      })
    end
  end

  local n = vim.fn.histnr('cmd')
  for i = n, 1, -1 do
    local hist_entry = vim.fn.histget('cmd', i)
    local rest = hist_entry:match('^Compile @(.+)$')
    local dir, cmd
    if rest then
      dir, cmd = _split_dir_cmd(rest)
    end
    if dir and cmd then
      local key = dir .. '\0' .. cmd
      if not seen[key] then
        seen[key] = true
        table.insert(items, {
          label = ('%s (%s)'):format(cmd, dir),
          dir = dir,
          cmd = cmd,
        })
      end
    end
  end

  return items
end

local function _setup_commands()
  -- :Compile [dir] {cmd}
  vim.api.nvim_create_user_command('Compile', function(opts)
    local fargs = opts.fargs

    if #fargs == 0 then
      -- No arguments: open picker to pre-populate the command line.
      local candidates = _recompile_candidates()
      if #candidates == 0 then
        vim.notify(
          'compile: no previous compile commands found',
          vim.log.levels.INFO
        )
        return
      end
      vim.ui.select(candidates, {
        prompt = 'Compile',
        format_item = function(item) return item.label end,
      }, function(item)
        if not item then return end
        vim.schedule(function()
          -- setcmdline() only works while the cmdline is already open (cmdline
          -- mode). By the time vim.ui.select returns, Neovim is back in normal
          -- mode, so setcmdline silently does nothing. feedkeys(':...') opens
          -- the cmdline and pre-populates it in one shot.
          vim.fn.feedkeys(
            ':Compile @' .. item.dir:gsub(' ', '\\ ') .. ' ' .. item.cmd,
            'n'
          )
        end)
      end)
      return
    end

    local dir_arg
    local cmd_start = 1

    if fargs[1] and fargs[1]:sub(1, 1) == '@' then
      dir_arg = fargs[1]
      cmd_start = 2
    end

    local dir = _resolve_dir(dir_arg)

    if vim.fn.isdirectory(dir) == 0 then
      vim.notify(
        ('compile: directory not found: %s'):format(dir),
        vim.log.levels.ERROR
      )
      return
    end

    local cmd_parts = {}
    for i = cmd_start, #fargs do
      table.insert(cmd_parts, fargs[i])
    end

    if #cmd_parts == 0 then
      vim.notify('compile: no command specified', vim.log.levels.ERROR)
      return
    end

    local cmd = table.concat(cmd_parts, ' ')
    local ok = M.run(cmd, { dir = dir })
    if ok then _normalize_history(dir, cmd) end
  end, {
    nargs = '*',
    complete = _compile_complete,
  })

  -- :Compiled [name]
  vim.api.nvim_create_user_command('Compiled', function(opts)
    local name = opts.args ~= '' and opts.args or nil

    if name then
      -- Direct jump: find first buffer whose compile:// name contains name.
      for _, entry in ipairs(M.list()) do
        local buf_name = vim.api.nvim_buf_get_name(entry.bufnr)
        if buf_name:find(name, 1, true) then
          M.open(entry.id)
          return
        end
      end
      vim.notify(
        ('compile: no buffer matching %q'):format(name),
        vim.log.levels.ERROR
      )
      return
    end

    -- Picker: show all in-session entries, latest first.
    local entries = M.list()
    if #entries == 0 then
      vim.notify(
        'compile: no compile buffers in this session',
        vim.log.levels.INFO
      )
      return
    end

    local items = {}
    for i = #entries, 1, -1 do
      local entry = entries[i]
      local label = ('[%s] %s (%s)'):format(entry.status, entry.cmd, entry.dir)
      table.insert(items, { entry = entry, label = label })
    end

    vim.ui.select(items, {
      prompt = 'Compiled',
      format_item = function(item) return item.label end,
    }, function(item)
      if item then M.open(item.entry.id) end
    end)
  end, {
    nargs = '?',
    complete = _compiled_complete,
  })

  -- :Recompile  — immediately rerun the most recently started entry
  vim.api.nvim_create_user_command(
    'Recompile',
    function(_opts) M.recompile() end,
    {
      nargs = 0,
    }
  )
end

-- ---------------------------------------------------------------------------
-- Highlight groups
-- ---------------------------------------------------------------------------

local function _setup_highlights()
  vim.api.nvim_set_hl(
    0,
    'CompileRunning',
    { link = 'DiagnosticInfo', default = true }
  )
  vim.api.nvim_set_hl(
    0,
    'CompileSuccess',
    { link = 'DiagnosticOk', default = true }
  )
  vim.api.nvim_set_hl(
    0,
    'CompileFailure',
    { link = 'DiagnosticError', default = true }
  )
  vim.api.nvim_set_hl(0, 'CompileStopped', {
    link = 'Comment',
    default = true,
  })
end

-- ---------------------------------------------------------------------------
-- Entry point
-- ---------------------------------------------------------------------------

function M.setup(opts)
  local defaults = {
    mappings = {
      recompile = 'r',
      close = 'q',
    },
  }
  _config = vim.tbl_deep_extend('force', defaults, opts or {})
  _setup_highlights()
  _setup_commands()
end

M.setup()

return M
