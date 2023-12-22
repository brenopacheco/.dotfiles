local M = {}

--- Read a file synchronously
---
---@param path string File path
---@return string|nil File contents
M.read = function(path)
	local fd = assert(vim.uv.fs_open(path, 'r', 438))
	local stat = assert(vim.uv.fs_fstat(fd))
	local data = assert(vim.uv.fs_read(fd, stat.size, 0))
	assert(vim.uv.fs_close(fd))
	if type(data) == 'string' then
		return data
	end
	return nil
end

--- Split file contents into multiple lines
---
---@param data string File contents
---@return string[] Lines
M.lines = function(data)
	local lines = {}
	for line in string.gmatch(data, '[^\r\n]+') do
		table.insert(lines, line)
	end
	return lines
end

--- Check if file exists
--- @param path string File path
--- @return boolean
M.exists = function(path)
	return vim.fn.filereadable(path) == 1
end

return M
