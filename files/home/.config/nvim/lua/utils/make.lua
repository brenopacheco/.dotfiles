local fileutil = require('utils.file')
local rootutil = require('utils.root')

local M = {}

---@class Target
---@field name string
---@field desc string
---@field cmd string
---@field dir string
---@field file string
---@field kind string

---@class System
---@field name string The system name
---@field patterns string[] The patterns to match against the system file
---@field targets fun(dir: string, file: string, data: string): Target[]

---@type System
local make = {
	name = 'make',
	patterns = { 'Makefile' },
	targets = function(dir, file, data)
		---@type Target[]
		local targets = {}
		for _, line in ipairs(fileutil.lines(data)) do
			local rule = string.match(line, '^([a-zA-Z_%-]+):')
			if rule ~= nil then
				---@type Target
				local target = {
					name = 'all',
					desc = 'run "' .. rule .. '" rule',
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

local systems = { make }

--- Get all run targets from all systems (make, go, rust, etc.)
---
---@return Target[]
M.targets = function()
	---@type Target[]
	local targets = {}
	for _, system in ipairs(systems) do
		local roots = rootutil.roots(system.patterns)
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
