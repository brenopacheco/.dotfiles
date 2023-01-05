-- curl -fLO https://github.com/elixir-lsp/elixir-ls/releases/latest/download/elixir-ls.zip
-- unzip elixir-ls.zip -d /path/to/elixir-ls
-- chmod +x /path/to/elixir-ls/language_server.sh

local utils = require('utils')

local M = {
  cmd = {'/home/breno/.cache/nvim/lsp/elixir-ls/language_server.sh'},
  on_attach = utils.lsp_attach,
}

return M
