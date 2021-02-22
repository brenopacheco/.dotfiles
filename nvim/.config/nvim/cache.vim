" File: cache.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description: sets up files and directories for backup, swap, plug and undo.
" Adds default files for ripgrep and fd

if exists('g:loaded_cache_plugin')
    finish
endif
let g:loaded_cache_plugin = 1

let g:backupdir    = expand('~/.cache/nvim/backup/')
let g:plugdir      = expand('~/.cache/nvim/plug/')
let g:undodir      = expand('~/.cache/nvim/undo/')
let g:swapdir      = expand('~/.cache/nvim/swap//')

for dir in [ g:backupdir, g:plugdir, g:swapdir, g:undodir ]
    if !isdirectory(dir)
        silent call system('mkdir -p ' . dir)
    endif
endfor


function! Backup()
    let b:timestamp = strftime('%Y-%m-%d_%Hh%Mm')
    let b:expanded = expand('%:p')
    let b:subst = substitute(b:expanded, '/', "\\\\%", 'g')
    let b:dir = g:backupdir
    let b:backupfile = b:dir . b:timestamp . '_' . b:subst
    silent exec ':w! ' b:backupfile
endfunction

let fd_ignore = expand('~/.fdignore')
let rg_ignore = expand('~/.rgignore')
if !filereadable(fd_ignore) || !filereadable(rg_ignore)
    silent call writefile(['**/.git/', '**/node_modules/', 'tags'], fd_ignore)
    silent call system('cp ' . fd_ignore . ' ' . rg_ignore)
endif

augroup backup
    au!
    au BufWritePost * call Backup()
augroup END
