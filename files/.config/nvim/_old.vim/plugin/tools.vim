" File: tools.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 23, 2021
" Description:

if exists('g:loaded_tools_plugin')
    finish
endif
let g:loaded_tools_plugin = 1

command! Vimrc          so ~/.config/nvim/init.vim
command! Trim           call s:trim()
command! TabReplace     %s/\t/    /g
command! SpaceReplace   %s/    /\t/g
command! Fork           silent call system('st 1>/dev/null 2>&1 & disown')

fun! s:trim()
    let l:winview = winsaveview()
    %s/\s\+$//
    call winrestview(l:winview)
endf


" augroup TrimWhitespace
"     autocmd BufWritePre * call s:trim()
" augroup end
