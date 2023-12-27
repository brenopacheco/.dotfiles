local M = {}

local notify = function(msg)
	vim.api.nvim_exec_autocmds('User', { pattern = 'ArgsChanged' })
	vim.notify(msg, vim.log.levels.INFO)
end

local err = function(msg)
	vim.notify(msg, vim.log.levels.WARN)
end

-- Add buffer to arglist
M.args_add = function()
	if vim.fn.bufname() == '' then
		return err('error: the buffer is not associated with a file')
	end
	vim.cmd('$argadd')
	vim.cmd('argdedupe')
	vim.cmd('argu ' .. vim.fn.argc())
	notify('info: "' .. vim.fn.expand('%') .. '" added to arglist')
end

-- Clear arglist
M.args_clear = function()
	vim.cmd('argdelete *')
	notify('info: arglist cleared')
end

-- Remove buffer from arglist
M.args_delete = function()
	if not vim.fn.bufexists(0) then
		return err('error: the buffer is not associated with a file')
	end
	vim.cmd('argdelete %')
	notify('info: "' .. vim.fn.expand('%') .. '" removed from arglist')
end

-- Jump to next arg in arglist
M.arg_next = function()
	if vim.fn.argc() == 0 then
		return err('error: arglist is empty')
	end
	local idx = vim.fn.argidx() + 1 >= vim.fn.argc() and '1'
		or tostring(vim.fn.argidx() + 2)
	vim.cmd('argu ' .. idx)
	notify('info: "' .. vim.fn.expand('%') .. '"')
end

-- Jump to previous arg in arglist
M.arg_prev = function()
	if vim.fn.argc() == 0 then
		return err('error: arglist is empty')
	end
	local idx = vim.fn.argidx() == 0 and tostring(vim.fn.argc())
		or tostring(vim.fn.argidx())
	vim.cmd('argu ' .. idx)
	notify('info: "' .. vim.fn.expand('%') .. '"')
end

return M
