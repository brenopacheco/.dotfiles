-- compile.lua — terminal compile runner.
-- :Compile {cmd}  /  :Recompile

local M = {}

local _config = {}
local _current_bufnr = nil

local function _stop_running()
  if not _current_bufnr or not vim.api.nvim_buf_is_valid(_current_bufnr) then
    return
  end
  local entry = vim.b[_current_bufnr].compile
  if not entry or entry.status ~= 'running' then
    return
  end
  local choice = vim.fn.confirm(
    ('compile: "%s" is still running.'):format(entry.cmd),
    '&Stop it\nCancel',
    1
  )
  if choice == 1 then
    entry.status = 'stopped'
    if entry.job_id then
      vim.fn.jobstop(entry.job_id)
    end
  else
    return false
  end
end

local function _find_compile_win()
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    if vim.w[winid].compile_window == true then
      return winid
    end
  end
end

local function _get_or_create_window()
  local winid = _find_compile_win()
  if winid then return winid end
  vim.cmd('botright split')
  winid = vim.api.nvim_get_current_win()
  vim.w[winid].compile_window = true
  return winid
end

local function _recompile(opts)
  opts = opts or {}
  if not _current_bufnr or not vim.api.nvim_buf_is_valid(_current_bufnr) then
    vim.notify('compile: no compile entry found', vim.log.levels.WARN)
    return
  end
  local entry = vim.b[_current_bufnr].compile
  M.compile(entry.cmd, { focus = opts.focus, dir = entry.dir })
end

function M.compile(cmd, opts)
  opts = opts or {}
  local dir = opts.dir or vim.fn.getcwd(0)

  if _stop_running() == false then return false end

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and type(vim.b[bufnr].compile) == 'table' then
      vim.bo[bufnr].buflisted = false
    end
  end

  local bufnr = vim.api.nvim_create_buf(false, false)
  local job_id
  vim.api.nvim_buf_call(
    bufnr,
    function() job_id = vim.fn.jobstart(cmd, { term = true, cwd = dir }) end
  )

  if job_id <= 0 then
    vim.api.nvim_buf_delete(bufnr, { force = true })
    vim.notify(
      ('compile: failed to start job (jobstart returned %d)'):format(job_id),
      vim.log.levels.ERROR
    )
    return false
  end

  vim.bo[bufnr].bufhidden = 'hide'
  vim.bo[bufnr].buflisted = true
  vim.b[bufnr].compile = { dir = dir, cmd = cmd, status = 'running', job_id = job_id }
  _current_bufnr = bufnr

  if _config.scroll_on_output then
    vim.api.nvim_buf_attach(bufnr, false, {
      on_lines = function()
        local w = vim.fn.bufwinid(bufnr)
        if w ~= -1 then
          vim.api.nvim_win_set_cursor(w, { vim.api.nvim_buf_line_count(bufnr), 0 })
        end
      end,
    })
  end

  vim.api.nvim_create_autocmd('TermClose', {
    buffer = bufnr,
    once = true,
    callback = function()
      if not vim.api.nvim_buf_is_valid(bufnr) then return end
      local entry = vim.b[bufnr].compile
      if entry.status == 'stopped' then return end

      local exit_code = vim.v.event.status
      entry.status = exit_code == 0 and 'success' or 'failure'

      if exit_code == 0 then
        vim.notify('compile: finished successfully', vim.log.levels.INFO)
      else
        vim.notify(
          ('compile: "%s" failed (exit %d)'):format(entry.cmd, exit_code),
          vim.log.levels.ERROR
        )
      end
    end,
  })

  local winid = _get_or_create_window()
  vim.api.nvim_win_set_buf(winid, bufnr)
  if opts.focus then vim.api.nvim_set_current_win(winid) end

  return true
end

function M.setup(opts)
  _config = vim.tbl_deep_extend('force', {
    scroll_on_output = false,
  }, opts or {})

  vim.api.nvim_create_user_command(
    'Compile',
    function(cmd_opts) M.compile(cmd_opts.args, { focus = cmd_opts.bang }) end,
    { nargs = '+', bang = true, complete = 'shellcmd' }
  )

  vim.api.nvim_create_user_command(
    'Recompile',
    function(cmd_opts) _recompile({ focus = cmd_opts.bang }) end,
    { nargs = 0, bang = true }
  )
end

M.setup()

return { compile = M.compile }
