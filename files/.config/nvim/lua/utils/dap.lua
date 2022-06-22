local M = {}

M.toggle_debug = function()
  if string.len(require('dap').status()) == 0 then
    require('dap').continue()
  end
  require('dap').terminate()
end

return M
