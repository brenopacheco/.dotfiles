if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler shellcheck
setlocal equalprg=
setlocal foldmethod=marker
setlocal foldmarker={{{,}}}
" setlocal foldexpr=
setlocal formatoptions=croqlj
setlocal textwidth=78
setlocal comments=:#
setlocal commentstring=#%s
setlocal suffixesadd=.sh
setlocal keywordprg=:Man
" setlocal iskeyword+=#

let b:undo_ftplugin='setl mp< efm< ep< fdm< fmr< fo< tw< com< cms< sua< kp<'
