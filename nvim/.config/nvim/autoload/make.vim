" File: autoload/make.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 23, 2021
" Description: 

let s:settings = {
    \ 'lua':        { },
    \ 'sh':         { },
    \ 'python':     { },
    \ 'javascript': { },
    \ 'typescript': { },
    \ 'c':          { }
    \ }

let s:settings = {
    \ 'mvn': {},
    \ 'make': {},
    \ 'npm': {},
    \ }

fun! make#run()
endf

fun! make#lint()
endf

fun! make#make()
endf


