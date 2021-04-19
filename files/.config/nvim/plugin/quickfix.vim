" File: quickfix.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description: Allows mapping n_q<letter> and still record macros normally.
" Bootstraps q<letter> so that q<letter> can be mapped, while pressing q in 
" will still stop the macro recording. otherwise, the macro cannot be stopped

if exists('g:loaded_quickfix_plugin')
    finish
endif
let g:loaded_quickfix_plugin = 1

nmap <F10> <Nop>

function s:record() abort
    nmap <silent><nowait> q q<F10>:unmap q<CR>
endfunction

call map(map(range(97, 122), 'nr2char(v:val)'), 
    \ { _,i -> execute('nnoremap q'.i.' :call <SID>record()<CR>q'.i)})

