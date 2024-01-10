--- Alias for `vim.print`
---
--- Example:
---
--- ```lua
--- local hl_normal = vim.print(vim.api.nvim_get_hl(0, { name = 'Normal' }))
--- ```
---@type fun(...: any): nil
_G.P = nil

---@type string
local x = nil
