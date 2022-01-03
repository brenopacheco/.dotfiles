if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler gcc
setlocal equalprg=
setlocal shiftwidth=4
setlocal tabstop=4
setlocal foldmethod=manual
setlocal textwidth=78
setlocal comments=
setlocal commentstring=#\ %s
setlocal suffixesadd+=.c,.cpp

let b:undo_ftplugin='setl mp< efm< ep< sw< ts< fdm< tw< cms< sua<'
