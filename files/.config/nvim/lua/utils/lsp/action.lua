local util = vim.lsp.util

local M = {} 

local function code_action_request(params)
  local bufnr = vim.api.nvim_get_current_buf()
  local method = 'textDocument/codeAction'
  vim.lsp.buf_request_all(bufnr, method, params, function(results)

    local r = {}

    for _, result in pairs(results) do
      for _, list in pairs(result) do
        for _, item in ipairs(list) do
          table.insert(r, {kind = item.kind, title = item.title})
        end
      end
    end

    P(r)

  end)
end

M.get = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local params = util.make_range_params()
  params.context = {
    -- diagnostics = vim.diagnostic.get(bufnr)
    diagnostics = vim.diagnostic.get(bufnr, {lnum = 3})
  }
  code_action_request(params)
end

M.get()

return M
