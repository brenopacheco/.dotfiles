--- Bufferizer
--
-- Provides the :Bufferize command, which takes a regular vim command
-- and redirects it'so output to a scratch buffer.
-- Provides the useful :Messages command
--

local bufname = '__bufferize__'

local function bufferize(tbl)
	local cmd = table.concat(tbl.fargs, ' ')
	local result = tostring(vim.fn.execute(cmd))
  local text = vim.split(vim.trim(result), '\n')
  local bufnr = vim.fn.bufnr(bufname)
	if bufnr == nil or bufnr < 1 then
    bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(bufnr, bufname)
  end
  local winnrs = vim.fn.win_findbuf(bufnr) or {}
  local winnr = winnrs[1]
  if #winnrs < 1 then
    vim.cmd('vsplit')
    winnr = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(winnr, bufnr)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, text)
  vim.api.nvim_set_current_win(winnr)
end

local function messages()
	bufferize({ fargs = { 'messages' } })
end

-- setup
vim.api.nvim_create_user_command('Bufferize', bufferize, { nargs = '*' })
vim.api.nvim_create_user_command('Messages', messages, { nargs = 0 })
