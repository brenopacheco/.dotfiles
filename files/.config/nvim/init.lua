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

-- jump to last line when opening file
vim.cmd([[
" augroup last_place
"   au!
"   au! BufReadPost * norm `"
" augroup end
]])


require("paq")({
    {'dstein64/vim-startuptime'}; -- ok
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
    " hi Whitespace ctermfg=81 guifg=#82aaff guibg=bg
]])

require'nvim-web-devicons'.setup{}
require'colorizer'.setup()
require("todo-comments").setup{}
require("trouble").setup {}
require("indent_blankline").setup {
  char = "|";
  buftype_exclude = {"terminal"};
  filetype_exclude = {'help'};
  use_treesitter = true;
  show_current_context = true;
}



vim.cmd([[
    xmap     ga          :EasyAlign<cr>
    nmap     ga          :EasyAlign<cr>
    nnoremap <TAB> :tabn<CR>
    nnoremap <S-TAB> :tabp<CR>
]])


require("which-key").setup {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB"
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  window = {
    -- border = "none", -- none, single, double, shadow
    border = "single", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  }
}





    -- " ACTIONS
    -- " Plug 'JoosepAlviste/nvim-ts-context-commentstring'

--[[     
    " Plug 'mbbill/undotree'                  " visual undo tree
    " Plug 'ludovicchabant/vim-gutentags'     " automatic tags files
    " 'AndrewRadev/bufferize.vim'        " gets cmd result into buffer
 ]]
