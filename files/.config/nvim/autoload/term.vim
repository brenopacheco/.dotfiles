" File: term.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 24, 2021
" Description:

""
" open terminal.
" [optional] command
function term#open(...)
    let bufnr = index(map(range(1, bufnr('$')),
        \ {_,s -> getbufvar(s, '&ft')}), 'term') + 1
    if index(tabpagebuflist(), bufnr) != -1
        silent exe bufwinnr(bufnr) . 'close'
    endif
    " belowright 13sp | exec bufnr > 0 ? bufnr . 'b' : 'term'
    belowright vsp | exec bufnr > 0 ? bufnr . 'b' : 'term ' . (a:0 ? a:1 : '')
endfunction

