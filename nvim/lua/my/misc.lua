---@class my.misc
local M = {}

M.uuid = function()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function(c)
    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
  end)
end

--- Check if file exists
--- @param path string file path
--- @return boolean true if file exists
M.exists = function(path) return vim.fn.filereadable(path) == 1 end

--- Read file contents synchronously
--- @param path string File path
--- @return string[]|nil File contents
M.read = function(path)
  local status, text = pcall(vim.fn.readfile, path)
  return status and text or nil
end

M.feedkeys = function(str)
  local cmd = vim.api.nvim_replace_termcodes(str, true, true, true)
  vim.api.nvim_feedkeys(cmd, 'n', true)
end

M.root = function(dir) return vim.fs.root(dir or vim.fn.getcwd(0), '.git') end

return M
