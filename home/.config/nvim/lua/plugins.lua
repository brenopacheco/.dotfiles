--- Plugins

vim.z.packadd({
	-- NOTE: OK
	'nvim-lua/plenary.nvim',
	'tpope/vim-fugitive',
	'lewis6991/gitsigns.nvim',
	'bluz71/vim-nightfly-guicolors',
	'kyazdani42/nvim-web-devicons',
	'norcalli/nvim-colorizer.lua',
	'shellRaining/hlchunk.nvim',
	'kylechui/nvim-surround',
	'junegunn/vim-easy-align',
	'sbdchd/neoformat', -- TODO: work with fmtexpr
	'danymat/neogen',
	'kyazdani42/nvim-tree.lua',
	'stevearc/oil.nvim',
	'j-hui/fidget.nvim',
	'nvim-lualine/lualine.nvim',

	-- TODO: replace with https://cmp.saghen.dev/
	-- 'zbirenbaum/copilot.lua',
	'L3MON4D3/LuaSnip',
	'saadparwaiz1/cmp_luasnip',
	'onsails/lspkind.nvim',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/nvim-cmp',
	'windwp/nvim-autopairs',


  -- NOTE: OK
	'b0o/schemastore.nvim',
	'neovim/nvim-lspconfig',
	'ray-x/lsp_signature.nvim',
	'chrishrb/gx.nvim',
	'pmizio/typescript-tools.nvim',
	'nvim-treesitter/nvim-treesitter',
	'nvim-treesitter/nvim-treesitter-textobjects',
	'JoosepAlviste/nvim-ts-context-commentstring',
	'numToStr/Comment.nvim',
	'folke/todo-comments.nvim',
	'simrat39/symbols-outline.nvim',
	'nvim-telescope/telescope.nvim',
	'HiPhish/rainbow-delimiters.nvim', -- TODO: check if broken with treesitter
	'Bekaboo/dropbar.nvim',
	'monkoose/matchparen.nvim',
	'jbyuki/one-small-step-for-vimkind', -- TODO: what is this?

	-- TODO: forks, check if can be patched instead
	'brenopacheco/neodev.nvim',
	'brenopacheco/gitlinker.nvim',
	'brenopacheco/vim-floaterm',
	'brenopacheco/zk-nvim',
})

vim.z.modload({
	-- TODO: check this
	'autochdir',
	'backup',
	'bufferizer',
	'file-url',
	'foldtext',
	'gpg',
	'last-place',
	'log',
	'macro-recording-unmap',
	'pdf',
	'reloader',
	'shada',
	'sniputil',
	'telescope-select',
	'trim',
	'yank-highlight',
})
