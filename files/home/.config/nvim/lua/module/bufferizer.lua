--- Bufferizer
--
-- Provides the :Bufferize command, which takes a regular vim command
-- and redirects it'so output to a scratch buffer.
-- Provides the useful :Messages command

---@type number
local bufnr = -1

local function bufferize(tbl)
	local cmd = table.concat(tbl.fargs, ' ')
	local result = tostring(vim.fn.execute(cmd))
	local text = vim.split(vim.trim(result), '\n')
	if vim.fn.bufexists(bufnr) == 1 then
		vim.cmd(string.format('silent! bwipeout %d', bufnr))
	end
	bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(bufnr, 'bufferize:///' .. cmd)
	vim.cmd('vsplit')
	local winid = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(winid, bufnr)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, text)
end

local function messages() bufferize({ fargs = { 'messages' } }) end

vim.api.nvim_create_user_command('Bufferize', bufferize, { nargs = '*' })
vim.api.nvim_create_user_command('Messages', messages, { nargs = 0 })
