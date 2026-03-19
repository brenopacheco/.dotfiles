set clipboard=unnamedplus
set hidden
set wildmenu
set wildmode=longest:full,full
set listchars=tab:»\ ,trail:¬,lead:·,nbsp:␣,extends:›,precedes:‹
set list
set path=.,,**
set incsearch
set smartcase
set ignorecase
set scrolloff=10
set number
set relativenumber

filetype plugin indent on
syntax on

let mapleader = ","

inoremap jk <esc>l
inoremap kj <esc>l
cnoremap jk <esc>
cnoremap kj <esc>


set wildcharm=<C-z>

" Completion menu navigation (insert mode)
inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <Left>  pumvisible() ? "\<C-e>" : "\<Left>"
inoremap <expr> <Right> pumvisible() ? "\<C-y>" : "\<Right>"

" Cmdline completion navigation
cnoremap <expr> <Down>  wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <Up>    wildmenumode() ? "\<C-p>" : "\<Up>"
cnoremap <expr> <Left>  wildmenumode() ? "\<C-e>" : "\<Left>"
cnoremap <expr> <Right> wildmenumode() ? "\<C-y>" : "\<C-z>"

