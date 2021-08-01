--[[
██╗███╗   ██╗██╗████████╗   ██╗     ██╗   ██╗ █████╗ 
██║████╗  ██║██║╚══██╔══╝   ██║     ██║   ██║██╔══██╗
██║██╔██╗ ██║██║   ██║      ██║     ██║   ██║███████║
██║██║╚██╗██║██║   ██║      ██║     ██║   ██║██╔══██║
██║██║ ╚████║██║   ██║   ██╗███████╗╚██████╔╝██║  ██║
╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
		              Breno Leonhardt Pacheco
		             brenoleonhardt@gmail.com

[ ] lsp
[ ] completion
[ ] statusline
[ ] telescope
[ ] surround, etc
[ ] bindings
[ ] plugin manager

https://github.com/rockerBOO/awesome-neovim
--]]

vim.cmd([[
    set clipboard=unnamed,unnamedplus
    set secure
    set noexrc
    call plug#begin('~/.cache/nvim/plug')
        let g:plug_timeout=99999

	" LSP
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/lsp-status.nvim'
	Plug 'simrat39/symbols-outline.nvim'
	Plug 'folke/trouble.nvim'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'onsails/lspkind-nvim'
	" https://github.com/ray-x/lsp_signature.nvim

	" FORMATTING

	" COMPLETION
        Plug 'hrsh7th/nvim-compe'
	Plug 'L3MON4D3/LuaSnip'
	Plug 'rafamadriz/friendly-snippets'
	Plug 'windwp/nvim-autopairs'

	" TELESCOPE
	Plug 'camspiers/snap'
	Plug 'nvim-telescope/telescope.nvim'

	" COLORSCHEME
	Plug 'embark-theme/vim', { 'as': 'embark' }
	Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
	Plug 'wadackel/vim-dogrun'

	" TREE
	Plug 'kyazdani42/nvim-tree.lua'

	" UI
	Plug 'hoob3rt/lualine.nvim'
	Plug 'lukas-reineke/indent-blankline.nvim'
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'folke/todo-comments.nvim'
	Plug 'akinsho/nvim-bufferline.lua'
	Plug 'folke/zen-mode.nvim'
	Plug 'folke/which-key.nvim'
	Plug 'edluffy/specs.nvim'
	" norcalli/nvim-colorizer.lua

	" GIT
	Plug 'sindrets/diffview.nvim'
	Plug 'lewis6991/gitsigns.nvim'
	Plug 'kdheepak/lazygit.nvim'
	Plug 'TimUntersberger/neogit'
	Plug 'tpope/vim-fugitive'

	" ACTIONS
	Plug 'b3nj5m1n/kommentary'
	Plug 'JoosepAlviste/nvim-ts-context-commentstring'

	" MOVEMENT
	Plug 'andymass/vim-matchup'

	" HELP

	" GENERAL
	Plug 'nvim-lua/plenary.nvim'
	Plug 'DanilaMihailov/vim-tips-wiki'
	Plug 'dstein64/vim-startuptime'

    call plug#end()
]])

-- require('plugins')
-- require('lsp')
require('treesitter')
-- require('completion')
require('mappings')
-- require('defaults')
-- require('settings')

vim.cmd([[
" set termguicolors
" colorscheme embark
" colorscheme tokyonight
" colorscheme dogrun
]])

-- https://github.com/folke/dot/tree/master/config/nvim/lua
-- https://github.com/ggandor/lightspeed.nvim
--https://github.com/notomo/cmdbuf.nvim
--https://github.com/rcarriga/vim-ultest
--https://github.com/NTBBloodbath/rest.nvim
-- paq
-- packer
