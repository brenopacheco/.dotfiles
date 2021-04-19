" File: after/plugin/defaults.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 23, 2021
" Description: default vim configurations

if exists('g:loaded_defaults_plugin')
    finish
endif
let g:loaded_defaults_plugin = 1

set encoding=utf-8                        " ...
scriptencoding utf-8                      " ...
filetype plugin indent on                 " ...
set noexrc
set secure                                " ...
" set jumpoptions+=stack
let mapleader     =' '                    " set leader as comma
let &shellcmdflag ='-O globstar -c'       " enables gr **/* w/ grepprg
set autochdir                             " use file path as vim's dir
set autoindent                            " new lines inherits indentation
set clipboard     =unnamed,unnamedplus    " copy/pasting from x11 clipboard
set cmdheight     =1                      " ...
set colorcolumn   =78                     " draw column at position
set conceallevel  =0                      " shows |hyperlinks|
set cursorline                            " highlights current line
set expandtab                             " expands tabs as spaces
set fileencoding  =utf-8                  " ...
set fillchars     =fold:\                 " make v:folddashes whitespace
set foldlevel     =99                     " make folds open initially
set foldmethod    =marker                 " default fold method using {{{}}}
set foldtext      =utils#foldtext()       " ...
set formatoptions =j,n,q                  " defaults for formatting text
set hidden                                " hide files don't prompt for save
set history       =500                    " keep more history in q:
set hlsearch                              " keep search highlighted
set ignorecase                            " ignore case when searching
set incsearch                             " search as chars are entered
set keywordprg    =:help                  " use help as default for <S-k>
set laststatus    =2                      " always show statusline
set lazyredraw                            " do not redraw during macros
set linebreak                             " don't break word when wrapping
set list                                  " actually use listchars
set listchars    +=extends:›,precedes:‹   " symbol for longlines on nowrap
set listchars     =tab:»\ ,trail:¬,nbsp:␣ " show symbols for tab/trail/nbsp
set more                                  " show --more-- to scroll messages
set nojoinspaces                          " always insert 1 spc on join J
set noshowmode                            " don't show --INSERT-- message
set nosmartindent                         " ??? this fixes issue with > #
set nospell                               " ...
set nosplitbelow                          " :sp creates top split
set nostartofline                         " ...
set notimeout                             " ...
set ttimeout                              " ...
set ttimeoutlen   =10                     " ...
set nowrap                                " don't wrap lines
set nowrapscan                            " search next stops at end of file
set number                                " set numeration of lines
set pumheight     =12                     " max num of items in popup menu
set pumwidth      =15                     " min popup menu width
set relativenumber                        " set relative numbers
set report=0                              " always report on :substitute
set scrolloff     =999                    " keep cursor centered
set shiftwidth    =4                      " number of spaces used by = op.
set shortmess    +=cs                     " remove annoying messages
set showbreak     =↪\                     " symbol for wrapped lines
set showcmd                               " show commands being used
set showmatch                             " highlights matches [{()}]
set signcolumn    =auto                   " show signcolumns when available
set smartcase                             " smart case for search
set suffixesadd   =                       " ...
set splitright                            " :vsp creates right split
set tabstop       =4                      " display tab as 4 spaces
set tags          =tags;~                 " search tags file up to $HOME
set textwidth     =78                     " norm gq width. see formatoptions
set undolevels     =500                   " keep more undos
set updatetime    =5000                   " time for writting swap to disk
set virtualedit   =block,onemore          " put cursor where there is no char
set visualbell                            " ...
set wildignore   +=.git/**,tags           " ignore pattern using vimgrep
set wildignore   +=node_modules/**        " ignore pattern using vimgrep
set wildmenu                              " tab help in cmdline
set wildmode      =full                   " how wildmenu appears
syntax on                                 " ...
set grepformat    =%f:%l:%c:%m            " format for grep in quickfix
let &grepprg='rg --hidden --smart-case
  \ --color=never --no-heading --column
  \ --with-filename --line-number  -e $*'
let g:vim_indent_cont = &sw               " \ indents shiftwidth
let c_syntax_for_h = 1                    " recognize .h as c file
set path=**
