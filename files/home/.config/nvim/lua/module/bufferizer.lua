--- Bufferizer
--
-- Provides the :Bufferize command, which takes a regular vim command
-- and redirects it'so output to a scratch buffer.
-- Provides the useful :Messages command
-- NOTE: 
-- `cmd` provides about 200 lines only
-- we don't get messages highlights

local bufname = 'bufferize:///'

local function bufferize(tbl)
	local cmd = table.concat(tbl.fargs, ' ')
	local result = tostring(vim.fn.execute(cmd))
	local text = vim.split(vim.trim(result), '\n')
	local bufnr = vim.fn.bufnr(bufname)
	if bufnr == nil or bufnr < 1 then
		bufnr = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(bufnr, bufname)
	end
	local winids = vim.fn.win_findbuf(bufnr) or {}
	local winid = winids[1]
	if #winids < 1 then
		vim.cmd('vsplit')
		winid = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(winid, bufnr)
	end
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, text)
	vim.api.nvim_set_current_win(winid)
	local group = vim.api.nvim_create_augroup('bufferizer', { clear = true })
	vim.api.nvim_create_autocmd({ 'WinClosed' }, {
		desc = 'Delete bufferizer buffer when window is closed',
		group = group,
		pattern = { tostring(winid) },
		callback = function()
			vim.api.nvim_buf_delete(bufnr, { force = true })
			pcall(vim.api.nvim_del_augroup_by_name, group)
		end,
		nested = true,
	})
end

local function messages()
	bufferize({ fargs = { 'messages' } })
end

-- setup
vim.api.nvim_create_user_command('Bufferize', bufferize, { nargs = '*' })
vim.api.nvim_create_user_command('Messages', messages, { nargs = 0 })
