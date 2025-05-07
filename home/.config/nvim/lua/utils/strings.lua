local M = {}

M.truncate_path = function(path, max_len)
	local match
	local tpath = tostring(path)
	while true do
		if string.len(tpath) <= max_len or string.find(tpath, '^/?[^/]+$') then
			break
		end
		tpath, match = string.gsub(tpath, '^/[^/]+', '')
		if match == 0 then break end
	end
	if string.len(path) > string.len(tpath) then
		return '…' .. tpath, string.len(tpath) + 1
	end
	return tpath, string.len(tpath)
end

return M
