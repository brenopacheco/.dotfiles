local context = require('completions.context')

local M = {}

---@type CompletionContext
local ctx = nil

---@param opts? CompletionOpts
M.setup = function(opts)
  vim.o.completeopt = 'menuone,noinsert'
  ctx = context:new(opts)
end

return M
