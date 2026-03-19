--- yank-highlight.lua
---
--- Briefly highlights yanked, deleted, or changed text using Neovim's
--- built-in `vim.hl.on_yank()` helper.  Different highlight groups
--- distinguish yank from destructive operations.
---
--- Trigger:
---   TextYankPost
---
--- Configuration:
---   Highlight groups:
---     YankFlash              yank (y)                   (link: IncSearch)
---     YankFlashDelete        delete / change (d, c, x)  (link: DiffDelete)
---   Duration: 300ms
---
--- Highlight groups are defined on load and can be overridden beforehand.

vim.api.nvim_set_hl(0, 'YankFlash', { link = 'IncSearch' })
vim.api.nvim_set_hl(0, 'YankFlashDelete', { link = 'DiffDelete' })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('my/yank_highlight', { clear = true }),
  desc = 'Highlight yanked region',
  callback = function()
    local hl = vim.v.event.operator == 'y' and 'YankFlash' or 'YankFlashDelete'
    vim.hl.on_yank({ higroup = hl, timeout = 300 })
  end,
})
