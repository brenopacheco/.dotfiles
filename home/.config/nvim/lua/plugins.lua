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

	-- TODO: replace completion plugin with https://cmp.saghen.dev/
	-- 'saghen/blink.cmp@v0.13.0',
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
	-- TODO: replace nvim-lspconfig with v0.11 built-in lsp.config
	-- https://github.com/neovim/neovim/discussions/32523#discussioncomment-12256014
	'neovim/nvim-lspconfig',
	'ray-x/lsp_signature.nvim',
	'chrishrb/gx.nvim',
	'pmizio/typescript-tools.nvim',
	'nvim-treesitter/nvim-treesitter',
	'nvim-treesitter/nvim-treesitter-textobjects',
	'JoosepAlviste/nvim-ts-context-commentstring',
	'numToStr/Comment.nvim',
	'folke/todo-comments.nvim',
	'simrat39/symbols-outline.nvim', -- replacement 'hedyhli/outline.nvim' is buggy
	'nvim-telescope/telescope.nvim',
	'HiPhish/rainbow-delimiters.nvim', -- TODO: check if broken with treesitter
	'Bekaboo/dropbar.nvim',
	'monkoose/matchparen.nvim',

	-- NOTE: custom forks for deprecated plugins
	'brenopacheco/neodev.nvim', -- replace with 'folke/lazydev.nvim' and make vim global (slow loading)
	'brenopacheco/gitlinker.nvim', -- removes default keybinding
	'brenopacheco/vim-floaterm', -- fixes Vim:E444 on-close last window
	'brenopacheco/zk-nvim', -- loads ~/.config/zk/config.toml:notebook.dir
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
