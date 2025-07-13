local M = {}

M.is_empty_or_whitespace = function(str)
  return str:match("^%s*$") ~= nil
end

M.truncate_path = function(path, max_len)
	local match
	local tpath = tostring(path)
	if string.len(path) <= max_len then
		return path, string.len(path)
	end
	max_len = max_len - 3
	while true do
		if string.len(tpath) <= max_len or string.find(tpath, '^/?[^/]+$') then
			break
		end
		tpath, match = string.gsub(tpath, '^/[^/]+', '')
		if match == 0 then break end
	end
	return '…' .. tpath, string.len(tpath) + 3
end

M.is_truncated = function(path)
	return path:sub(1, 3) == '…'
end

return M
