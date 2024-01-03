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
	local major, minor, _patch = string.match(version, '(%d+)%.(%d+)%.(%d+)')
	assert(major and minor, 'dotnet version not found')
	return major .. '.' .. minor
end

T.pick_program = function()
	local root = rootutil.git_root()
	local projects =
		rootutil.downward_roots({ dir = root, patterns = { '^.*%.csproj$' } })
	assert(#projects > 0, 'No .csproj files found')
	local version = dotnet_version()
	---@alias DLL {path: string, name: string}
	---@type DLL[]
	local dlls = {}
	for _, project in ipairs(projects) do
		local name = string.gsub(project.file, '.csproj', '')
		local path = project.path
			.. '/bin/Debug/net'
			.. version
			.. '/'
			.. name
			.. '.dll'
		if fileutil.exists(path) then
			---@type DLL
			local dll = { path = path, name = name }
			table.insert(dlls, dll)
		end
	end
	assert(#dlls > 0, 'No dlls found')
	return coroutine.create(function(dap_run_co)
		vim.ui.select(
			dlls,
			{
				prompt = 'Debug project:',
				---@param item DLL
				format_item = function(item)
					return '  ' .. item.name
				end,
			},
			---@param choice DLL|nil
			function(choice)
				choice = choice or {}
				coroutine.resume(dap_run_co, choice.path)
			end
		)
	end)
end

M.configurations = {
	cs = {
		{
			name = '  Debug program',
			type = 'coreclr',
			request = 'launch',
			program = T.pick_program,
			args = {},
		},
	},
}

return M
