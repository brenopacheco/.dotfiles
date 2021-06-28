if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler csslint
setlocal equalprg=prettier\ --parser\ css
"setlocal foldmethod=
"setlocal foldmarker=
"setlocal foldexpr=
setlocal formatoptions=croqlj
setlocal textwidth=80
setlocal comments=s1:/*,mb:*,ex:*/
setlocal commentstring=/*%s*/
setlocal suffixesadd=.css,.sass,.less
" setlocal keywordprg=:help
" setlocal iskeyword+=#

let b:undo_ftplugin='setl mp< efm< ep< fdm< fmr< fde< fo< tw< com< cms< sua< kp< isk<'
