local paq = require('paq')

paq({
    {'tweekmonster/startuptime.vim'};
    {'editorconfig/editorconfig-vim'};
    {'junegunn/vim-easy-align'};
    {'andymass/vim-matchup'};
    {'tpope/vim-surround'};
    {'junegunn/vim-easy-align'};
    {'b3nj5m1n/kommentary'};
    {'bluz71/vim-nightfly-guicolors'};
    {'hoob3rt/lualine.nvim',                config='lualine'};
    {'lukas-reineke/indent-blankline.nvim', config='blankline'};
    {'kyazdani42/nvim-web-devicons',        config='devicons'};
    {'folke/todo-comments.nvim',            config='todo-comments'};
    {'folke/zen-mode.nvim',                 config='zen-mode'};
    {'folke/which-key.nvim',                config='which-key'};
    {'norcalli/nvim-colorizer.lua',         config='colorizer'};
    {'neovim/nvim-lspconfig',               config='lsp'};
    {'simrat39/symbols-outline.nvim'};
    {'nvim-treesitter/nvim-treesitter',     config='treesitter', run = ':TSUpdate'};
    {'hrsh7th/nvim-compe',                  config='compe'};
    {'L3MON4D3/LuaSnip',                    config='luasnip'};
    {'rafamadriz/friendly-snippets'};
    {'windwp/nvim-autopairs',               config='autopairs'};
    {'onsails/lspkind-nvim'};
    {'kyazdani42/nvim-tree.lua',            config='tree'};
    {'folke/trouble.nvim',                  config='trouble'};
    {'tpope/vim-fugitive'};
    {'lewis6991/gitsigns.nvim',             config='gitsigns'};
    {'nvim-telescope/telescope.nvim',       config='telescope'};
      {'nvim-lua/popup.nvim'};
      {'nvim-lua/plenary.nvim'};
      {'nvim-telescope/telescope-fzy-native.nvim', 
        hook='git submodule update --init --recursive'};
})

--[[
'sindrets/diffview.nvim';
'kdheepak/lazygit.nvim';
'TimUntersberger/neogit';
'tpope/vim-fugitive';
'rhysd/git-messenger.vim';
'sodapopcan/vim-twiggy';
'junegunn/gv.vim';

'JoosepAlviste/nvim-ts-context-commentstring'
'mbbill/undotree'                  " visual undo tree
'ludovicchabant/vim-gutentags'     " automatic tags files
'AndrewRadev/bufferize.vim'        " gets cmd result into buffer
--]]

