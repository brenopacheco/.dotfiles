local M = {}

local rootutils = require('utils.root')

---@class DotnetProject
---@field name     string             : @project name
---@field dir      string             : @full path to the project directory
---@field csproj   string             : @full path to the project file
---@field solution DotnetSolution?    : @full path to the project directory
---@field type     'test'|'app'|'lib' : @project type

---@class DotnetSolution
---@field name     string           : @solution name
---@field sln      string           : @full path to the solution file
---@field dir      string           : @full path to the solution directory
---@field projects DotnetSolution[] : @list of projects in the solution

---@class DotnetResolve
---@field solutions  DotnetSolution[]            : @solutions
---@field projects   { [string]: DotnetProject } : @projects by name

---@type { [string]: DotnetResolve } @ map of directory to resolve
local cache = {}

---@param cwd? string
---@return DotnetResolve
M.resolve = function(cwd)
	cwd = cwd or vim.fn.getcwd()
	local root = rootutils.git_root(cwd)
	if cache[root] then return cache[root] end
	---@type DotnetResolve
	local data = {
		solutions = {},
		projects = {},
	}
	local csprojs = rootutils.downward_roots({
		dir = root,
		patterns = { '.*.csproj$' },
	})
	for _, csproj in ipairs(csprojs) do
		local type = 'lib'
		if csproj.file:match('Test') then type = 'test' end
		local programs = rootutils.downward_roots({
			dir = csproj.path,
			patterns = { '^Program.cs$' },
		})
		if #programs > 0 then type = 'app' end
		---@type DotnetProject
		local project = {
			name = csproj.file:match('(.*)%.csproj$'),
			dir = csproj.path,
			csproj = csproj.file,
			type = type,
		}
		data.projects[project.name] = project
	end
	local slns = rootutils.downward_roots({
		dir = root,
		patterns = { '.*.sln$' },
	})
	for _, sln in ipairs(slns) do
		local cmd = 'cd '
			.. sln.path
			.. '; dotnet sln list | tail -n +3 | xargs readlink -f'
		local paths = vim.fn.systemlist(cmd) or {}
		local projects = {}
		for _, path in ipairs(paths) do
			local name = path:match('.*/(.*)%.csproj$')
			if name and data.projects[name] then
				table.insert(projects, data.projects[name])
			end
		end
		---@type DotnetSolution
		local solution = {
			name = sln.file:match('(.*)%.sln$'),
			sln = sln.file,
			dir = sln.path,
			projects = projects,
		}
		table.insert(data.solutions, solution)
	end
	cache[root] = data
	return data
end

---@param dir string
---@param file string
---@return Target[]
M.csproj_targets = function(dir, file)
	local resolve = M.resolve(dir)
	local name = file:match('(.*)%.csproj$')
	local project = resolve.projects[name]
	if not project or project.type == 'lib' then return {} end
	if project.type == 'test' then
		return {
			name = 'test',
			cmd = 'dotnet test',
			dir = project.dir,
			id = name,
			kind = 'dotnet',
		}
	end
	return {
		{
			name = 'run',
			cmd = 'dotnet run',
			dir = project.dir,
			id = name,
			kind = 'dotnet',
		},
		{
			name = 'watch run',
			cmd = 'dotnet watch run',
			dir = project.dir,
			id = name,
			kind = 'dotnet',
		},
	}
end

---@param dir string
---@param file string
---@return Target[]
M.sln_targets = function(dir, file)
	local resolve = M.resolve(dir)
	local name = file:match('(.*)%.sln$')
	local solution = vim.tbl_filter(
		function(sln) return sln.name == name end,
		resolve.solutions
	)[1]
	if not solution then return {} end
	local cmds = { 'build', 'clean', 'format', 'test' }
	---@type Target[]
	local targets = {}
	for _, cmd in ipairs(cmds) do
		local target = {
			name = cmd,
			cmd = 'dotnet ' .. cmd,
			dir = solution.dir,
			id = name,
			kind = 'dotnet',
		}
		table.insert(targets, target)
	end
	return targets
end

return M
