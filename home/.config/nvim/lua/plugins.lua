local gh = function(x) return "https://github.com/" .. x end

vim.pack.add({
  -- gh("b0o/schemastore.nvim"),
  gh("bluz71/vim-nightfly-guicolors"),
  gh("folke/snacks.nvim"),
  gh("kylechui/nvim-surround"),
  gh("lewis6991/gitsigns.nvim"),
  -- gh("neovim/nvim-lspconfig"),
  -- gh("sbdchd/neoformat"),
  -- gh("shellRaining/hlchunk.nvim"),
  gh("stevearc/oil.nvim"),
  gh("tpope/vim-fugitive"),
  -- gh("zk-org/zk-nvim"),
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  { src = gh("Saghen/blink.cmp"), version = "v1.10.1" },
})

