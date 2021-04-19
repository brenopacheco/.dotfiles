if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler vint
setlocal equalprg=
setlocal foldmethod=marker
setlocal foldmarker={{{,}}}
" setlocal foldexpr=
setlocal formatoptions=croqlj
setlocal textwidth=78
setlocal comments=:\"
setlocal commentstring=\"\ %s
setlocal suffixesadd=.vim,.lua
" setlocal keywordprg=:help
setlocal iskeyword+=#
setlocal iskeyword-==

let b:undo_ftplugin='setl mp< efm< ep< fdm< fmr< fde< fo< tw< com< cms< sua< kp< isk<'

