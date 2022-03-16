local omnisharp_bin = "/home/breno/.cache/nvim/lsp/omnisharp/OmniSharp"

local utils = require('utils')

local M = {
    cmd = {omnisharp_bin, "--languageserver", "--hostPID", tostring(vim.fn.getpid())},
    on_attach = utils.lsp_attach,
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler
    }
}

return M
