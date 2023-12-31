--[[ Notes

Use cases for debugging
------------------------
1. attach to process           (e.g: attach to running server)
2. launch a process            (e.g: run c executable)
3. run task and attach process (e.g: run dotnet test in debug more and attach)
4. run task and launch process (e.g: compile c program and launch)

Golang -- always launch delve debugger server
  1. Debug package
    launch <file>
  2. Attach
    select from user spawned processes
    e.g: ps -ae | grep pts | egrep -v "(bash|tmux|ps|grep|nvim|node)"
  3. Debug test file

--]]

local dap = require('dap')
local daputil  = require('utils.dap')

---@diagnostic disable-next-line: missing-fields
require("dapui").setup({
    controls = {
      element = "repl",
      enabled = true,
      icons = {
        disconnect = " ",
        pause = " ",
        play = " ",
        run_last = " ",
        step_back = " ",
        step_into = " ",
        step_out = " ",
        step_over = " ",
        terminate = " "
      }
    }
})

require('nvim-dap-virtual-text').setup({})

vim.fn.sign_define('DapBreakpoint', {text='󰯯', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='󰟃', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='󰍢', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='󱞌', texthl='', linehl='', numhl=''})

local installed = function(pkg)
	local str = vim.fn.system('pacman -Qs ' .. pkg) or ''
	str = vim.split(str, '\n')[1] or ''
	str = vim.split(str, ' ')[1] or ''
	str = string.gsub(str, '^local/', '')
	return str == pkg
end

local debuggers = {
	go = 'delve',
	node = 'vscode-js-debug',
	dotnet = 'netcoredbg',
  c = 'lldb',
}

for lang, debugger in pairs(debuggers) do
	if not installed(debugger) then
		vim.notify(
			'Install ' .. debugger .. ' to use dap with ' .. lang,
			vim.log.levels.WARN
		)
	end
end

for key, adapter in pairs(daputil.adapters) do
  dap.adapters[key] = adapter
end

for key, configuration in pairs(daputil.configurations) do
  dap.configurations[key] = configuration
end

-- Go configurations =========================================================

--[[ Use cases for debugging

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

It seems we configure the delve adapter as a server - 
1. 

--]]


