-- local dap = require('dap')
local M = {}

--- Terminate debugger if running, or start debugger if not running.
M.toggle_debug = function()
  if string.len(require('dap').status()) == 0 then require('dap').continue() end
  require('dap').terminate()
end

--- Open dap.log file
M.open_log = function()
  local path = vim.fn.stdpath('cache') .. '/dap.log'
  vim.cmd('vsp ' .. path)
end

-- dap.adapters.<name> = function(callback, config) ... callback(adapter) ... end
-- dap.configurations.<language> = {...}

return M
