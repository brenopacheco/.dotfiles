local bufutil = require('utils.buf')
local qfutil = require('utils.qf')

---@module 'dap'
---@diagnostic disable-next-line: assign-type-mismatch
local status, dap = pcall(require, 'dap')

if not status then vim.notify('DAP not loaded', vim.log.levels.WARN) end

local function is_running() return string.len(dap.status()) > 0 end

local function wrap(cb)
	return function()
		if not is_running() then
			return vim.notify('Dap session not running', vim.log.levels.WARN)
		end
		cb()
	end
end

local M = {}

M.debug_start = function() return dap.continue() end

M.debug_restart = function()
	if is_running() then return dap.restart() end
	dap.run_last()
end

M.debug_terminate = wrap(function() dap.terminate() end)

M.debug_pause = wrap(function() dap.pause() end)

M.debug_continue = wrap(function() dap.continue() end)

M.debug_step_into = wrap(function() dap.step_into() end)

M.debug_step_out = wrap(function() dap.step_out() end)

M.debug_step_over = wrap(function() dap.step_over() end)

M.debug_bp_toggle = function() dap.toggle_breakpoint() end

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

M.debug_hover = wrap(function() require('dap.ui.widgets').hover() end)

M.debug_preview = wrap(function() require('dap.ui.widgets').preview() end)

M.to_cursor = wrap(function() dap.run_to_cursor() end)

M.toggle_ui = wrap(function() require('dapui').toggle({ reset = true }) end)

M.open_log = function()
	local path = vim.fn.stdpath('cache') .. '/dap.log'
	vim.cmd('vsp ' .. path)
end

M.toggle_repl = wrap(function()
	bufutil.toggle('dap-repl', {
		focus = true,
		cb = function() require('dap').repl.open({ height = 15 }) end,
	})
end)

M.show_configs = function()
	local configs = vim.inspect(dap.configurations)
	bufutil.throwaway(vim.split(configs, '\n'))
end

return M
