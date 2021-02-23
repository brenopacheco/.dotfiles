"  File: gpg.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"  Last Modified: February 23, 2021
"  Description: 

if exists('g:loaded_gpg_plugin')
    finish
endif
let g:loaded_gpg_plugin = 1

" TODO: set filetype to gpg. add ftplugin configs.
" disable backup, undo and swap

command! GPGEncrypt call gpg#encrypt()
command! GPGDecrypt call gpg#decrypt()
