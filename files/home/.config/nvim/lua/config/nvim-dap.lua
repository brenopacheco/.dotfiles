local dap = require('dap')
local dapui = require('dapui')

dap.set_log_level('TRACE')

---@diagnostic disable-next-line: missing-fields
dapui.setup({
	controls = {
		element = 'repl',
		enabled = true,
		icons = {
			disconnect = ' ',
			pause = ' ',
			play = ' ',
			run_last = ' ',
			step_back = ' ',
			step_into = ' ',
			step_out = ' ',
			step_over = ' ',
			terminate = ' ',
		},
	},
})

require('nvim-dap-virtual-text').setup({})

dap.listeners.after.event_initialized['dapui_config'] = function()
  vim.notify('Dap session started', vim.log.level.WARN)
	require('dap').repl.open({ height = 15 })
end

dap.listeners.before.event_terminated['dapui_config'] = function()
  vim.notify('Dap session terminated', vim.log.level.WARN)
	-- require('dap').repl.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
  vim.notify('Dap session exited', vim.log.level.WARN)
	-- require('dap').repl.close()
end

vim.fn.sign_define(
	'DapBreakpoint',
	{ text = '󰯯', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
	'DapBreakpointCondition',
	{ text = '󰟃', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
	'DapLogPoint',
	{ text = '󰍢', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
	'DapStopped',
	{ text = '', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
	'DapBreakpointRejected',
	{ text = '󱞌', texthl = '', linehl = '', numhl = '' }
)

---Checks if the pacman package for the given debugger is installed
---
---@param pkg string : the name of the debugger package
---@return boolean : true if the package is installed
local installed = function(pkg)
	local str = vim.fn.system('pacman -Qs ' .. pkg) or ''
	str = vim.split(str, '\n')[1] or ''
	str = vim.split(str, ' ')[1] or ''
	str = string.gsub(str, '^local/', '')
	return str == pkg
end

--- Registers the given adapters and configurations with dap
---
---@param settings { adapters: table<string, Adapter>, configurations: Configuration[] }
local register = function(settings)
	for key, adapter in pairs(settings.adapters) do
		dap.adapters[key] = adapter
	end
	for key, configuration in pairs(settings.configurations) do
		dap.configurations[key] = configuration
	end
end

local debuggers = {
	-- c = 'lldb',
	-- dotnet = 'netcoredbg',
	go = 'delve',
	node = 'vscode-js-debug',
}

for lang, debugger in pairs(debuggers) do
	if not installed(debugger) then
		vim.notify(
			'Install ' .. debugger .. ' to use dap with ' .. lang,
			vim.log.levels.WARN
		)
	end
end

-- register(require('utils.dap.c'))
register(require('utils.dap.dotnet'))
register(require('utils.dap.go'))
-- register(require('utils.dap.node'))
