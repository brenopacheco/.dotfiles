local vim = vim
local util = require 'vim.lsp.util'

local M = {}

-- modified to set max width and height
M['textDocument/hover'] = function(_, method, result)
  print("hovering w/ custom handler")
  util.focusable_float(method, function()
    if not (result and result.contents) then
      return
    end
    local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
      return
    end
    local bufnr, winnr = util.fancy_floating_markdown(markdown_lines, {
      pad_left = 1; pad_right = 1; max_width = 60; max_height = 14;
    })
    util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, winnr)
    return bufnr, winnr
  end)
end

-- modified to set max width and height
M['textDocument/signatureHelp'] = function(_, _, result)
  if not (result and result.signatures and result.signatures[1]) then
    print('No signature help available')
    return
  end
  local markdown_lines = util.convert_signature_help_to_markdown_lines(result)
  markdown_lines = util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then
    return
  end
  local bufnr, winnr = util.fancy_floating_markdown(markdown_lines, {
    pad_left = 1; pad_right = 1; max_width = 60; max_height = 14;
  })
  util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, winnr)
  return bufnr, winnr
end

return M

-- vim:sw=2 ts=2 et
