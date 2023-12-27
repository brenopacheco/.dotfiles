--- Plugins

vim.z.packadd({
	'nvim-lua/plenary.nvim',
	'tpope/vim-fugitive',
	'lewis6991/gitsigns.nvim',
	'bluz71/vim-nightfly-guicolors',
	'kyazdani42/nvim-web-devicons',
	'norcalli/nvim-colorizer.lua',
	'folke/which-key.nvim',
	'shellRaining/hlchunk.nvim',
	'brenopacheco/gx.nvim',
	'ruifm/gitlinker.nvim',
	'numToStr/Comment.nvim',
	'kylechui/nvim-surround',
	'junegunn/vim-easy-align',
	'sbdchd/neoformat',
	'danymat/neogen',
	'voldikss/vim-floaterm',
	'mickael-menu/zk-nvim',
	'kyazdani42/nvim-tree.lua',
	'stevearc/oil.nvim',
	'folke/zen-mode.nvim',
	'folke/twilight.nvim',
	'j-hui/fidget.nvim',
	'nvim-lualine/lualine.nvim',
	'L3MON4D3/LuaSnip',
	'saadparwaiz1/cmp_luasnip',
	'rafamadriz/friendly-snippets',
	'onsails/lspkind.nvim',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/nvim-cmp',
	'windwp/nvim-autopairs',
	'b0o/schemastore.nvim',
	'neovim/nvim-lspconfig',
	'ray-x/lsp_signature.nvim',
	'folke/neodev.nvim',
	'zbirenbaum/copilot.lua',
	'nvim-treesitter/nvim-treesitter',
	'JoosepAlviste/nvim-ts-context-commentstring',
	'folke/todo-comments.nvim',
	'simrat39/symbols-outline.nvim',
	'nvim-telescope/telescope.nvim',
	-- TODO
	'theHamsta/nvim-dap-virtual-text',
	'rcarriga/nvim-dap-ui',
	'mfussenegger/nvim-dap',
	'vim-test/vim-test',
})

vim.z.modload({
	'argsview',
	'autochdir',
	-- 'backup',
	'bufferizer',
	'gpg',
	'lf',
	'reloader',
	'shada',
	'sniputil',
	'telescope-select',
	'yank-highlight'
})
