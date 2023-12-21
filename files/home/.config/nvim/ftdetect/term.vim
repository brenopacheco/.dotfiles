fun! s:setup_term()
    set nobuflisted
    tnoremap <buffer> <Esc> <C-\><C-n>
    tnoremap <buffer> <C-[> <C-\><c-n>
    tnoremap <buffer> jk <C-\><C-n>
    tnoremap <buffer> kj <C-\><C-n>
    let b:term = v:true
endf

au TermOpen * call s:setup_term()
