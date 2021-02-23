if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

set nobuflisted

tnoremap <buffer> jk <Esc>
tnoremap <buffer> kj <Esc>
tnoremap <buffer> <Esc> <Esc>

command! Snippets  call fzf#run(wrapper#snippets())
command! Args      call fzf#run(wrappers#args())
command! PFiles    call fzf#run(wrappers#project())


let b:undo_ftplugin="call utils#unmap('tmap <buffer>')"
