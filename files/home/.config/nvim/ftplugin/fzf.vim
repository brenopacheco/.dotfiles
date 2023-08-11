if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

set nobuflisted

tnoremap <buffer> jk <Esc>
tnoremap <buffer> kj <Esc>
tnoremap <buffer> <Esc> <Esc>

" TODO: is this necessary?
let b:undo_ftplugin="call utils#unmap('tmap <buffer>')"
