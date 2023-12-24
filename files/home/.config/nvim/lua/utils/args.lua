local M = {}

-- Add buffer to arglist
M.args_add = function()
	if vim.fn.bufname() == '' then
		return vim.notify(
			'error: the buffer is not associated with a file',
			vim.log.levels.WARN
		)
	end
	vim.cmd('$argadd')
	vim.cmd('argdedupe')
	vim.cmd('argu ' .. vim.fn.argc())
	vim.api.nvim_exec_autocmds("User", { pattern = "ArgsChanged" })
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
	vim.api.nvim_exec_autocmds("User", { pattern = "ArgsChanged" })
	return vim.notify(
		'info: "' .. vim.fn.expand('%') .. '" removed from arglist',
		vim.log.levels.INFO
	)
end

-- Jump to next arg in arglist
M.arg_next = function()
	if vim.fn.argc() == 0 then
		return vim.notify('error: arglist is empty', vim.log.levels.WARN)
	end
	local idx = vim.fn.argidx() + 1 >= vim.fn.argc() and '1'
		or tostring(vim.fn.argidx() + 2)
	vim.cmd('argu ' .. idx)
end

-- Jump to previous arg in arglist
M.arg_prev = function()
	if vim.fn.argc() == 0 then
		return vim.notify('error: arglist is empty', vim.log.levels.WARN)
	end
	local idx = vim.fn.argidx() == 0 and tostring(vim.fn.argc())
		or tostring(vim.fn.argidx())
	vim.cmd('argu ' .. idx)
end

return M
