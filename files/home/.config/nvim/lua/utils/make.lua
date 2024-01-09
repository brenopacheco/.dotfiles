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
			file = file,
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

		--[[
--- get all projects from solutions
fd sln | xargs -i bash -c 'cd $(dirname {}) >/dev/null; dotnet sln list | tail -n +3 | xargs realpath 2>/dev/null' | sort | uniq
--- equivalent to
fd '\.csproj$'


dotnet sln list / dotnet sln <path to sol> list

From solution .sln files we can run from there:
- dotnet build
- dotnet clean
- dotnet restore
- dotnet test
- dotnet list (package/project)
- dotnet format
- dotnet sln list
- dotnet sln add <input>
- dotnet sln remove <input>

From project .csproj files we can run from there:
- dotnet build
- dotnet clean
- dotnet restore
- dotnet run
- dotnet watch
- dotnet format
- dotnet test
- dotnet list (package/project)

Tests can be
- dotnet test
- dotnet test --filter 'Category=Integration'
- dotnet test --filter 'Category=Unit'

To format
- dotnet format

Aditionally, we might want to run tools

`dotnet tool list`
Package Id                      Version      Commands                 Manifest
----------------------------------------------------------------------------------------------------------------------
swashbuckle.aspnetcore.cli      6.5.0        swagger                  /home/breno/fc/backend/.config/dotnet-tools.json
dotnet-ef                       8.0.0        dotnet-ef                /home/breno/fc/backend/.config/dotnet-tools.json
dotnet-sonarscanner             6.0.0        dotnet-sonarscanner      /home/breno/fc/backend/.config/dotnet-tools.json
dotnet-coverage                 17.9.3       dotnet-coverage          /home/breno/fc/backend/.config/dotnet-tools.json


  --info            Display .NET information.
  --list-runtimes   Display the installed runtimes.
  --list-sdks       Display the installed SDKs.
  --version         Display .NET SDK version in use.

SDK commands:
  add               Add a package or reference to a .NET project.
  build             Build a .NET project.
  build-server      Interact with servers started by a build.
  clean             Clean build outputs of a .NET project.
  format            Apply style preferences to a project or solution.
  help              Show command line help.
  list              List project references of a .NET project.
  msbuild           Run Microsoft Build Engine (MSBuild) commands.
  new               Create a new .NET project or file.
  nuget             Provides additional NuGet commands.
  pack              Create a NuGet package.
  publish           Publish a .NET project for deployment.
  remove            Remove a package or reference from a .NET project.
  restore           Restore dependencies specified in a .NET project.
  run               Build and run a .NET project output.
  sdk               Manage .NET SDK installation.
  sln               Modify Visual Studio solution files.
  store             Store the specified assemblies in the runtime package store.
  test              Run unit tests using the test runner specified in a .NET project.
  tool              Install or manage tools that extend the .NET experience.
  vstest            Run Microsoft Test Engine (VSTest) commands.
  workload          Manage optional workloads.





dotnet test --filter 'Category=Integration'
dotnet test --filter 'Category=Unit'
        ]]

		table.insert(targets, {
			name = 'test Category=Unit',
			cmd = [[]],
			dir = dir,
			file = file,
			kind = 'dotnet',
		})
		table.insert(targets, {
			name = 'test Category=Integration',
			cmd = [[]],
			dir = dir,
			file = file,
			kind = 'dotnet',
		})
		return targets
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
	return targets
end

return M
