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

" decrypt gpg files on open and encrypt on save
" augroup GPG
"   autocmd!
"   autocmd BufReadPost  *.asc,*.gpg,*.pgp :%!gpg -q -d
"   autocmd BufReadPost  *.asc,*.gpg,*.pgp |redraw!
"   autocmd BufWritePre  *.asc,*.gpg,*.pgp :%!gpg -q -e -a
"   autocmd BufWritePost *.asc,*.gpg,*.pgp u
"   autocmd VimLeave     *.asc,*.gpg,*.pgp :!clear
" augroup END
