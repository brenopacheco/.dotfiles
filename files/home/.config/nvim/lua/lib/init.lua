local state = require('lib.state')

local M = {}

---Perform a query on the current state of the editor.
---@param query? lib.Query
---@return lib.State
M.find = function(query) return state.filter(state.get(), query or {}) end

return M
