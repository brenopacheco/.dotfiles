local paq = require('paq')

paq({
    {'bluz71/vim-nightfly-guicolors'};
    {'editorconfig/editorconfig-vim'};

    {'kana/vim-textobj-user'};
    {'kana/vim-textobj-fold'};
    {'kana/vim-textobj-indent'};

    {'folke/which-key.nvim',                        config='which-key'};
    {'folke/zen-mode.nvim',                         config='zen-mode'};
    {'hrsh7th/nvim-compe',                          config='compe'};
    {'hrsh7th/vim-vsnip',                           config='vsnip'};
    {'hrsh7th/vim-vsnip-integ'};
    {'JoosepAlviste/nvim-ts-context-commentstring', config='commentstring'};
    {'junegunn/gv.vim'};
    {'junegunn/vim-easy-align',                     config='easyalign'};
    {'kyazdani42/nvim-web-devicons',                config='devicons'};
    {'lewis6991/gitsigns.nvim',                     config='gitsigns'};
		-- NOTE: tab characters are not shown anymore
    {'lukas-reineke/indent-blankline.nvim',         config='blankline'};
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
		{'nvim-treesitter/nvim-treesitter-context'};

		{'glepnir/lspsaga.nvim'};


    {'brenoleonhardt-poatek/neogen',                config='neogen'};

    {'onsails/lspkind-nvim',                        config='lspkind'};
    {'ruifm/gitlinker.nvim',                        config='git-linker'};
    {'sbdchd/neoformat',                            config='neoformat'};
    {'nvim-lualine/lualine.nvim',                   config='lualine'};
    {'simrat39/symbols-outline.nvim',               config='symbols-outline'};
    {'SmiteshP/nvim-gps',                           config='nvim-gps' };

    {'tpope/vim-commentary'};
    {'tpope/vim-fugitive'};
    {'tpope/vim-surround'};
    {'tweekmonster/startuptime.vim'};
    {'windwp/nvim-autopairs',                       config='autopairs'};
    {'Hoffs/omnisharp-extended-lsp.nvim'};
    {'ray-x/lsp_signature.nvim',                    config='signature'};

    {'mfussenegger/nvim-dap',                       config='nvim-dap'};
      {'rcarriga/nvim-dap-ui'};
      {'theHamsta/nvim-dap-virtual-text'};

		-- check
    {'voldikss/vim-floaterm',                       config='floaterm'};
    {'nanotee/luv-vimdocs'};
    {'b0o/schemastore.nvim'};
    {'rcarriga/nvim-notify',                        config='notify'};
    {'nvim-orgmode/orgmode',                        config='org'};
    {'brenopacheco/vim-tree',                       config='vim-tree'};

		{'kyazdani42/nvim-tree.lua',                    config='nvim-tree'};
		{'folke/twilight.nvim'};

		-- disabled for now
    {'fatih/vim-go',                                run=':GoUpdateBinaries'};
    -- {'KabbAmine/zeavim.vim',                        config='zeavim'};
    -- {'projekt0n/github-nvim-theme'};
    -- {'petertriho/nvim-scrollbar',                   config='scrollbar'};
    -- {'folke/todo-comments.nvim',                    config='todo-comments'};
    -- {'f-person/git-blame.nvim',                     config='git-blame'};
    -- {'ludovicchabant/vim-gutentags',                config='gutentags'};
    -- {'mbbill/undotree'};
    -- {'sodapopcan/vim-twiggy'};
})

local disable_builtins = true

local disabled_built_ins = {
    "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers", "gzip", "zip",
    "zipPlugin", "tar", "tarPlugin", "getscript", "getscriptPlugin", "vimball",
    "vimballPlugin", "2html_plugin", "logipat", "rrhelper", "spellfile_plugin",
    "matchit"
}

if disable_builtins then
  for _, plugin in pairs(disabled_built_ins) do
      vim.g["loaded_" .. plugin] = 1
  end
end
