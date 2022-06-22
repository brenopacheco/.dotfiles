local M = {}

M.toggle_debug = function()
  if string.len(require('dap').status()) == 0 then
    require('dap').continue()
  end
  require('dap').terminate()
end

M.attach = function()
  print("To implement")
end

M.open_log = function()
  local path = vim.fn.stdpath('cache') .. '/dap.log'
  vim.cmd('vsp ' .. path)
end

return M
