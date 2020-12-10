" Programs, Directories & Backup {{{

let g:backupdir    = expand('~/.cache/nvim/backup/')
let g:plugdir      = expand('~/.cache/nvim/plug/')
let g:undodir      = expand('~/.cache/nvim/undo/')
let g:swapdir      = expand('~/.cache/nvim/swap//')

" call map([g:backupdir, g:plugdir, g:swapdir, g:undodir],
"             \ { _,dir -> !isdirectory(dir) ? system('mkdir -p ' . dir) : 0 })

for dir in [ g:backupdir, g:plugdir, g:swapdir, g:undodir ]
    if !isdirectory(dir)
        silent call system('mkdir -p ' . dir)
    endif
endfor

au BufWritePost * call Backup()
function! Backup()
    let b:timestamp = strftime('%Y-%m-%d_%Hh%Mm')
    let b:expanded = expand('%:p')
    let b:subst = substitute(b:expanded, "/", "\\\\%", "g")
    let b:dir = g:backupdir
    let b:backupfile = b:dir . b:timestamp . "_" . b:subst
    silent exec ':w! ' b:backupfile
endfunction

let fd_ignore = expand('~/.fdignore')
let rg_ignore = expand('~/.rgignore')
if !filereadable(fd_ignore) || !filereadable(rg_ignore)
    silent call writefile(['**/.git/', '**/node_modules/', 'tags'], fd_ignore)
    silent call system('cp ' . fd_ignore . ' ' . rg_ignore)
endif

function! Foldtext()
  let line = substitute(getline(v:foldstart), '{', ' ', 'g')
  let line = "# " . substitute(line, '^[ "]\+', '', '')
  let lines = v:foldend-v:foldstart
  let length = 71 - strwidth(line) - len(lines)
  return  line . repeat(' ', length) . lines . ' #lines'
endfunction


" }}}
" Global configurations {{{

set secure
set shell+=\ -O\ globstar                 " enables gr **/* w/ grepprg
let mapleader     =" "                    " set leader as comma
set clipboard     =unnamed,unnamedplus    " copy/pasting from x11 clipboard
set colorcolumn   =78                     " draw column at position
set completeopt   =menuone,noinsert       " defaults popup menu behavior
set conceallevel  =0                      " shows |hyperlinks|
set swapfile                              " enable swap file
let &directory    = g:swapdir             " swap directory
set encoding      =utf-8                  " use encoding supporting unicode
set fileencoding  =utf-8
set fillchars     =fold:\                 " make v:folddashes whitespace
set foldlevel     =99                     " make folds open initially
set foldmethod    =marker                 " default fold method using {{{}}}
set foldtext      =Foldtext()
set grepformat    =%f:%l:%c:%m            " format for grep in quickfix
let &grepprg="rg --hidden --smart-case 
  \ --color=never --no-heading --with-filename
  \ --line-number --column $*"
set laststatus    =2                      " always show statusline
set listchars    +=extends:›,precedes:‹   " symbol for longlines on nowrap
set listchars     =tab:»\ ,trail:¬,nbsp:␣ " show symbols for tab/trail/nbsp
set pumheight     =12                     " max num of items in popup menu
set pumwidth      =15                     " min popup menu width
set scrolloff     =999                    " keep cursor centered
set shiftwidth    =4                      " number of spaces used by = op.
set shortmess    +=cs                     " remove annoying messages
set showbreak     =↪\                     " symbol for wrapped lines
set signcolumn    =auto                   " show signcolumns when available
set tabstop       =4                      " display tab as 4 spaces
set tags          =tags;~                 " search tags file up to $HOME
set updatetime    =5000                   " time for writting swap to disk
set wildignore   +=.git/**,tags           " ignore pattern using vimgrep
set wildignore   +=node_modules/**        " ignore pattern using vimgrep
set wildmode      =full                   " how wildmenu appears
set textwidth     =78                     " norm gq width. see formatoptions
set autochdir                              " use file path as vim's dir
set autoindent                             " new lines inherits indentation
set smartindent                           " insert indent after {, }, etc
set cursorline                             " highlights current line
set hidden                                 " hide files don't prompt for save
set hlsearch                               " keep search highlighted
set ignorecase                             " ignore case when searching
set incsearch                              " search as chars are entered
set lazyredraw                             " do not redraw during macros
set linebreak                              " don't break word when wrapping
set list                                   " actually use listchars
set more                                   " show --more-- to scroll messages
set nobackup                               " no backup for current file
set expandtab                              " expands tabs as spaces
set noshowmode                             " don't show --INSERT-- message
set nosplitbelow                           " :sp creates top split
set nowrap                                 " don't wrap lines
set nowrapscan                             " search next stops at end of file
set nowritebackup                          " no backup for current session
set number                                 " set numeration of lines
set relativenumber                         " set relative numbers
set showcmd                                " show commands being used
set showmatch                              " highlights matches [{()}]
set smartcase                              " smart case for search
set splitright                             " :vsp creates right split
set wildmenu                               " tab help in cmdline
set keywordprg=:help                       " use help as default for <S-k>
set report=0                               " always report on :substitute
set undolevels     =500                    " keep more undos
set history        =500                    " keep more history in q:
set virtualedit    =block,onemore          " put cursor where there is no char
set formatoptions  =c,j,n,o,q,r            " defaults for formatting text
set nojoinspaces                           " always insert 1 spc on join J
set nostartofline
set visualbell
set cmdheight=1
set notimeout ttimeout ttimeoutlen=10
set nocompatible
filetype plugin indent on
syntax on

set iskeyword    +=-                      " accept key-word for <cword>

set spellfile=~/.config/nvim/spell/custom.utf-8.add
set spelllang=custom
set spell

" }}}
" TODO {{{
" modelines...
" amenu, emenu, menu ...
" set breakindent
" set breakat
" set breakindentopt
" }}}
