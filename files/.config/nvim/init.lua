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
    {'dstein64/vim-startuptime'}; -- ok
    {'andymass/vim-matchup'}; -- ok
    {'tpope/vim-surround'}; -- ok
    {'junegunn/vim-easy-align'}; -- ok
    {'bluz71/vim-nightfly-guicolors'}; -- ok
    {'lukas-reineke/indent-blankline.nvim'}; --ok
    {'kyazdani42/nvim-web-devicons'}; -- do i need it?
    {'b3nj5m1n/kommentary'}; -- change it?

    {'tpope/vim-fugitive'}; -- ok


    {'neovim/nvim-lspconfig'};                               --ok
    {'simrat39/symbols-outline.nvim'}; -- vista replacement  --ok
    {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'};  --ok

    {'hoob3rt/lualine.nvim'}; -- ok

    {'hrsh7th/nvim-compe'}; -- ok
    {'rafamadriz/friendly-snippets'}; -- ok
    {'windwp/nvim-autopairs'};-- ok
    {'L3MON4D3/LuaSnip'};-- ok
    {'onsails/lspkind-nvim'};-- ok

    {'nvim-telescope/telescope.nvim'}; -- ok
      {'nvim-lua/popup.nvim'};
      {'nvim-lua/plenary.nvim'};
      {'nvim-telescope/telescope-fzy-native.nvim', hook='git submodule update --init --recursive'};

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

require'nvim-web-devicons'.setup{}
require("indent_blankline").setup {
  char = "|";
  buftype_exclude = {"terminal"};
  filetype_exclude = {'help'};
  use_treesitter = true;
  show_current_context = true;
}


    -- " Plug 'folke/trouble.nvim'

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
    -- " Plug 'JoosepAlviste/nvim-ts-context-commentstring'

    -- " MOVEMENT
