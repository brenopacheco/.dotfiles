--[[
██╗███╗   ██╗██╗████████╗   ██╗     ██╗   ██╗ █████╗
██║████╗  ██║██║╚══██╔══╝   ██║     ██║   ██║██╔══██╗
██║██╔██╗ ██║██║   ██║      ██║     ██║   ██║███████║
██║██║╚██╗██║██║   ██║      ██║     ██║   ██║██╔══██║
██║██║ ╚████║██║   ██║   ██╗███████╗╚██████╔╝██║  ██║
╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                              Breno Leonhardt Pacheco
                             brenoleonhardt@gmail.com

[x] statusline
[x] lsp
[x] completion
[ ] telescope
[ ] surround, etc
[ ] bindings      // quinta
[ ] completion/snippets adjustements
[ ] plugin manager

https://github.com/rockerBOO/awesome-neovim
--]]

require("paq")({
    {'dstein64/vim-startuptime'};
    {'andymass/vim-matchup'};
    {'tpope/vim-surround'};
    {'junegunn/vim-easy-align'};
    {'bluz71/vim-nightfly-guicolors'};


    {'tpope/vim-fugitive'};


    {'neovim/nvim-lspconfig'};
    {'simrat39/symbols-outline.nvim'}; -- vista replacement
    {'kosayoda/nvim-lightbulb'};       -- show lightbulb on code action
    {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'};

    {'hoob3rt/lualine.nvim'};

    {'hrsh7th/nvim-compe'};
    {'rafamadriz/friendly-snippets'};
    {'windwp/nvim-autopairs'};
    {'L3MON4D3/LuaSnip'};
    {'onsails/lspkind-nvim'};

    {'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/popup.nvim'},
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzy-native.nvim'}
        }
    };

})

local _modules = {
  'lsp',
  'treesitter',
  'completion',
  'defaults',
  'mappings',
  'plugins/lualine',
  'plugins/telescope'
}

for _,module in pairs(_modules) do require(module) end

vim.cmd([[
    set termguicolors
    colorscheme nightfly
]])

    -- " TELESCOPE
    -- " Plug 'camspiers/snap'
    -- " Plug 'nvim-telescope/telescope.nvim'
    -- " Plug 'folke/trouble.nvim'

    -- " COLORSCHEME

    -- " TREE
    -- " Plug 'kyazdani42/nvim-tree.lua'

    -- " UI
    -- " Plug 'lukas-reineke/indent-blankline.nvim'
    -- " Plug 'kyazdani42/nvim-web-devicons'
    -- " Plug 'folke/todo-comments.nvim'
    -- " Plug 'akinsho/nvim-bufferline.lua'
    -- " Plug 'folke/zen-mode.nvim'
    -- " Plug 'folke/which-key.nvim'
    -- " Plug 'edluffy/specs.nvim'
    -- " norcalli/nvim-colorizer.lua

    -- " GIT
    -- " Plug 'sindrets/diffview.nvim'
    -- " Plug 'lewis6991/gitsigns.nvim'
    -- " Plug 'kdheepak/lazygit.nvim'
    -- " Plug 'TimUntersberger/neogit'
    -- " Plug 'tpope/vim-fugitive'

    -- " ACTIONS
    -- " Plug 'b3nj5m1n/kommentary'
    -- " Plug 'JoosepAlviste/nvim-ts-context-commentstring'

    -- " MOVEMENT

