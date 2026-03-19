-- unorganized

local gh = function(x) return 'https://github.com/' .. x end
vim.pack.add({
  gh('EdenEast/nightfox.nvim'),
  gh('stevearc/conform.nvim'),
  gh('stevearc/oil.nvim'),
  gh('tpope/vim-fugitive'),
  gh('kylechui/nvim-surround'),
  gh('folke/snacks.nvim'),
  gh('neovim/nvim-lspconfig'),
  gh('lewis6991/gitsigns.nvim'),
  gh('bluz71/vim-nightfly-guicolors'),
  { src = gh('Saghen/blink.cmp'), version = 'v1.10.2' },
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
})

-- vim
--   .iter(vim.pack.get())
--   :filter(function(x) return not x.active end)
--   :map(function(x) return x.spec.name end)
--   :each(function(name) vim.pack.del({ name }) end)

vim.cmd('packadd cfilter')
vim.cmd([[
  nnoremap qf :Cfilter //<left>
  nnoremap qv :Cfilter! //<left>
]])

require('nvim-surround').setup()
vim.cmd('colorscheme nightfly')
