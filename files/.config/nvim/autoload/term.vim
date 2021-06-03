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
    " let bufnr = index(map(range(1, bufnr('$')),
    "     \ {_,s -> getbufvar(s, '&ft')}), 'term') + 1
    echomsg s:term_buffer
    if index(tabpagebuflist(), s:term_buffer) != -1
        silent exe bufwinnr(s:term_buffer) . 'close'
    endif
    belowright vsp | exec s:term_buffer > 0 ? 
        \ s:term_buffer . 'b' : 'term ' . (a:0 ? a:1 : '')
    let s:term_buffer = bufnr()
    echomsg s:term_buffer
endfunction


""
" opens a terminal. spawns a new, buflisted terminal different from the
" single terminal used in term#open
" [optional] cmd
fun! term#spawn(...)
    belowright vsp | exec 'term ' . (a:0 ? a:1 : '')
    set buflisted
endf
