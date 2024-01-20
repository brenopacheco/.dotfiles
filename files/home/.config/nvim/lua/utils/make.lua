local fileutil = require('utils.file')
local rootutil = require('utils.root')
local dotnetutil = require('utils.filetype.dotnet')

local M = {}

---@class Target       @ shows as "[kind]  name      [id]"
---@field name string  @ the name of the target
---@field cmd  string  @ the command to run
---@field dir  string  @ the directory to run the command in
---@field kind string  @ the kind of target (make, go, etc.)
---@field id   string  @ the id of the target

---@class System
---@field name string The system name
---@field patterns string[] The patterns to match against the system file
---@field targets fun(dir: string, file: string, data: string[]): Target[]

---@type table<string, Target[]> @dictionary of git root to targets
local cache = {}

local cache_enabled = false

---@type System
local shell = {
	name = 'shell',
	patterns = { '%.sh$' },
	targets = function(dir, file)
		---@type Target[]
		local targets = {}
		local path = dir .. '/' .. file
		if vim.fn.executable(path) ~= 1 then
			return targets
		end
		---@type Target
		local target = {
			name = file,
			cmd = './' .. file,
			dir = dir,
      id = tostring(vim.fn.fnamemodify(dir, ':t')),
			kind = 'bash',
		}
		table.insert(targets, target)
		return targets
	end,
}

---@type System
local make = {
	name = 'make',
	patterns = { 'Makefile' },
	targets = function(dir, _, data)
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
          id = tostring(vim.fn.fnamemodify(dir, ':t')) .. '/Makefile',
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
	targets = function(dir, _, data)
		---@type Target[]
		local targets = {}
		local status, decoded = pcall(vim.json.decode, table.concat(data, '\n'))
		---@type table<string, string>|nil
		local scripts = decoded.scripts
		if not status or not scripts then
			return {}
		end
		local manager = fileutil.exists(dir .. '/yarn.lock') and 'yarn' or 'npm'
		for script, _ in pairs(scripts) do
			---@type Target
			local target = {
				name = script,
				cmd = manager .. ' run ' .. script,
				dir = dir,
				kind = manager,
        id = tostring(vim.fn.fnamemodify(dir, ':t')) .. '/package.json',
			}
			table.insert(targets, target)
		end
		return targets
	end,
}

---@type System
local dotnet = {
	name = 'dotnet',
	patterns = { '.+%.sln', '.+%.csproj' },
	targets = function(dir, file)
    if file:match('%.sln$') then
      return dotnetutil.sln_targets(dir, file)
    end
    if file:match('%.csproj$') then
      return dotnetutil.csproj_targets(dir, file)
    end
    return {}
	end,
}

local systems = { make, node, dotnet, go, shell }

--- Get all run targets from all systems (make, go, rust, etc.)
---
---@return Target[]
M.targets = function()
	---@type Target[]
	local targets = {}
	local git_root = rootutil.git_root()
  if cache_enabled and cache[git_root] then
    return cache[git_root]
  end
	for _, system in ipairs(systems) do
		local roots =
			rootutil.downward_roots({ dir = git_root, patterns = system.patterns })
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
  cache[git_root] = targets
	return targets
end

return M
