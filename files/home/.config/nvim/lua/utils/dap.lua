local bufutil = require('utils.buf')
local qfutil = require('utils.qf')

local dap = require('dap')

local is_running = function()
  return string.len(dap.status()) > 0
end

local M = {}

M.debug_start = function()
  return dap.continue()
end

M.debug_restart = function()
  if is_running() then
    dap.restart()
  end
  dap.run_last()
end

M.debug_terminate = function()
	dap.terminate()
end

M.debug_pause = function()
	dap.pause()
end

M.debug_continue = function()
	dap.continue()
end

M.debug_step_into = function()
	dap.step_into()
end

M.debug_step_out = function()
	dap.step_out()
end

M.debug_step_over = function()
	dap.step_over()
end

M.debug_bp_toggle = function()
	dap.toggle_breakpoint()
end

M.debug_bp_condition = function()
	local condition = vim.fn.input('Condition: ')
	if condition ~= nil and string.len(condition) > 0 then
		dap.set_breakpoint(condition, nil, 'Condition "' .. condition .. '" hit')
		vim.notify('Breakpoint set with condition: ' .. condition)
	end
end

M.debug_bp_clear = function()
	dap.clear_breakpoints()
	vim.notify('Breakpoints cleared')
end

M.debug_bp_list = function()
	dap.list_breakpoints()
	qfutil.open()
end

M.debug_hover = function()
	require('dap.ui.widgets').hover()
end

M.debug_preview = function()
	require('dap.ui.widgets').preview()
end

M.to_cursor = function()
	dap.run_to_cursor()
end

M.toggle_ui = function()
	require('dapui').toggle({ reset = true })
end

M.open_log = function()
	local path = vim.fn.stdpath('cache') .. '/dap.log'
	vim.cmd('vsp ' .. path)
end

M.show_configs = function()
	local configs = vim.inspect(dap.configurations)
	bufutil.throwaway(vim.split(configs, '\n'))
end

return M
