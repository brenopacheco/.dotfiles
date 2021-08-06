local paq = require('paq')

paq({
    {'tweekmonster/startuptime.vim'};
    {'editorconfig/editorconfig-vim'};
    {'mbbill/undotree'};
    {'tpope/vim-surround'};
    {'junegunn/vim-easy-align',             config='easyalign'};
    {'ludovicchabant/vim-gutentags',        config='gutentags'};
    {'tpope/vim-commentary'};
    {'suy/vim-context-commentstring'};
    {'bluz71/vim-nightfly-guicolors'};
    {'hoob3rt/lualine.nvim',                config='lualine'};
    {'lukas-reineke/indent-blankline.nvim', config='blankline'};
    {'kyazdani42/nvim-web-devicons',        config='devicons'};
    {'folke/todo-comments.nvim',            config='todo-comments'};
    {'folke/zen-mode.nvim',                 config='zen-mode'};
    {'folke/which-key.nvim',                config='which-key'};
    {'norcalli/nvim-colorizer.lua',         config='colorizer'};
    {'neovim/nvim-lspconfig',               config='lsp'};
    {'creativenull/diagnosticls-nvim'};
    {'simrat39/symbols-outline.nvim'};
    {'nvim-treesitter/nvim-treesitter',     config='treesitter', run = ':TSUpdate'};
    {'hrsh7th/nvim-compe',                  config='compe'};
    {'L3MON4D3/LuaSnip',                    config='luasnip'};
    {'rafamadriz/friendly-snippets'};
    {'windwp/nvim-autopairs',               config='autopairs'};
    {'onsails/lspkind-nvim'};
    {'ray-x/lsp_signature.nvim',            config='signature'};
    {'kyazdani42/nvim-tree.lua',            config='tree'};
    {'folke/trouble.nvim',                  config='trouble'};
    {'tpope/vim-fugitive'};
    {'lewis6991/gitsigns.nvim',             config='gitsigns'};
    {'f-person/git-blame.nvim',             config='git-blame'};
    {'sodapopcan/vim-twiggy'};
    {'junegunn/gv.vim'};
    {'nvim-telescope/telescope.nvim',       config='telescope'};
      {'nvim-lua/popup.nvim'};
      {'nvim-lua/plenary.nvim'};
      {'nvim-telescope/telescope-fzy-native.nvim',
        hook='git submodule update --init --recursive'};
    {'sbdchd/neoformat',                    config='neoformat'};
})

local disabled_built_ins = {
    "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers", "gzip", "zip",
    "zipPlugin", "tar", "tarPlugin", "getscript", "getscriptPlugin", "vimball",
    "vimballPlugin", "2html_plugin", "logipat", "rrhelper", "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end
