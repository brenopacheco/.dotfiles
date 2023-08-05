local paq = require('paq')

paq({
    {'numToStr/Comment.nvim',                         config='comment'};
    {'tpope/vim-fugitive',                            config='fugitive'};
    {'junegunn/gv.vim'};
    {'tpope/vim-surround'};
    {'junegunn/vim-easy-align',                       config='easyalign'};
    {'windwp/nvim-autopairs',                         config='autopairs'};
    {'lewis6991/gitsigns.nvim',                       config='gitsigns'};
    {'bluz71/vim-nightfly-guicolors'};
    -- {'lukas-reineke/indent-blankline.nvim',           config='blankline'};
    {'kyazdani42/nvim-web-devicons',                  config='devicons'};
		{'kyazdani42/nvim-tree.lua',                      config='nvim-tree'};
    {'norcalli/nvim-colorizer.lua',                   config='colorizer'};
    {'folke/which-key.nvim',                          config='which-key'};
    -- {'folke/todo-comments.nvim',                      config='todo-comments'};

    {'sbdchd/neoformat',                              config='neoformat'};
    {'voldikss/vim-floaterm',                         config='floaterm'};
    {'danymat/neogen',                                config='neogen'};
    {'ruifm/gitlinker.nvim',                          config='git-linker'};
    {'nvim-lua/plenary.nvim'};
      {'nvim-telescope/telescope.nvim',               config='telescope'};
      {'nvim-telescope/telescope-fzy-native.nvim',    hook='git submodule update --init --recursive'};

    {'folke/zen-mode.nvim'};
		  {'folke/twilight.nvim'};

    {'nvim-treesitter/nvim-treesitter',               config='treesitter', run = ':TSUpdate'};
      {'nvim-treesitter/nvim-treesitter-textobjects'};
		  {'nvim-treesitter/nvim-treesitter-context'};

    {'neovim/nvim-lspconfig',                         config='lsp'};
      {'onsails/lspkind-nvim',                        config='lspkind'};
      {'JoosepAlviste/nvim-ts-context-commentstring', config='commentstring'};
		  {'glepnir/lspsaga.nvim'};
      {'simrat39/symbols-outline.nvim',               config='symbols-outline'};
      {'Hoffs/omnisharp-extended-lsp.nvim'};
      {'ray-x/lsp_signature.nvim',                    config='signature'};
      {'b0o/schemastore.nvim'};

    {'hrsh7th/nvim-compe',                            config='compe'};
      {'hrsh7th/vim-vsnip',                           config='vsnip'};
      {'hrsh7th/vim-vsnip-integ'};

    {'nvim-lualine/lualine.nvim',                     config='lualine'};
      {'SmiteshP/nvim-navic'};

    {'mfussenegger/nvim-dap',                         config='nvim-dap'};
      {'rcarriga/nvim-dap-ui'};
      {'theHamsta/nvim-dap-virtual-text'};

    -- {'projekt0n/github-nvim-theme'};
    -- {'marko-cerovac/material.nvim'};
    -- {'zanglg/nova.nvim'};

    {'zbirenbaum/copilot.lua', config='copilot'};

    -- {'vim-test/vim-test', config='vim-test'};
    -- {'nvim-neotest/neotest', config='neotest'};
    -- https://github.com/michaelb/sniprun
    -- {'karb94/neoscroll.nvim', config='neoscroll'};
    {'pmizio/typescript-tools.nvim', config='typescript-tools'};
    -- {'creativenull/efmls-configs-nvim', config='efmls-configs'};

    {'mickael-menu/zk-nvim', config='zk'};
    {'stevearc/oil.nvim', config='oil'};

    {'j-hui/fidget.nvim', config='fidget'};
  -- {'simrat39/rust-tools.nvim', config='rust-tools'};
  --
  -- {'NeogitOrg/neogit', config='neogit'};
  {'shellRaining/hlchunk.nvim', config='hlchunk'};
})

local disable_builtins = true

local disabled_built_ins = {
    "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers", "gzip", "zip",
    "zipPlugin", "tar", "tarPlugin", "getscript", "getscriptPlugin", "vimball",
    "vimballPlugin", "2html_plugin", "logipat", "rrhelper", "spellfile_plugin",
    "matchit"
}

-- disable al builtins 
if disable_builtins then
    for _, plugin in pairs(disabled_built_ins) do
        vim.g["loaded_" .. plugin] = 1
    end
end
