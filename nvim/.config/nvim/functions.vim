


command! ClearCache :call s:clear_cache()


fun! s:clear_cache()
    let s:base_dir = expand('~/.cache/nvim/')
    let s:cache_files = [ 'swap', 'backup', 'undo' ]
    for cache_file in s:cache_files
        echo 'rm -f ' . s:base_dir . cache_file . '/*'
        echo system('rm -f ' . s:base_dir . cache_file . '/*')
    endfor
endf
"
"
"
"
" show encryption/decryption info in echo
" show encryption/decryption info in aux. buffer
" list available recipients
" list recipients in message
" verify signature
" allow ranges

command! GPGEncrypt silent exec 'g/^gpg:/d' | exec '%!gpg -easq'
command! GPGDecrypt exec '%!gpg -dq' | silent exec 'g/^gpg:/d'
" command! GPGVerify call s:verify()

" fun! s:verify()
"     let tmpf = system()
" endf

