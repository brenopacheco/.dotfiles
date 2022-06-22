local M = {}

-- Recursively find a file or directory up in the fs and return the directory
-- where it is found, given the Lua regex for the file or directory.
-- Return dir, and file path
function M.root(regex)
  function scandir(dir)
    local req = vim.loop.fs_scandir(dir)
    local function iter() return vim.loop.fs_scandir_next(req) end
    for name, _ in iter do
      if string.match(name, regex) then return name end
    end
    return false
  end
  local dir = vim.fn.getcwd()
  while dir ~= '' do
    match = scandir(dir)
    if match then return dir, match end
    dir = dir.gsub(dir, '/[^/]+$', '')
  end
  return nil, nil
end

return M
