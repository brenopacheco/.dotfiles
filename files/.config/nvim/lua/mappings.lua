-- File: mappings.lua
-- Description: key maps

table.unpack = function(t, i)
  i = i or 1
  if t[i] ~= nil then
    return t[i], unpack(t, i + 1)
  end
end

local function _map(...)
  for _,v in pairs({...}) do
    vim.api.nvim_set_keymap(table.unpack(v))
  end
end

_map(
    {"i", "jk", "<C-[>l", { noremap = true }},
    {"i", "kj", "<C-[>l", { noremap = true }},
    {"c", "jk", "<C-c>", { noremap = true }},
    {"c", "kj", "<C-c>", { noremap = true }},
    {"n", "<leader>b", "<cmd>lua cfn.goto_buf()<CR>", { noremap = true }},
    {"n", "#", ":so %<CR>", { noremap = true}}
)

_G.cfn = {}
_G.cfn.goto_buf = function()
    vim.api.nvim_command('ls')
    local buf = vim.api.nvim_eval("input('> ', '', 'buffer')")
    -- TODO: check if buf is a string, if so get bufnr from string
    vim.api.nvim_set_current_buf(buf)
end

--[[
what do i want
    1. jumps
        cnext,cprev,copen,
        lnext(e]),lprev,lopen,
        bn,bp,b jump
    2. qf/ll filters
    3. align, surround, comment
 ]]
