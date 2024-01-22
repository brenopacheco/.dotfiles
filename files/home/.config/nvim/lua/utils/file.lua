local M = {}

--- Read a file synchronously
---
---@param path string File path
---@return string[]|nil File contents
M.read = function(path)
	local fd = assert(vim.uv.fs_open(path, 'r', 438))
	local stat = assert(vim.uv.fs_fstat(fd))
	local data = assert(vim.uv.fs_read(fd, stat.size, 0))
	assert(vim.uv.fs_close(fd))
	if type(data) ~= 'string' then return nil end
	local lines = {}
	for line in string.gmatch(data, '[^\r\n]+') do
		table.insert(lines, line)
	end
	return lines
end

--- Check if file exists
--- @param path string File path
--- @return boolean
M.exists = function(path) return vim.fn.filereadable(path) == 1 end

--- Read file contents synchronously (v2)
--- @param path string File path
--- @return string[]|nil File contents
M.read2 = function(path)
	local status, text = pcall(vim.fn.readfile, path)
	if not status then return nil end
	return text
end

return M
