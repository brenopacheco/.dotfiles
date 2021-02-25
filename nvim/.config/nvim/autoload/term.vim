" File: term.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 24, 2021
" Description: 

function term#open()
    let bufnr = index(map(range(1, bufnr('$')),
        \ {_,s -> getbufvar(s, '&ft')}), 'term') + 1
    if index(tabpagebuflist(), bufnr) != -1
        silent exe bufwinnr(bufnr) . 'close'
    endif
    belowright 13sp | exec bufnr > 0 ? bufnr . 'b' : 'term'
endfunction

