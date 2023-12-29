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

require("dapui").setup()
require('nvim-dap-virtual-text').setup({})

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
	-- dotnet = 'netcoredbg',
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

dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = {'dap', '-l', '127.0.0.1:${port}'},
  }
}

dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}"
  },
  {
    type = "delve",
    name = "Debug test (file)", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}"
  },
  -- works with go.mod packages and sub packages 
  {
    type = "delve",
    name = "Debug tests (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  }
}

-- dap.adapters['pwa-node'] = {
-- 	type = 'server',
-- 	host = 'localhost',
-- 	port = '${port}',
-- 	executable = {
-- 		command = 'node',
-- 		args = { '/usr/lib/vscode-js-debug/src/dapDebugServer.js', '${port}' },
-- 	},
-- }

-- dap.configurations.lua = {
-- 	{
-- 		type = 'nlua',
-- 		request = 'attach',
-- 		name = 'Attach to running Neovim instance',
-- 	},
-- }

-- dap.adapters.coreclr = {
-- 	type = 'executable',
-- 	command = '/path/to/dotnet/netcoredbg/netcoredbg',
-- 	args = { '--interpreter=vscode' },
-- }
