" File: plugin/qf.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 23, 2021
" Description: 

if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

set nobuflisted

augroup quickfix_close
  au!
  au WinEnter * if winnr('$') == 1
      \ && &buftype == "quickfix" | q |endif
augroup END
