local util = require 'lspconfig.util'
local lspconfig = require('lspconfig')
local utils = require('utils')

vim.lsp.set_log_level(vim.log.levels.DEBUG) -- disable logging
-- vim.lsp.set_log_level(vim.log.levels.ERROR) -- disable logging

lspconfig.lua_ls.setup(require('paq.lsp.sumneko_lua'))
lspconfig.elixirls.setup(require('paq.lsp.elixirls'))
lspconfig.omnisharp.setup(require('paq.lsp.omnisharp'))

--[[
pacman -S lua-language-server

elixir-ls
wget https://github.com/elixir-lsp/elixir-ls/releases/latest/download/elixir-ls.zip -O /tmp/elixir-ls.zip
mkdir -p ~/.cache/nvim/lsp/elixir-ls
unzip /tmp/elixir-ls.zip -d ~/.cache/nvim/lsp/elixir-ls

rosalyn omnisharp
wget https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v1.39.3/omnisharp-linux-x64-net6.0.zip -O /tmp/omnisharp.zip
mkdir -p ~/.cache/nvim/lsp/omnisharp
unzip /tmp/omnisharp.zip -d ~/.cache/nvim/lsp/omnisharp
chmod +x ~/.cache/nvim/lsp/omnisharp/OmniSharp

npm i -g \
  eslint prettier prettier-eslint-cli \
  bash-language-server \
  tailwindcss-language-server \
  dockerfile-language-server-nodejs \
  vscode-langservers-extracted \
  typescript typescript-language-server \
  vim-language-server \
  vscode-langservers-extracted \
  yaml-language-server
]]


local servers = {
  'ansiblels',
  'bashls',
  'clangd', -- clang, bear -> "bear -- make build"
  'cssls',
  'dartls',
  'dockerls',
  'eslint',
  'gopls', -- go, gopls
  'html',
  'jsonls',
  'rust_analyzer', -- rust, rust-analyzer
  'svelte', -- svelte-language-server
  'tailwindcss',
  'tsserver',
  'vimls',
  'yamlls',
  'prismals'
}

-- enable snippets. we are interested in function call snippets
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {'documentation', 'detail', 'additionalTextEdits'}
}

for _, server in pairs(servers) do
  -- local root_dir = lspconfig[server].document_config.default_config.root_dir

  -- if server == 'eslint' then
  --   local patterns = { '.git', '.eslintrc.json', '.eslintrc.js' }
  --   root_dir = util.root_pattern(patterns, vim.fn.getcwd())
  -- end

  lspconfig[server].setup {
    on_attach = utils.lsp_attach,
    -- root_dir = root_dir,
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
