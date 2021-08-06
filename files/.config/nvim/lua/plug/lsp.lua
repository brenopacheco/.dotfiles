-- File: lsp.lua
-- Description: boot up server configurations
local util = require 'vim.lsp.util'


local lspconfig = require('lspconfig')

vim.lsp.set_log_level(4) -- disable logging

-- lspconfig.diagnosticls.setup(require('plug.lsp.diagnosticls'))
lspconfig.sumneko_lua.setup(require('plug.lsp/sumneko_lua'))

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

-- make formatting use diagnosticls
local function select_client(method)
  local clients = vim.tbl_values(vim.lsp.buf_get_clients())
  clients =
    vim.tbl_filter(
    function(client)
      return client.supports_method(method)
    end,
    clients
  )

  for i = 1, #clients do
    if  clients[i].name == "diagnosticls" then
      return clients[i]
    end
  end

  return nil
end

local function range_formatting(options, start_pos, end_pos)
  local client = select_client("textDocument/rangeFormatting")
  if client == nil then return end

  local params = util.make_given_range_params(start_pos, end_pos)
  params.options = util.make_formatting_params(options).options
  return client.request("textDocument/rangeFormatting", params)
end

local function formatting(options)
  local client = select_client("textDocument/formatting")
  if client == nil then return end

  local params = util.make_formatting_params(options)
  return client.request("textDocument/formatting", params, nil, vim.api.nvim_get_current_buf())
end

vim.lsp.buf.formatting = formatting
vim.lsp.buf.range_formatting = range_formatting


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
        on_attach = require('keymap').register_lsp;
        root_dir = root;
        capabilities = capabilities;
        settings = {documentFormatting = false};
    }
end


local vint = require 'diagnosticls-nvim.linters.vint'
local eslint = require 'diagnosticls-nvim.linters.eslint'
local prettier_eslint = require 'diagnosticls-nvim.formatters.prettier_eslint'
local lua_format = require 'diagnosticls-nvim.formatters.lua_format'

require 'diagnosticls-nvim'.init {
  on_attach = function(client) print('Attached to ' .. client.name) end;
}

require 'diagnosticls-nvim'.setup {
  ['javascript'] = {
    linter = eslint,
    formatter = prettier_eslint
  };
  ['javascriptreact'] = {
    linter = eslint,
    formatter = prettier_eslint
  };
  ['typescript'] = {
    linter = eslint,
    formatter = prettier_eslint
  };
  ['typescriptreact'] = {
    linter = eslint,
    formatter = prettier_eslint
  };
  ['vint'] = {
    linter = vint
  },
  ['lua'] = {
    formatter = lua_format
  }
}




local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
