-- File:   servers/sumneko_lua.lua
-- Author: breno
-- Email:  breno@Manjaro
-- Date:   Mon 22 Feb 2021 08:29:12 PM WET
-- vim:    set ft=lua

local sumneko_root_path = '/home/breno/.cache/nvim/lsp/lua-language-server'
local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"


local root = require('lspconfig/util').root_pattern(".git", vim.fn.getcwd())
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local M = {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    root_dir = root,
    capabilities = capabilities,
    settings = {
        Lua = {
            completion = {
                callSnippet = {'Both'},
                keywordSnippet = {'Both'}
            },
            runtime = {
                -- version = '5.1.5',
                version = 'LuaJIT',
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

