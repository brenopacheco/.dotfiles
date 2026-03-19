--- last-place.lua
---
--- Restores the cursor to its last known position when reopening a file,
--- using the `"` mark that Vim automatically sets when leaving a buffer.
---
--- Autocmds:
---   BufReadPost  *  Restores cursor to last position.
---
--- Configuration:
---   Add filetypes to the `exclude` table to skip restoration for those
---   buffer types (e.g. git commits, where the mark is often meaningless).

local exclude = {
  gitcommit = true,
  gitrebase = true,
  fugitive = true,
}

local group = vim.api.nvim_create_augroup('my/last-place', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  pattern = { '*' },
  desc = 'Restore cursor to last position',
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    local bt = vim.bo[ev.buf].buftype
    if exclude[ft] or bt ~= '' then return end

    -- nvim_buf_get_mark returns {0, 0, 0, 0} for an unset mark.
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local row = mark[2]
    if row == 0 then return end
    local col = mark[3]
    local lcount = vim.api.nvim_buf_line_count(ev.buf)

    if row > 0 and row <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
    end
  end,
})

return {}
