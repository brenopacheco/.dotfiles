local M = {}

--- Checks wether a file or directory exists in directory
---
--- @param dir string directory
--- @param pattern string filename pattern
--- @return string|nil -- true if file exists, filename matching pattern
local function has_file(dir, pattern)
	local req = vim.loop.fs_scandir(dir)
	if req then
		repeat
			local name, _ = vim.loop.fs_scandir_next(req)
			if name then
				if string.match(name, pattern) then
					return name
				end
			end
		until not name
	end
	return nil
end

--- Find all upward roots for the given file patterns.
---
---@param patterns string[] The filename patterns to match
---@return {path: string, pattern: string, file: string}[]
M.roots = function(patterns)
	local roots = {}
	for _, pattern in ipairs(patterns) do
		local dir = vim.fn.getcwd() or '/'
		local file = nil
		repeat
			file = has_file(dir, pattern)
			if file then
				table.insert(roots, { path = dir, pattern = pattern, file = file })
			end
			dir = dir.gsub(dir, '/[^/]+$', '')
		until dir == '/' or dir == ''
	end
	return roots
end

--- Finds the path for the git root in current cwd. If not a git repository,
--- uses the current directory.
---
--- @return string -- directory
M.git_root = function()
	local result = vim
		.system({ 'git', 'rev-parse', '--show-toplevel' }, { text = true })
		:wait()
	if result.code == 0 then
		return vim.trim(result.stdout)
	end
	return tostring(vim.fn.getcwd())
end

--- Find the first project root for the current directory.
---
---@return {path: string, pattern: string, file: string} The first project root
M.project_roots = function()
	local roots = M.roots({
		'package%.json',
		'.*%.sln',
		'.*%.csproj',
		'go%.mod',
		'Makefile',
		'Cargo.toml',
	})
	if #roots == 0 then
		return {}
	end
	table.sort(roots, function(a, b)
		return string.len(a.path) > string.len(b.path)
	end)
	return roots
end

return M
