--- config-dev.lua
---
--- Neovim config development helpers.
---
--- Auto-formats config files on save via conform.nvim, then reloads the
--- module so changes take effect immediately without restarting.
---
--- Triggers:
---   BufWritePre   config/**/*.lua, init.lua
---   BufWritePost  config/**/*.lua, init.lua

local config_pattern = {
  vim.fn.stdpath('config') .. '/init.lua',
  vim.fn.stdpath('config') .. '/**/*.lua',
}

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('my/auto-format', { clear = true }),
  pattern = config_pattern,
  desc = 'Auto-format Neovim config file before save',
  callback = function(ctx) require('conform').format({ bufnr = ctx.buf }) end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('my/auto-reload', { clear = true }),
  pattern = config_pattern,
  desc = 'Auto-reload Neovim config module on save',
  callback = function(ctx)
    if ctx.match:find('/my/') then
      for mod in pairs(package.loaded) do
        if mod == 'my' or mod:match('^my%.') then package.loaded[mod] = nil end
      end
      return
    end
    vim.cmd.source(ctx.match)
  end,
})

return {}
