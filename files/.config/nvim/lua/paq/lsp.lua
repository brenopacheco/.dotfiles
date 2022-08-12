local lspconfig = require('lspconfig')
local utils = require('utils')

vim.lsp.set_log_level(vim.log.levels.ERROR) -- disable logging

lspconfig.sumneko_lua.setup(require('paq.lsp.sumneko_lua'))
lspconfig.omnisharp.setup(require('paq.lsp.omnisharp'))

local servers = {
  'bashls', -- bash-language-server
  'clangd', -- clang, bear -> "bear -- make build"
  'cssls', -- vscode-langservers-extracted
  'dockerls', -- dockerfile-language-server-nodejs
  'eslint', -- eslint, vscode-langservers-extracted
  'tailwindcss', -- @tailwindcss/language-server
  'html', -- vscode-langservers-extracted
  'jsonls', -- vscode-langservers-extracted
  'tsserver', -- typescript typescript-language-server
  'vimls', -- vim-language-server
  'yamlls', -- yaml-language-server
  'gopls', -- go, gopls
  'rust_analyzer' -- rust, rust-analyzer
}

-- enable snippets. we are interested in function call snippets
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {'documentation', 'detail', 'additionalTextEdits'}
}

local root = require('lspconfig/util').root_pattern('.git', vim.fn.getcwd())
for _, server in pairs(servers) do
  lspconfig[server].setup {
    on_attach = utils.lsp_attach,
    root_dir = root,
    capabilities = capabilities,
    settings = {
      documentFormatting = false,
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = {enable = true}
      },
      yaml = {
        schemaStore = { enable = true }
      }
    }
  }
end

-- custom diagnostic signs / remove underline
local signs = {
  Error = ' ',
  Warning = ' ',
  Hint = ' ',
  Information = ' '
}
for type, icon in pairs(signs) do
  local hl = 'LspDiagnosticsSign' .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ''})
end

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true
})

function vim.lsp.buf.peek_definition()
  local function preview_location_callback(_, result, method)
    if result == nil or vim.tbl_isempty(result) then
      vim.lsp.log.info(method, 'No location found')
      return nil
    end
    local location = result
    if vim.tbl_islist(result) then location = result[1] end
    if location.range == nil then
      location.targetRange['end'].line = location.targetRange['end'].line + 20
    else
      location.range['end'].line = location.range['end'].line + 20
    end
    vim.lsp.util.preview_location(location)
  end
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params,
                      preview_location_callback)
end

-- NOTE: check that it works
-- vim.cmd([[
--   autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
--   autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js,*.json Neoformat
-- ]])

-- Fix behavior of <C-]>
vim.lsp.handlers['textDocument/definition'] =
    function(_, result, ctx, config)
      if result == nil or vim.tbl_isempty(result) then
        local _ = vim.lsp.log.info() and
                      vim.lsp.log.info(ctx.method, 'No location found')
        return nil
      end
      local client = vim.lsp.get_client_by_id(ctx.client_id)

      config = config or {}

      if vim.tbl_islist(result) then
        vim.lsp.util.jump_to_location(result[1], client.offset_encoding,
                                      config.reuse_win)

        if #result > 1 then
          vim.fn.setqflist({}, ' ', {
            title = 'LSP locations',
            items = vim.lsp.util
                .locations_to_items(result, client.offset_encoding)
          })
          vim.api.nvim_command('botright copen')
          vim.api.nvim_command('wincmd p') -- this is the added line
        end
      else
        vim.lsp.util.jump_to_location(result, client.offset_encoding,
                                      config.reuse_win)
      end
    end
