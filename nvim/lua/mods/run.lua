--- run.lua
---
--- Unified command runner that routes to a terminal buffer or a static
--- capture buffer depending on the argument.
---
--- Commands:
---   :Run                   fuzzy picker over history
---   :Run {shell cmd}       run in a terminal buffer (live output)
---   :Run :{ex cmd}         run ex command, capture output in a buffer
---   :Run !!                re-run the most recently used command
---
--- Without !, the split opens but focus returns to the current window.
--- With !, focus moves to the terminal or capture buffer.
---
--- Shell commands always open a terminal buffer. Ex commands (`:` prefix)
--- always produce a static capture buffer. There is no force-capture flag.
---
--- Terminal buffers: listed, bufhidden=hide. Use natural term:// naming;
--- identified by b:run_entry. Each run opens a new buffer.
--- Capture buffers: unlisted, bufhidden=hide. Named capture://~/{path}//{n}:{cmd}.
--- Each run opens a new buffer; hidden buffers persist and are reachable
--- via :b capture<Tab>.
---
--- History is persisted at stdpath('data')/run_history (JSON lines),
--- capped at 40 entries. Deduplication is full: identical (cmd, cwd) pairs
--- for terminal entries, identical cmd for ex entries, are collapsed to one
--- entry which moves to the top on re-use. Picker selections push to history
--- so :Run !! always re-runs the last executed command.

local HISTORY_FILE = vim.fn.stdpath('data') .. '/run_history'
local MAX_HISTORY = 40
local MAX_CMD_DISP = 50

----------------------------------------------------------------------
-- History
----------------------------------------------------------------------

---@class RunEntry
---@field cmd  string
---@field cwd  string
---@field mode '"terminal"' | '"ex"'

---@type RunEntry[]
local history = {}

local function save_history()
  vim.fn.mkdir(vim.fn.fnamemodify(HISTORY_FILE, ':h'), 'p')
  vim.fn.writefile(vim.tbl_map(vim.json.encode, history), HISTORY_FILE)
end

local function load_history()
  if vim.fn.filereadable(HISTORY_FILE) ~= 1 then return end
  for _, line in ipairs(vim.fn.readfile(HISTORY_FILE)) do
    local ok, e = pcall(vim.json.decode, line)
    if ok and e.cmd and e.cwd and e.mode then
      table.insert(history, { cmd = e.cmd, cwd = e.cwd, mode = e.mode })
    end
  end
end

load_history()

--- Full dedup: if an identical entry exists anywhere in history, remove it
--- first, then push the new entry to the tail. Cap at MAX_HISTORY.
---@param entry RunEntry
local function push_history(entry)
  for i = #history, 1, -1 do
    local e = history[i]
    if
      e.cmd == entry.cmd
      and e.mode == entry.mode
      and (entry.mode == 'ex' or e.cwd == entry.cwd)
    then
      table.remove(history, i)
      break
    end
  end
  table.insert(history, entry)
  while #history > MAX_HISTORY do
    table.remove(history, 1)
  end
  save_history()
end

----------------------------------------------------------------------
-- Path shortening
----------------------------------------------------------------------

local MAX_CWD_LEN = 30

---@param p string
---@return string
local function tilde_path(p)
  local home = vim.env.HOME
  if home and vim.startswith(p, home) then return '~' .. p:sub(#home + 1) end
  return p
end

---@param p string
---@return string
local function short_path(p)
  p = tilde_path(p)
  if #p <= MAX_CWD_LEN then return p end
  return '…' .. p:sub(#p - MAX_CWD_LEN + 2)
end

----------------------------------------------------------------------
-- ANSI stripping
----------------------------------------------------------------------

---@param text string
---@return string
local function strip_ansi(text) return text:gsub('\27%[[%d;]*[A-Za-z]', '') end

----------------------------------------------------------------------
-- Terminal buffer
----------------------------------------------------------------------

---@param entry RunEntry
---@param bang  boolean
local function run_terminal(entry, bang)
  local prev_win = vim.api.nvim_get_current_win()

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].buflisted = true
  vim.bo[bufnr].bufhidden = 'hide'
  -- Set run_entry before termopen so it is available immediately.
  vim.b[bufnr].run_entry = entry
  vim.cmd('bo split | b ' .. bufnr)
  vim.fn.termopen(entry.cmd, { cwd = entry.cwd })

  -- TermOpen fires once the job has started and terminal_job_id is
  -- available — we wait here because we need job_id for TermClose.
  vim.api.nvim_create_autocmd('TermOpen', {
    buffer = bufnr,
    once = true,
    callback = function()
      local job_id = vim.b[bufnr].terminal_job_id
      vim.api.nvim_create_autocmd('TermClose', {
        buffer = bufnr,
        once = true,
        callback = function()
          local code = vim.fn.jobwait({ job_id }, 0)[1]
          if code == 0 then
            vim.notify(entry.cmd .. ' (ok)', vim.log.levels.INFO)
          elseif code > 0 then
            vim.notify(
              entry.cmd .. ' exited with code ' .. code,
              vim.log.levels.WARN
            )
          end
          -- code < 0: signal kill — no notification.
        end,
      })
    end,
  })

  if not bang then vim.api.nvim_set_current_win(prev_win) end
end

----------------------------------------------------------------------
-- Capture buffer
----------------------------------------------------------------------

---@param entry RunEntry
---@param bang  boolean
local function run_capture(entry, bang)
  local prev_win = vim.api.nvim_get_current_win()
  local prev_dir = vim.fn.getcwd(0)
  local ok_cd, cd_err = pcall(vim.api.nvim_set_current_dir, entry.cwd)
  if not ok_cd then
    vim.notify(
      'Run: could not set cwd: ' .. tostring(cd_err),
      vim.log.levels.WARN
    )
  end

  local ok, result =
    pcall(vim.api.nvim_exec2, entry.cmd:sub(2), { output = true })
  pcall(vim.api.nvim_set_current_dir, prev_dir)

  if not ok then
    vim.notify('Run: ' .. tostring(result), vim.log.levels.ERROR)
    return
  end

  local raw = strip_ansi(result.output)
  local lines = vim.split(vim.trim(raw), '\n', { plain = true })
  if #lines == 1 and lines[1] == '' then lines = {} end

  local bufnr = vim.api.nvim_create_buf(false, true)
  local name = 'capture://'
    .. tilde_path(entry.cwd)
    .. '//'
    .. tostring(bufnr)
    .. ':'
    .. entry.cmd:sub(2)
  vim.bo[bufnr].buftype = 'nofile'
  vim.bo[bufnr].bufhidden = 'hide'
  vim.bo[bufnr].buflisted = false
  vim.api.nvim_buf_set_name(bufnr, name)
  vim.b[bufnr].run_entry = entry
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  local ok, ft = pcall(vim.filetype.match, { buf = bufnr })
  if ok and ft then vim.bo[bufnr].filetype = ft end

  vim.cmd('bo split | b ' .. bufnr)
  if not bang then vim.api.nvim_set_current_win(prev_win) end
end

----------------------------------------------------------------------
-- Picker
----------------------------------------------------------------------

local function cap_cmd(cmd)
  if #cmd <= MAX_CMD_DISP then return cmd end
  return cmd:sub(1, MAX_CMD_DISP - 1) .. '…'
end

---@param entries RunEntry[]
---@param bang    boolean
local function open_picker(entries, bang)
  if #entries == 0 then
    vim.notify('Run history is empty', vim.log.levels.INFO)
    return
  end

  -- Show newest first (history tail = most recently used).
  local items = {}
  for i = #entries, 1, -1 do
    table.insert(items, entries[i])
  end

  local max_cmd = 0
  for _, e in ipairs(items) do
    local len = math.min(#e.cmd, MAX_CMD_DISP)
    if len > max_cmd then max_cmd = len end
  end

  local display_map = {}
  for _, e in ipairs(items) do
    display_map[e] = string.format(
      '%-' .. tostring(max_cmd + 1) .. 's  %-4s  %s',
      cap_cmd(e.cmd),
      e.mode == 'ex' and 'ex' or 'term',
      short_path(e.cwd)
    )
  end

  vim.ui.select(items, {
    prompt = 'Run history',
    format_item = function(item) return display_map[item] or item.cmd end,
  }, function(choice)
    if not choice then return end
    -- Push to history so :Run !! correctly refers to the last executed command.
    push_history(choice)
    if choice.mode == 'terminal' then
      run_terminal(choice, bang)
    else
      run_capture(choice, bang)
    end
  end)
end

----------------------------------------------------------------------
-- Command handler
----------------------------------------------------------------------

---@param tbl { args: string, bang: boolean }
local function run_command(tbl)
  local raw = tbl.args
  local bang = tbl.bang

  -- :Run with no args → picker.
  if raw == '' then
    open_picker(history, bang)
    return
  end

  -- :Run !! → re-run most recently used.
  if raw == '!!' then
    if #history == 0 then
      vim.notify('Run history is empty', vim.log.levels.WARN)
      return
    end
    local last = history[#history]
    if last.mode == 'terminal' then
      run_terminal(last, bang)
    else
      run_capture(last, bang)
    end
    return
  end

  local mode = vim.startswith(raw, ':') and 'ex' or 'terminal'
  local entry = { cmd = raw, cwd = vim.fn.getcwd(0), mode = mode }

  if mode == 'terminal' then
    run_terminal(entry, bang)
  else
    run_capture(entry, bang)
  end

  push_history(entry)
end

----------------------------------------------------------------------
-- Command registration
----------------------------------------------------------------------

vim.api.nvim_create_user_command('Run', run_command, {
  nargs = '*',
  bang = true,
  desc = 'Run a shell or ex command. Without !, split opens but focus stays. With !, focus moves to the buffer.',
})

return {}
