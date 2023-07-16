if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler eslint
setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal formatoptions=croqlj
setlocal textwidth=80
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=/*\ %s\ */

let b:undo_ftplugin='setl mp< efm< ep< sw< ts< fo< tw< com< cms< '
