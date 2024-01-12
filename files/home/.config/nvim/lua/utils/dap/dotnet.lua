--[[

What do I want to debug?

1. Program - launching it
2. Program - attaching to process
3. All test - launching it
4. Test under cursor
5. Test file

--]]

local M = {}

local fileutil = require('utils.file')
local rootutil = require('utils.root')
local treeutil = require('utils.treesitter')

local T = {}

M.adapters = {
	coreclr = {
		type = 'executable',
		command = 'netcoredbg',
		args = { '--interpreter=vscode' },
	},
}

local dotnet_version = function()
	local version = vim.fn.system('dotnet --version')
	assert(version ~= '', 'dotnet not found')
	local major, minor = string.match(version, '(%d+)%.(%d+)%.%d+')
	assert(major and minor, 'dotnet version not found')
	return major .. '.' .. minor
end

local function get_pid()
	local pid = vim.fn.system(
		[[netstat -tulpn 2>/dev/null | grep ::1:5001 |  awk '{print $7}' | cut -d'/' -f1]]
	)
	assert(pid ~= '', 'fc backend process not found')
	return pid
end

M.configurations = {
	cs = {
		{
			name = '  Debug program',
			type = 'coreclr',
			request = 'attach',
			processId = get_pid,
			args = {},
			env = {
				ASPNETCORE_ENVIRONMENT = 'Development',
			},
		},
		-- {
		-- 	name = '  Debug program',
		-- 	type = 'coreclr',
		-- 	request = 'launch',
		-- 	program = '/home/breno/fc/backend/apps/API/src/FarmerConnect.Api/bin/Debug/net8.0/FarmerConnect.Api.dll',
		-- 	cwd = '/home/breno/fc/backend/apps/API/src/FarmerConnect.Api/bin/Debug/net8.0/FarmerConnect.Api.dll',
		-- 	args = {},
		-- 	externalConsole = false,
		-- 	stopAtEntry = false,
		-- 	env = {
		-- 		ASPNETCORE_ENVIRONMENT = 'Development',
		-- 	},
		-- },
	},
}

return M
