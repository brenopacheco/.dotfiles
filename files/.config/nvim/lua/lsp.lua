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



-- vim.fn.sign_define("LspDiagnosticsSignError",
--     {text = "E", texthl = ""})
-- vim.fn.sign_define("LspDiagnosticsSignWarning",
--     {text = "W", texthl = ""})
-- vim.fn.sign_define("LspDiagnosticsSignInformation",
--     {text = "I", texthl = ""})
-- vim.fn.sign_define("LspDiagnosticsSignHint",
--     {text = "H", texthl = ""})




local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
