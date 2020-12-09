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

