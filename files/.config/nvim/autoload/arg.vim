" File: arg.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 26, 2021
" Description:

" note: instead of using the arglist to perform operations,
" fill the quickfix list w/ entries and apply cfdo ?
" the arglist may be used for source file navigation,
" but then there is PFiles and Classes...
fun! arg#add() abort
    let files = utils#files(input('argadd /', '', 'file'), utils#git_root())
    exec 'arg ' . join(files, " ")
endf

fun! arg#grep() abort
    let input = input('vimgrep/', '', 'file')
    exec "vimgrep/'" . input  "/j #"
endf

" fills qf w/ args
fun! arg#list() abort

endf

fun! arg#clear() abort
endf
