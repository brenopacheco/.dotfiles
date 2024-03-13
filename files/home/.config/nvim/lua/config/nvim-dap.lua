local dap = require('dap')

-- dap.set_log_level('TRACE')
dap.set_log_level('ERROR')

require('nvim-dap-virtual-text').setup({})

dap.listeners.after.event_initialized['repl'] = function()
	vim.notify('Dap session started', vim.log.levels.INFO)
end

dap.listeners.before.event_terminated['repl'] = function()
	vim.notify('Dap session terminated', vim.log.levels.WARN)
end

dap.listeners.before.event_exited['repl'] = function()
	vim.notify('Dap session exited', vim.log.levels.WARN)
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
	c = 'lldb',
	dotnet = 'netcoredbg',
	go = 'delve',
	node = 'vscode-js-debug',
}

---@param debugger string
---@param lang string
local warn_missing = function(debugger, lang)
	vim.notify(
		'Install ' .. debugger .. ' to use dap with ' .. lang,
		vim.log.levels.WARN
	)
end

for lang, debugger in pairs(debuggers) do
	if not installed(debugger) then warn_missing(debugger, lang) end
end

if not vim.z.enabled('jbyuki/one-small-step-for-vimkind') then
	warn_missing('osv', 'lua')
end

register(require('utils.dap.c'))
register(require('utils.dap.dotnet'))
register(require('utils.dap.go'))
register(require('utils.dap.node'))
register(require('utils.dap.lua'))
register(require('utils.dap.elixir'))
