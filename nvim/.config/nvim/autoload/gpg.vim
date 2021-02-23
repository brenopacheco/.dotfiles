"  File: autoload/gpg.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"  Last Modified: February 23, 2021
"  Description: 

""
" GPG encrypt current file
fun! gpg#encrypt()
    set noswapfile
    g/^gpg:/d
    %!gpg -easq
endf

""
" GPG decrypt current file
fun! gpg#decrypt()
    set noswapfile
    %!gpg -dq
    g/^gpg:/d
endf
