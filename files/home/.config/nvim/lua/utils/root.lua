local M = {}

---@class Root
---@field path string
---@field pattern string
---@field file string

local root_patterns = {
	'^package%.json$',
	'^project%.json$',
	'%.sln$',
	'%.csproj$',
	'^go%.mod$',
	'^Makefile$',
	'^Cargo.toml$',
	'^tasks.json$',
	'^%.git$',
	'^init.lua$',
}

--- Returns a list of files in a directory
---@param dir string directory
---@return string[] -- list of filenames
local function dir_files(dir)
	assert(dir ~= nil, 'Invalid dir')
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
	local files = dir_files(dir)
	for _, file in ipairs(files) do
		local matches = string.match(file, pattern)
		if matches then
			return file
		end
	end
end

--- Find all downward roots for the given file patterns.
---
---@param opts { dir: string, patterns: string[] }
---@return Root[]
M.downward_roots = function(opts)
	local obj = vim
		.system({ 'fd', '-a', '-H', '.', opts.dir }, { text = true })
		:wait()
	assert(obj.code == 0, 'fd failed')
	local list = vim.split(obj.stdout, '\n')
	---@type Root[]
	local matches = {}
	for _, pattern in ipairs(opts.patterns) do
		for _, path in ipairs(list) do
			local file = tostring(vim.fs.basename(path))
			local dir = tostring(vim.fs.dirname(path))
			if string.match(file, pattern) ~= nil then
				table.insert(matches, {
					path = dir,
					pattern = pattern,
					file = file,
				})
			end
		end
	end
	return matches
end

--- Find all upward roots for the given file patterns.
---
---@param opts { dir: string, patterns: string[] }
---@return Root[]
M.upward_roots = function(opts)
	local roots = {}
	for _, pattern in ipairs(opts.patterns) do
		---@type string
		local _dir = opts.dir
		local file = nil
		repeat
			file = has_file(_dir, pattern)
			if file then
				table.insert(roots, { path = _dir, pattern = pattern, file = file })
			end
			_dir = string.gsub(_dir, '/[^/]+/?$', '')
		until _dir == '/' or _dir == ''
	end
	return roots
end

--- Find all roots from the git repository (defaults to current directory)
--
---@return Root[]
M.all_roots = function()
	return M.downward_roots({ patterns = root_patterns, dir = M.git_root() })
end

--- Finds the path for the git root in current cwd. If not a git repository,
--- uses the current directory.
---
--- @param cwd string?
--- @return string -- directory
M.git_root = function(cwd)
	cwd = cwd or vim.fn.getcwd()
	local result = vim
		.system({ 'git', 'rev-parse', '--show-toplevel' }, { text = true, cwd = cwd })
		:wait()
	if result.code == 0 then
		return vim.trim(result.stdout)
	end
	return tostring(vim.fn.getcwd())
end

--- Find the first project root for the current directory.
---
---@return Root[] The project roots
M.project_roots = function()
	local roots = M.upward_roots({
		patterns = root_patterns,
		dir = tostring(vim.fn.getcwd()),
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
