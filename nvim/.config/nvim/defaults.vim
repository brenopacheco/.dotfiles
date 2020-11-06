" Configure some default directories
let g:backupdir    = expand('~/.cache/nvim/backup/')
let g:plugdir      = expand('~/.cache/nvim/plug/')
let g:undodir      = expand('~/.cache/nvim/undo/')
let g:swapdir      = expand('~/.cache/nvim/swap//')

for dir in [ g:backupdir, g:plugdir, g:swapdir, g:undodir ]
    if !isdirectory(dir)
        silent call system('mkdir -p ' . dir)
    endif
endfor

let mapleader     =" "                    " set leader as comma
set clipboard     =unnamed,unnamedplus    " copy/pasting from x11 clipboard
set colorcolumn   =78                     " draw column at position
set completeopt   =menuone,noinsert       " defaults popup menu behavior
set conceallevel  =0                      " shows |hyperlinks|
set swapfile                              " enable swap file
let &directory    = g:swapdir             " swap directory
set encoding      =utf-8                  " use encoding supporting unicode
set fillchars     =fold:\                 " make v:folddashes whitespace
set foldlevel     =99                     " make folds open initially
set foldmethod    =marker                 " default fold method using {{{}}}
set grepformat    =%f:%l:%c:%m,%f:%l:%m   " format for grep in quickfix
set grepprg       =internal               " defaults :gr[ep] to :vimgrep
set iskeyword    +=-,:,=                  " accept key-word for <cword>
set laststatus    =2                      " always show statusline
set listchars    +=extends:›,precedes:‹   " symbol for longlines on nowrap
set listchars     =tab:»\ ,trail:¬,nbsp:␣ " show symbols for tab/trail/nbsp
set pumheight     =12                     " max num of items in popup menu
set pumwidth      =15                     " max popup menu width
set scrolloff     =999                    " keep cursor centered
set shiftwidth    =4                      " number of spaces for the tab 
set shortmess    +=cs                     " remove annoying messages 
set showbreak     =↪\                     " symbol for wrapped lines
set signcolumn    =auto                   " show signcolumns when available
set spelllang     =en_us                  " spellcheck uses english dict
set tabstop       =4                      " display tab as 4 spaces
set tags          =tags;~                 " search tags file up to $HOME
set updatetime    =5000                   " time for writting swap to disk
set wildignore   +=.git/**,tags           " ignore pattern using grep
set wildignore   +=node_modules/**        " ignore pattern using grep
set wildmode      =full                   " how wildmenu appears
set textwidth     =78                     " norm gq width. see formatoptions
set autochdir                              " use file path as vim's dir
set autoindent                             " new lines inherits indentation
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
set noexpandtab                            " do not replace tabs with spaces
set noexpandtab                            " expands tabs as spaces
set noshowmode                             " don't show --INSERT-- message
set nospell                                " block spell check
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
au BufWritePost * call Backup()            " backs up file in .backups

" new uncat options // TODO
set undolevels     =500 
set history        =500
set virtualedit    =block,onemore
set formatoptions +=j
set nojoinspaces
set breakindent
set nostartofline
set visualbell
set cmdheight=1
set notimeout ttimeout ttimeoutlen=10
set nocompatible


" set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
" set grepformat=%f:%l:%c:%m,%f:%l:%m
"
