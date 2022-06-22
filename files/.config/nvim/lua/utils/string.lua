local M = {}

function M.truncate(str, max_len, start)
  if string.len(str) > max_len then
    if start then
      return '…' .. string.sub(str, string.len(str) - max_len + 2)
    else
      return string.sub(str, 1, max_len) .. '…'
    end
  end
  return str
end

return M
