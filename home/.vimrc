set clipboard=unnamedplus,unnamed
set hidden
set wildmenu
set wildmode=longest:full,full
set wildoptions=pum
set pumheight=5
set listchars=tab:»\ ,trail:¬,lead:·,nbsp:␣,extends:›,precedes:‹
set list
set path=.,,**
set incsearch
set smartcase
set ignorecase
set scrolloff=10
set number
set relativenumber
set autochdir

filetype plugin indent on
syntax on

let mapleader = ","

inoremap <C-c> <C-[>
xnoremap <C-c> <C-[>
inoremap jk <C-[>l
inoremap kj <C-[>l
cnoremap jk <C-c>
cnoremap kj <C-c>
tnoremap jk <C-\><C-n>
tnoremap kj <C-\><C-n>
xnoremap < <gv
xnoremap > >gv
nnoremap > >>
nnoremap < <<
nnoremap Y v$hy
xnoremap p pgvy
nnoremap <Esc> :nohlsearch<CR>
nnoremap <C-w>e :enew<CR>
nnoremap <C-w><C-e> :enew<CR>
nnoremap <C-w><C-t> :tabnew<CR>
nnoremap Q <Nop>
xnoremap Q <Nop>
" NOTE: <c-2> and <a-> escape sequences are not properly interpreted
