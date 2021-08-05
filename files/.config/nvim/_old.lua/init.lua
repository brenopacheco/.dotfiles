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
    {'tweekmonster/startuptime.vim'};
    {'editorconfig/editorconfig-vim'}; -- ok?
    {'junegunn/vim-easy-align'}; -- ok, needs maps
    {'andymass/vim-matchup'}; -- ok
    {'tpope/vim-surround'}; -- ok
    {'junegunn/vim-easy-align'}; -- ok
    {'b3nj5m1n/kommentary'}; -- change it to tpope's?

    {'hoob3rt/lualine.nvim'}; -- ok
    {'bluz71/vim-nightfly-guicolors'}; -- ok
    {'lukas-reineke/indent-blankline.nvim'}; --ok
    {'kyazdani42/nvim-web-devicons'}; -- do i need it?
    {'folke/todo-comments.nvim'}; -- ok. add snippets
    {'folke/zen-mode.nvim'}; -- ok. needs mappings ZenMode
    {'folke/which-key.nvim'}; -- ok, needs configuration
    {'norcalli/nvim-colorizer.lua'}; -- ok

    {'neovim/nvim-lspconfig'};                               --ok
    {'simrat39/symbols-outline.nvim'}; -- vista replacement, needs keybindings  --ok
    {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'};  --ok
    {'hrsh7th/nvim-compe'}; -- ok
    {'rafamadriz/friendly-snippets'}; -- ok
    {'windwp/nvim-autopairs'};-- ok
    {'L3MON4D3/LuaSnip'};-- ok
    {'onsails/lspkind-nvim'};-- ok

    {'nvim-telescope/telescope.nvim'}; -- TODO
      {'nvim-lua/popup.nvim'};
      {'nvim-lua/plenary.nvim'};
      {'nvim-telescope/telescope-fzy-native.nvim', hook='git submodule update --init --recursive'};


    {'kyazdani42/nvim-tree.lua'}; -- TODO
    {'folke/trouble.nvim'}; -- cool. gotta study more

    -- TODO: IT
    {'tpope/vim-fugitive'}; -- ok
    -- 'sindrets/diffview.nvim';
    -- 'lewis6991/gitsigns.nvim';
    -- 'kdheepak/lazygit.nvim';
    -- 'TimUntersberger/neogit';
    -- 'tpope/vim-fugitive';
    -- 'rhysd/git-messenger.vim';
    -- 'sodapopcan/vim-twiggy';
    -- 'junegunn/gv.vim';
})

--[[
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
 ]]

--[[
    'JoosepAlviste/nvim-ts-context-commentstring'
    'mbbill/undotree'                  " visual undo tree
    'ludovicchabant/vim-gutentags'     " automatic tags files
    'AndrewRadev/bufferize.vim'        " gets cmd result into buffer
 ]]
