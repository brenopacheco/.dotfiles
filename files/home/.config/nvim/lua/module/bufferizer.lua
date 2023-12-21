--- Bufferizer
--
-- Provides the :Bufferize command, which takes a regular vim command
-- and redirects it'so output to a scratch buffer.
-- Provides the useful :Messages command
--

local function bufferize(tbl)
	local cmd = table.concat(tbl.fargs, ' ')
	local result = vim.fn.execute(cmd)
	vim.cmd('vsplit')
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(win, buf)
	local text = vim.split(vim.trim(result), '\n')
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, text)
end

local function messages()
	bufferize({ fargs = { 'messages' } })
end

-- setup
vim.api.nvim_create_user_command('Bufferize', bufferize, { nargs = '*' })
vim.api.nvim_create_user_command('Messages', messages, { nargs = '*' })
