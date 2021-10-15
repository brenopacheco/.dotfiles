local paq = require('paq')

paq({
    {'tweekmonster/startuptime.vim'};
    {'editorconfig/editorconfig-vim'};
    {'mbbill/undotree'};
    {'tpope/vim-surround'};
    {'junegunn/vim-easy-align',             config='easyalign'};
    {'ludovicchabant/vim-gutentags',        config='gutentags'};
    {'tpope/vim-commentary'};
    {'JoosepAlviste/nvim-ts-context-commentstring', config='commentstring'};
    {'bluz71/vim-nightfly-guicolors'};
    {'shadmansaleh/lualine.nvim',                config='lualine'};
      { 'SmiteshP/nvim-gps',                  config='nvim-gps' };
    {'lukas-reineke/indent-blankline.nvim', config='blankline'};
    {'kyazdani42/nvim-web-devicons',        config='devicons'};
    {'folke/todo-comments.nvim',            config='todo-comments'};
    {'folke/which-key.nvim',                config='which-key'};
    {'norcalli/nvim-colorizer.lua',         config='colorizer'};
    {'neovim/nvim-lspconfig',               config='lsp'};
    {'creativenull/diagnosticls-nvim'};
    {'simrat39/symbols-outline.nvim'};
    {'nvim-treesitter/nvim-treesitter',     config='treesitter', run = ':TSUpdate'};
    {'hrsh7th/nvim-compe',                  config='compe'};
    {'hrsh7th/vim-vsnip',                   config='vsnip'};
    {'hrsh7th/vim-vsnip-integ'};
    {'windwp/nvim-autopairs',               config='autopairs'};
    {'onsails/lspkind-nvim'};
    -- {'kyazdani42/nvim-tree.lua',            config='tree'};
    {'folke/trouble.nvim',                  config='trouble'};
    {'tpope/vim-fugitive'};
    {'lewis6991/gitsigns.nvim',             config='gitsigns'};
    {'folke/zen-mode.nvim',                 config='zen-mode'};
    {'f-person/git-blame.nvim',             config='git-blame'};
    {'sodapopcan/vim-twiggy'};
    {'junegunn/gv.vim'};
    {'nvim-telescope/telescope.nvim',       config='telescope'};
      {'nvim-lua/popup.nvim'};
      {'nvim-lua/plenary.nvim'};
      {'nvim-telescope/telescope-fzy-native.nvim',
        hook='git submodule update --init --recursive'};
    {'sbdchd/neoformat',                    config='neoformat'};
    {'brenopacheco/vim-tree',               config='vim-tree'};
    -- {'tami5/lspsaga.nvim',                config='lsp-saga'};--incompatible
    {'NTBBloodbath/rest.nvim'};
    {'ruifm/gitlinker.nvim', config='git-linker'};
    {'romgrk/nvim-treesitter-context', config='nvim-treesitter-context'};
    -- {'ray-x/lsp_signature.nvim',            config='signature'};
    {'ishan9299/nvim-solarized-lua'}
    --[[ todo
    {'mhartington/formatter.nvim'};
    {'vim-test/vim-test'};
    {'Pocco81/DAPInstall.nvim', config='dap-install'};
    {'mfussenegger/nvim-dap'};
    {'rcarriga/nvim-dap-ui', config='nvim-dap-ui'};
    {'theHamsta/nvim-dap-virtual-text'};
    --]]
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
