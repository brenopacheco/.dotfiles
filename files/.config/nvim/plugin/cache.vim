" File: plugin/cache.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description: sets up some global files and directories. sets updatetime
" backup, swap and undo configurations. provide commands for toggling
" and clearing swap, undo and backup

if exists('g:loaded_cache_plugin')
    finish
endif
let g:loaded_cache_plugin = 1

command! ClearCache   call cache#clear()
command! ToggleBackup call cache#toggle_backup()

let s:tagsdir   = globals#get('tagsdir')
let s:backupdir = globals#get('backupdir')
let s:plugdir   = globals#get('plugdir')
let s:undodir   = globals#get('undodir')
let s:swapdir   = globals#get('swapdir')
let s:fdignore  = globals#get('fdignore')
let s:rgignore  = globals#get('rgignore')

set swapfile             " enable swap file
let &directory=s:swapdir " swap directory
set nobackup             " no backup for current file
set nowritebackup        " no backup for current session
set undofile             " enable undo tracking
let &undodir=s:undodir   " undo files directory
set backupskip+=*.asc,*.gpg " disable backup of sensitive files

augroup backup
    au!
    au BufWritePost <buffer> call cache#backup()
augroup END

" Create missing directories
for dir in [ s:backupdir, s:plugdir, s:swapdir, s:undodir, s:tagsdir ]
        if !isdirectory(dir)
            silent call system('mkdir -p ' . dir)
            if v:shell_error
                throw 'Cannot create ' . dir . ': ' . v:shell_error
            endif
        endif
endfor

" Create missing configuration files
if !filereadable(s:fdignore) || !filereadable(s:rgignore)
    silent call writefile(['**/.git/', '**/node_modules/', 'tags'], s:fdignore)
    silent call writefile(['**/.git/', '**/node_modules/', 'tags'], s:rgignore)
endif
