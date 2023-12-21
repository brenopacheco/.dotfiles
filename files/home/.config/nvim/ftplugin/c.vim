if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler gcc-run
setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal formatoptions=croqlj
setlocal textwidth=80
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=//%s
setlocal suffixesadd+=~,.o,.h,.obj,.cpp
setlocal keywordprg=:Man
let b:man_default_sects = '3,2'

let b:undo_ftplugin='setl mp< efm< ep< sw< ts< fdm< fde< fo< tw< com< cms< sua< kp<'
