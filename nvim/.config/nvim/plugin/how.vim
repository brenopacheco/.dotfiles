" File: how.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 28, 2021
" Description:

if exists('g:loaded_how_plugin')
    finish
endif
let g:loaded_how_plugin = 1

command! -nargs=0 -range How call how#cheat()

nnoremap ? <cmd>How<CR>
xnoremap ? <cmd>How<CR>

" <cmd> executes cmd without changing modes

