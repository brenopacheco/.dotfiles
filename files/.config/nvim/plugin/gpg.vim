if exists('g:loaded_gpg_plugin')
    finish
endif
let g:loaded_gpg_plugin = 1

command! GPGEncrypt call s:encrypt()
command! GPGDecrypt call s:decrypt()

" GPG encrypt current file
fun! s:encrypt()
    set noswapfile
    g/^gpg:/d
    %!gpg -easq
endf

""
" GPG decrypt current file
fun! s:decrypt()
    set noswapfile
    %!gpg -dq
    g/^gpg:/d
endf
