local bufutils = require('utils.buf')

local M = {}

---@class DapConfiguration
---@field type string
---@field request "launch"|"attach"
---@field name string

---@param filetype string
---@return DapConfiguration[]
local get_configs = function(filetype)
	return require('dap').configurations[filetype]
end

local is_running = function()
	return string.len(require('dap').status() or '') > 0
end

--- Open dap.log file
local log = function()
	local path = vim.fn.stdpath('cache') .. '/dap.log'
	vim.cmd('vsp ' .. path)
end

local function get_arguments()
	return coroutine.create(function(dap_run_co)
		local args = {}
		vim.ui.input({ prompt = 'Args: ' }, function(input)
			args = vim.split(input or '', ' ')
			coroutine.resume(dap_run_co, args)
		end)
	end)
end

-- Adapters and configurations ===============================================

--[[ Go configurations

What do I want to debug?

- Package/program  - debugs the main function
- Test package     - debugs the whole test package
- Test file        - debugs the current test file or pick one
- Test function    - debugs the current test function or pick one

To debug tests, we allways want to launch the process (i.e: run `go test`)
To debug the package, we can either launch the process or attach to a
running process. Do we want to allow attaching to a running process? Yes

Use cases:
1. Debug package (launch)
2. Debug package (attach)
3. Debug test package (launch)
4. Debug test file (launch)
5. Debug test function (launch)

How can I perform these use cases using dlv?

It seems we configure the delve adapter as a server, adding instructions on
how to spawn it. nvim-dap will launch the server and for each session and
connect to it via socket.

https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md

**The dap plugin does not `launch` the application. It simply sends either
a `launch` or `attach` request to the debugger. The debugger then launches
or attaches to the application.**

For debugging the program/package, We have 3 options:
1. Launch the program ourselves and ask delve to attach (like 'dlv attach')
   This won't work well for programs that exit before the debugger can attach
2. Ask delve to launch the program (like 'dlv debug')
   This is probably the easiest option, as delve is responsible for building
3. Build the binaries and ask delve to launch the binary (like 'dlv exec')
   This is the most versatile option, as we can build the binary ourselves
   in any way (Makefile, go build, etc) with the flags we want

What about tests? We need to ask delve to build and run test (like dlv test)

In conclusion, we need to:

-. Launch delve in headless DAP mode
1. Debug package (launch)
   - request: `launch`
   - mode: `debug`
   - program: go_mod_dir()
   - args: get_arguments()
2. Debug package (attach)
   - request: `attach`
   - mode: `local`
   - processId = ...,
3. Test package (launch)
   - request: `launch`
   - mode: `test`
   - program: go_mod_dir(),
4. Test file
   - request: `launch`
   - mode: `test`
   - program: "${file}",

Reference: https://github.com/leoluz/nvim-dap-go/blob/main/lua/dap-go.lua#L132

TODO: 
- [ ] write missing functions
- [ ] check these configurations work
- [ ] tidy up configuration
- [ ] study how the dotnet adapter works
- [ ] extend DapConfiguration to allow for dotnet to work
- [ ] write dotnet configurations
- [ ] repeat for node, c and lua

--]]

M.adapters = {
	delve = {
		type = 'server',
		port = '${port}',
		build_flags = '',
		executable = {
			command = 'dlv',
			args = { 'dap', '-l', '127.0.0.1:${port}' },
		},
	},
}

M.configurations = {
	go = {
		{
			name = 'Debug package',
			type = 'delve',
			request = 'launch',
			mode = 'debug',
			program = '${workspaceFolder}', -- TODO: replace by get_mod_dir()
			args = {}, -- TODO: replace by get_arguments()
		},
		{
			name = 'Debug process',
			type = 'delve',
			request = 'attach',
			mode = 'local',
			processId = 1, -- TODO: replace by get_pid(filter)
		},
		{
			name = 'Debug test package',
			type = 'delve',
			request = 'launch',
			mode = 'test',
			program = '${workspaceFolder}',
		},
		{
			name = 'Debug test file',
			type = 'delve',
			request = 'launch',
			mode = 'test',
			program = '${file}',
		},
	},
}

-- Bindings ==================================================================

-- Start new debug session
M.debug_start = function()
	vim.notify('Debugging ' .. vim.fn.expand('%'))
	local ft = vim.bo.filetype
	local configs = get_configs(ft)
	if configs == nil then
		return vim.notify(
			'No dap configurations for ' .. vim.bo.filetype,
			vim.log.levels.WARN
		)
	end
	vim.ui.select(configs, {
		prompt = 'DAP configuration for ' .. ft .. ':',
		format_item = function(item)
			local fmt = '  %-s %'
				.. tostring(60 - string.len(item.name))
				.. 's %10s'
			return string.format(fmt, item.name, '[' .. item.request .. ']', '(' .. item.type .. ')')
		end,
	}, function(choice)
		if choice ~= nil then
        vim.print(choice)
		end
	end)
end

M.debug_restart = function()
	require('dap').restart()
end

M.debug_last = function()
	require('dap').run_last()
end

M.debug_terminate = function()
	require('dap').terminate()
end

M.debug_pause = function()
	require('dap').pause()
end

M.debug_continue = function()
	require('dap').continue()
end

M.debug_step_into = function()
	require('dap').step_into()
end

M.debug_step_out = function()
	require('dap').step_out()
end

M.debug_step_over = function()
	require('dap').step_over()
end

M.debug_repl = function()
	local visible, winid = bufutils.is_visible('dap-repl')
	if visible then
		vim.api.nvim_set_current_win(winid)
	else
		require('dapui').toggle({ reset = true })
		M.debug_repl()
	end
end

M.debug_bp_toggle = function()
	require('dap').toggle_breakpoint()
end

M.debug_bp_condition = function()
	local condition = vim.fn.input('Condition: ')
	if condition ~= nil and string.len(condition) > 0 then
		require('dap').set_breakpoint(
			condition,
			nil,
			'Condition "' .. condition .. '" hit'
		)
		vim.notify('Breakpoint set with condition: ' .. condition)
	end
end

M.debug_bp_clear = function()
	require('dap').clear_breakpoints()
	vim.notify('Breakpoints cleared')
end

M.debug_bp_list = function()
	require('dap').list_breakpoints()
	vim.cmd('copen | wincmd p')
end

M.debug_hover = function()
	require('dap.ui.widgets').hover()
end

M.debug_preview = function()
	require('dap.ui.widgets').preview()
end

M.to_cursor = function()
	require('dap').run_to_cursor()
end

M.toggle_ui = function()
	require('dapui').toggle({ reset = true })
end

return M
