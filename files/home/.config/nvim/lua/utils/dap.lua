local M = {}

local dap = function()
	return require('dap')
end

local widgets = function()
	return require('dap.ui.widgets')
end

local is_running = function()
	return string.len(dap().status() or '') > 0
end

--- Open dap.log file
local log = function()
	local path = vim.fn.stdpath('cache') .. '/dap.log'
	vim.cmd('vsp ' .. path)
end

-- Bindings ==================================================================

-- Start new debug session
M.debug_start = function()
	vim.notify('Debugging ' .. vim.fn.expand('%'))
  -- local config = 
	-- dap().run()
end

M.debug_restart = function()
	dap().restart()
end

M.debug_last = function()
	dap().run_last()
end

M.debug_terminate = function()
	dap().terminate()
end

M.debug_pause = function()
	dap().pause()
end

M.debug_continue = function()
	dap().continue()
end

M.debug_step_into = function()
	dap().step_into()
end

M.debug_step_out = function()
	dap().step_out()
end

M.debug_step_over = function()
	dap().step_over()
end

M.debug_repl = function()
	-- TODO: focus on open
	dap().repl.open()
end

M.debug_bp_toggle = function()
	dap().toggle_breakpoint()
end

M.debug_bp_condition = function()
	local condition = vim.fn.input('Condition: ')
	if condition ~= nil and string.len(condition) > 0 then
		dap().set_breakpoint(condition, nil, 'Condition "' .. condition .. '" hit')
	end
end

M.debug_bp_clear = function() end

M.debug_bp_list = function()
	dap().list_breakpoints()
end

M.debug_hover = function()
	widgets().hover()
end

M.debug_preview = function()
	widgets().preview()
end

return M
