--- auto-open-qf.lua
---
--- Automatically opens the quickfix window after :grep completes if
--- there are results, then returns focus to the previous window.
---
--- Trigger:
---   QuickFixCmdPost  grep

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('my/auto-open-qf', { clear = true }),
  desc = 'Auto-open quickfix on grep',
  callback = function()
    if #vim.fn.getqflist() > 0 then
      vim.cmd.cwindow()
      vim.cmd.wincmd('p')
    end
  end,
})

return {}
