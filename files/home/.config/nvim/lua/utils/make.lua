local fileutil = require('utils.file')
local rootutil = require('utils.root')

local M = {}

---@class Target
---@field name string
---@field cmd string
---@field dir string
---@field file string
---@field kind string

---@class System
---@field name string The system name
---@field patterns string[] The patterns to match against the system file
---@field targets fun(dir: string, file: string, data: string[]): Target[]

---@type System
local make = {
	name = 'make',
	patterns = { 'Makefile' },
	targets = function(dir, file, data)
		---@type Target[]
		local targets = {}
		for _, line in ipairs(data) do
			local rule = string.match(line, '^([a-zA-Z_%-]+):')
			if rule ~= nil then
				---@type Target
				local target = {
					name = rule,
					cmd = 'make ' .. rule,
					dir = dir,
					file = file,
					kind = 'make',
				}
				table.insert(targets, target)
			end
		end
		return targets
	end,
}

---@type System
local go = {
	name = 'go',
	patterns = { '^go%.mod$' },
	targets = function(dir, file)
		local cmds = {
			'run',
			'build',
			'install',
			'get',
			'fmt',
			'vet',
			'test',
			'test -v',
			'doc',
			'mod tidy',
			'clean',
		}
		---@type Target[]
		local targets = vim.tbl_map(function(cmd)
			return {
				name = cmd,
				cmd = 'go ' .. cmd .. ' .',
				dir = dir,
				file = file,
				kind = 'go',
			}
		end, cmds)
		return targets
	end,
}

---@type System
local node = {
	name = 'node',
	patterns = { 'package.json' },
	targets = function(dir, file, data)
		---@type Target[]
		local targets = {}
    local status, decoded = pcall(vim.json.decode, vim.join(data, '\n'))
    if not status then
      return {}
    end
		---@type table<string, string>
		local scripts = decoded.scripts
		local manager = fileutil.exists(dir .. '/yarn.lock') and 'yarn' or 'npm'
		for script, _ in pairs(scripts) do
			---@type Target
			local target = {
				name = script,
				cmd = manager .. ' run ' .. script,
				dir = dir,
				file = file,
				kind = manager,
			}
			table.insert(targets, target)
		end
		table.insert(targets, {
			name = 'clear node_modules && install',
			cmd = 'rm -rf node_modules && ' .. manager .. ' install',
			dir = dir,
			file = file,
			kind = manager,
		})
		return targets
	end,
}

---@type System
local dotnet = {
	name = 'dotnet',
	patterns = { '.+%.sln' },
	targets = function(dir, file)
		---@type Target[]
		local targets = {}
		table.insert(targets, {
			name = 'test Category=Unit',
			cmd = [[dotnet test --filter 'Category=Unit']],
			dir = dir,
			file = file,
			kind = 'dotnet',
		})
		table.insert(targets, {
			name = 'test Category=Integration',
			cmd = [[dotnet test --filter 'Category=Integration']],
			dir = dir,
			file = file,
			kind = 'dotnet',
		})
		return targets
	end,
}

local systems = { make, node, dotnet, go }

--- Get all run targets from all systems (make, go, rust, etc.)
---
---@return Target[]
M.targets = function()
	---@type Target[]
	local targets = {}
	local all_roots = rootutil.all_roots()
	for _, system in ipairs(systems) do
		local roots = vim.tbl_filter(function(root)
			for _, pattern in ipairs(system.patterns) do
				if string.match(root.file, pattern) then
					return true
				end
			end
			return false
		end, all_roots)
		for _, root in ipairs(roots) do
			local filepath = root.path .. '/' .. root.file
			local data = fileutil.read(filepath)
			if data then
				for _, target in ipairs(system.targets(root.path, root.file, data)) do
					table.insert(targets, target)
				end
			end
		end
	end
	return targets
end

return M
