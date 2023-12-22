local M = {}

-- Add buffer to arglist
M.args_add = function()
	if vim.fn.bufname() == '' then
		return vim.notify(
			'error: the buffer is not associated with a file',
			vim.log.levels.WARN
		)
	end
	vim.cmd('argadd')
	vim.cmd('argdedupe')
	vim.cmd('argu ' .. vim.fn.argc())
	return vim.notify(
		'info: "' .. vim.fn.expand('%') .. '" added to arglist',
		vim.log.levels.INFO
	)
end

-- Clear arglist
M.args_clear = function()
	vim.cmd('argdelete *')
	return vim.notify('info: arglist cleared', vim.log.levels.INFO)
end

-- Remove buffer from arglist
M.args_delete = function()
	if not vim.fn.bufexists(0) then
		return vim.notify(
			'error: the buffer is not associated with a file',
			vim.log.levels.WARN
		)
	end
	vim.cmd('argdelete %')
	return vim.notify(
		'info: "' .. vim.fn.expand('%') .. '" removed from arglist',
		vim.log.levels.INFO
	)
end

M.arg_next = function()
	vim.cmd(
		'argu' .. vim.fn.argidx() + 1 >= vim.fn.argc() and 1 or vim.fn.argidx() + 2
	)
end

-- Jump to previous arg in arglist
M.arg_prev = function()
	vim.cmd(
		'argu' .. vim.fn.argidx() == 0 and vim.fn.argc() + 1 or vim.fn.argidx()
	)
end

return M
