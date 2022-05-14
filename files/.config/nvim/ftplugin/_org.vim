if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal formatoptions=croqlj
setlocal textwidth=78

let b:undo_ftplugin='setl ep< sw< ts< fo< tw< '
