-- File: servers.lua
-- Author: Breno Leonhardt Pacheco
-- Email: brenoleonhardt@gmail.com
-- Last Modified: February 23, 2021
-- Description: boot up server configurations

local lspconfig = require'lspconfig'

-- lspconfig.diagnosticls.setup(require('conf.servers.diagnosticls'))
lspconfig.sumneko_lua.setup(require('conf.servers.sumneko_lua'))

-- vim.lsp.set_log_level(4)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local root = require('lspconfig/util').root_pattern(".git", vim.fn.getcwd())

local servers = { "bashls", "ccls", "cssls", "jsonls", "vimls",
                  "jedi_language_server", "bashls", "jdtls",
                  "tsserver"}
-- "tsserver",

for _, server in pairs(servers) do
    lspconfig[server].setup{
        root_dir = root,
        capabilities = capabilities
    }
end


