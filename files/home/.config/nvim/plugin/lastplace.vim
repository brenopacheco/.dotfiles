if exists('g:loaded_lastplace_plugin')
    finish
endif
let g:loaded_lastplace_plugin = 1

autocmd! BufReadPost * call s:lastplace()

function s:lastplace()
    if line("'\"") > 0 && line("'\"") <= line("$") 
        exe "normal! g`\"" 
    endif
endfunction
