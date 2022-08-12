-- File:        lsp/sumneko_lua.lua
-- Description: sumneko special config
-- sumneko_lua will not disable snippets via `capabilities`
-- we can disable it via settings. right now we keep function call snippets
local utils = require('utils')

local sumneko_root_path = '/home/breno/.cache/nvim/lsp/lua-language-server'
local sumneko_binary = sumneko_root_path .. '/bin/lua-language-server'

local root = require('lspconfig/util').root_pattern('.git', vim.fn.getcwd())

local M = {
  cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
  root_dir = root,
  on_attach = utils.lsp_attach,
  settings = {
    Lua = {
      completion = {
        keywordSnippet = 'Disable'
        -- callSnippet = {'Both'},
      },
      runtime = {
        -- version = '5.1.5',
        version = 'LuaJIT',
        path = vim.split(package.path, ';')
      },
      diagnostics = {
        globals = {'vim', 'love'},
        disable = {'lowercase-global', 'unused-vararg'}
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
        }
      }
    }
  }
}

return M
