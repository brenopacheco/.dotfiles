if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

compiler eslint
setlocal equalprg=prettier\ --parser\ typescript
setlocal shiftwidth=2
setlocal tabstop=2
"setlocal foldmethod=
"setlocal foldmarker=
"setlocal foldexpr=
setlocal formatoptions=croqlj
setlocal textwidth=80
setlocal comments=s1:/*,mb:*,ex:*/
setlocal commentstring=//%s
setlocal suffixesadd+=.js,.jsx,.json,.css,.html
" setlocal keywordprg=:help
" setlocal iskeyword+=#

let b:undo_ftplugin="setl mp< efm< ep< sw< ts< fdm< fmr< fde fo< tw< com< cms< sua< kp< isk<"






