-- File: lsp.lua
-- Description: boot up server configurations
local lspconfig = require('lspconfig')
local utils = require('utils')

vim.lsp.set_log_level(vim.log.levels.ERROR) -- disable logging

lspconfig.sumneko_lua.setup(require('plug.lsp/sumneko_lua'))
lspconfig.omnisharp.setup(require('plug.lsp/omnisharp'))


local servers = {
    "bashls",
    "clangd",
    "cssls",
    "dockerls",
    "eslint", -- still has some bugs
    "html",
    "jdtls",
    "jedi_language_server",
    "jsonls",
    "tsserver",
    "vimls",
    "yamlls",
    "gopls",
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
        on_attach = utils.lsp_attach;
        root_dir = root;
        capabilities = capabilities;
        settings = {documentFormatting = false};
    }
end

-- custom diagnostic signs / remove underline
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end


function vim.lsp.buf.peek_definition()
  local function preview_location_callback(_, result, method)
    if result == nil or vim.tbl_isempty(result) then
      vim.lsp.log.info(method, 'No location found')
      return nil
    end
    local location = result
    if vim.tbl_islist(result) then
      location = result[1]
    end
    if location.range == nil then
      location.targetRange['end'].line = location.targetRange['end'].line + 20
    else
      location.range['end'].line = location.range['end'].line + 20
    end
    vim.lsp.util.preview_location(location)
  end
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end
