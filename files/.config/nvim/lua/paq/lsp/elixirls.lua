local utils = require('utils')

function on_attach(client, bufnr)
  utils.lsp_attach(client, bufnr)
end

local M = {
  cmd = {'/home/breno/.cache/nvim/lsp/elixir-ls/language_server.sh'},
  on_attach = utils.lsp_attach,
}

return M
