local M = {}

--- Returns a list of files in a directory
---@param dir string directory
---@return string[] -- list of filenames
local function dir_files(dir)
	local files = {}
	local req = vim.loop.fs_scandir(dir)
	if req then
		repeat
			local name, _ = vim.loop.fs_scandir_next(req)
			if name then
				table.insert(files, name)
			end
		until not name
	end
	return files
end

--- Checks wether a file or directory exists in directory
---
--- @param dir string directory
--- @param pattern string filename pattern
--- @return string|nil -- true if file exists, filename matching pattern
local function has_file(dir, pattern)
	local files =  dir_files(dir)
	for _, file in ipairs(files) do
		if string.match(file, pattern) then
			return file
		end
	end
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
---@return {path: string, pattern: string, file: string}[] The project roots
M.project_roots = function()
	local roots = M.roots({
		'package%.json',
		'project%.json',
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

M.is_git = function()
	local result = vim
		.system({ 'git', 'rev-parse', '--show-toplevel' }, { text = true })
		:wait()
	return result.code == 0
end

return M
