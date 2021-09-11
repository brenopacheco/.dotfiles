" File: term.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 24, 2021
" Description:

let s:term_buffer = -1

""
" open terminal. uses a single terminal buffer
" [optional] command
function term#open(...)
    if index(tabpagebuflist(), s:term_buffer) != -1
        exec bufwinnr(s:term_buffer) . 'close'
        return
    endif
    belowright vsp | exec (s:term_buffer > 0 && bufexists(s:term_buffer))  ? 
        \ s:term_buffer . 'b' : 'term ' . (a:0 ? a:1 : '')
    let s:term_buffer = bufnr()
endfunction


""
" opens a terminal. spawns a new, buflisted terminal different from the
" single terminal used in term#open
" [optional] cmd
fun! term#spawn(...)
    belowright vsp | exec 'term ' . (a:0 ? a:1 : '')
    set buflisted
endf
