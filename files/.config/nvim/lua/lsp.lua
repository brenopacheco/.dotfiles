-- File: lsp.lua
-- Description: boot up server configurations

local lspconfig = require('lspconfig')

vim.lsp.set_log_level(4) -- disable logging

lspconfig.diagnosticls.setup(require('lsp.diagnosticls'))
lspconfig.sumneko_lua.setup(require('lsp.sumneko_lua'))

local servers = {
    "bashls",
    "ccls",
    "cssls",
    "html",
    "jdtls",
    "jedi_language_server",
    "jsonls",
    "tsserver",
    "vimls",
    "yamlls"
}

-- enable snippets. we are interested in function call snippets
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local root = require('lspconfig/util').root_pattern(".git", vim.fn.getcwd())

for _, server in pairs(servers) do
    lspconfig[server].setup{
        root_dir = root,
        capabilities = capabilities
    }
end


