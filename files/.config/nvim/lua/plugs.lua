local paq = require('paq')

paq({
    {'bluz71/vim-nightfly-guicolors'};
    {'brenopacheco/vim-tree',                       config='vim-tree'};
    {'editorconfig/editorconfig-vim'};
    -- {'folke/todo-comments.nvim',                    config='todo-comments'};

    {'kana/vim-textobj-user'};
    {'kana/vim-textobj-fold'};
    {'kana/vim-textobj-indent'};

    {'folke/which-key.nvim',                        config='which-key'};
    {'folke/zen-mode.nvim',                         config='zen-mode'};
    {'f-person/git-blame.nvim',                     config='git-blame'};
    {'hrsh7th/nvim-compe',                          config='compe'};
    {'hrsh7th/vim-vsnip',                           config='vsnip'};
    {'hrsh7th/vim-vsnip-integ'};
    {'JoosepAlviste/nvim-ts-context-commentstring', config='commentstring'};
    {'junegunn/gv.vim'};
    {'junegunn/vim-easy-align',                     config='easyalign'};
    {'kyazdani42/nvim-web-devicons',                config='devicons'};
    {'lewis6991/gitsigns.nvim',                     config='gitsigns'};
    {'ludovicchabant/vim-gutentags',                config='gutentags'};
    {'lukas-reineke/indent-blankline.nvim',         config='blankline'};
    {'mbbill/undotree'};
    {'neovim/nvim-lspconfig',                       config='lsp'};
    {'norcalli/nvim-colorizer.lua',                 config='colorizer'};
    {'NTBBloodbath/rest.nvim'};
    {'nvim-lua/plenary.nvim'};

    {'nvim-lua/popup.nvim'};
    {'nvim-telescope/telescope-fzy-native.nvim',    hook='git submodule update --init --recursive'};
    {'nvim-telescope/telescope.nvim',               config='telescope'};
    {'nvim-treesitter/nvim-treesitter',             config='treesitter', run = ':TSUpdate'};
    {'nvim-treesitter/nvim-treesitter-textobjects'};
    {'nvim-treesitter/playground'};

    {'brenoleonhardt-poatek/neogen',                config='neogen'};

    {'onsails/lspkind-nvim'};
    {'ruifm/gitlinker.nvim',                        config='git-linker'};
    {'sbdchd/neoformat',                            config='neoformat'};
    {'nvim-lualine/lualine.nvim',                   config='lualine'};
    {'simrat39/symbols-outline.nvim',               config='symbols-outline'};
    {'SmiteshP/nvim-gps',                           config='nvim-gps' };

    {'sodapopcan/vim-twiggy'};
    {'tpope/vim-commentary'};
    {'tpope/vim-fugitive'};
    {'tpope/vim-surround'};
    {'tweekmonster/startuptime.vim'};
    {'windwp/nvim-autopairs',                       config='autopairs'};
    {'Hoffs/omnisharp-extended-lsp.nvim'};
    {'ray-x/lsp_signature.nvim',                    config='signature'};
    {'rcarriga/nvim-dap-ui'};
    {'theHamsta/nvim-dap-virtual-text'};
    {'mfussenegger/nvim-dap',                       config='nvim-dap'};
    {'leoluz/nvim-dap-go'};
    -- {'mfussenegger/nvim-jdtls'};
    {'KabbAmine/zeavim.vim',                        config='zeavim'};
    {'projekt0n/github-nvim-theme'};


    {'petertriho/nvim-scrollbar',                   config='scrollbar'};

    {'nvim-orgmode/orgmode',                        config='org'};

    {'voldikss/vim-floaterm',                       config='floaterm'};

    {'nanotee/luv-vimdocs'};
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
