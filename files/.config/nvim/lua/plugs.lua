local paq = require('paq')

paq({
    {'tweekmonster/startuptime.vim'};
    {'editorconfig/editorconfig-vim'};
    -- {'andymass/vim-matchup'};
    {'tpope/vim-surround'};
    {'junegunn/vim-easy-align'}; -- mappings
    {'tpope/vim-commentary'};
    {'suy/vim-context-commentstring'};
    {'bluz71/vim-nightfly-guicolors'};
    {'hoob3rt/lualine.nvim',                config='lualine'};
    {'lukas-reineke/indent-blankline.nvim', config='blankline'};
    {'kyazdani42/nvim-web-devicons',        config='devicons'};
    {'folke/todo-comments.nvim',            config='todo-comments'}; -- snippets
    {'folke/zen-mode.nvim',                 config='zen-mode'}; -- mappings
    {'folke/which-key.nvim',                config='which-key'};
    {'norcalli/nvim-colorizer.lua',         config='colorizer'};
    {'neovim/nvim-lspconfig',               config='lsp'}; -- mappings
    {'creativenull/diagnosticls-nvim'};
    {'simrat39/symbols-outline.nvim'}; -- mappings
    {'nvim-treesitter/nvim-treesitter',     config='treesitter', run = ':TSUpdate'};
    {'hrsh7th/nvim-compe',                  config='compe'}; -- mappings
    {'L3MON4D3/LuaSnip',                    config='luasnip'}; -- mappings
    {'rafamadriz/friendly-snippets'};
    {'windwp/nvim-autopairs',               config='autopairs'};
    {'onsails/lspkind-nvim'};
    {'ray-x/lsp_signature.nvim',            config='signature'};
    {'kyazdani42/nvim-tree.lua',            config='tree'};
    {'folke/trouble.nvim',                  config='trouble'}; -- mappings
    {'tpope/vim-fugitive'};
    {'lewis6991/gitsigns.nvim',             config='gitsigns'}; -- mappings
    {'nvim-telescope/telescope.nvim',       config='telescope'}; -- mappings
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

local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end
