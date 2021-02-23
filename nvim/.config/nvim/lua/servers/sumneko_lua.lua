-- File:   servers/sumneko_lua.lua
-- Author: breno
-- Email:  breno@Manjaro
-- Date:   Mon 22 Feb 2021 08:29:12 PM WET
-- vim:    set ft=lua

local sumneko_root_path = '/home/breno/.cache/nvim/lsp/lua-language-server'
local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"

local M = {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      completion = {
          keywordSnippet = { "Enable"}
      },
      runtime = {
        version = '5.1.5',
        -- version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {"vim", "love"},
        disable = {"lowercase-global", "unused-vararg"}
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  }
}

return M

