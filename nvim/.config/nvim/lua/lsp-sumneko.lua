local util = require('lspconfig/util')

local sumneko_root_path = '/home/breno/.cache/nvim/lsp/lua-language-server'
local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"

require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"}
}
-- vim:et ts=2

  -- settings = {
  --   Lua = {
  --     completion = {
  --         keywordSnippet = { "Disable"}
  --     },
  --     runtime = {
  --       version = '5.1.5',
  --       path = vim.split(package.path, ';'),
  --     },
  --     diagnostics = {
  --       globals = {"vim", "love"},
  --       disable = {"lowercase-global", "unused-vararg"}
  --     },
  --     workspace = {
  --       -- Make the server aware of Neovim runtime files
  --       library = {
  --         [vim.fn.expand('$VIMRUNTIME/lua')] = true,
  --         [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
  --       },
  --     },
  --   },
  -- },
