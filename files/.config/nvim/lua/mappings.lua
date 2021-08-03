-- File: mappings.lua
-- Description: key maps

table.unpack = function(t, i)
  i = i or 1
  if t[i] ~= nil then
    return t[i], unpack(t, i + 1)
  end
end

local function _map(...)
  for i,v in pairs({...}) do
    vim.api.nvim_set_keymap(table.unpack(v))
  end
end

_map(
  {"i", "jk", "<C-[>l", { noremap = true }},
  {"i", "kj", "<C-[>l", { noremap = true }}
)
