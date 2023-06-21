local utils = require('utils')

local M = {
  cmd = {'/home/breno/.cache/nvim/lsp/elixir-ls/language_server.sh'},
  on_attach = utils.lsp_attach,
}

return M
