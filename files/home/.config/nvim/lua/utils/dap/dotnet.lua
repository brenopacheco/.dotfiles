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

M.configurations = {
	cs = {
		{
			name = '  Debug program',
			type = 'coreclr',
			request = 'launch',
			program = '/home/breno/fc/backend/apps/API/src/FarmerConnect.Api/bin/Debug/net8.0/FarmerConnect.Api.dll',
			cwd = '/home/breno/fc/backend/apps/API/src/FarmerConnect.Api/bin/Debug/net8.0/FarmerConnect.Api.dll',
			args = {},
			externalConsole = false,
			stopAtEntry = false,
			env = {
				ASPNETCORE_ENVIRONMENT = 'Development',
			},
		},
	},
}

return M
