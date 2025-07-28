if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler make
setlocal equalprg=
setlocal shiftwidth=0
setlocal softtabstop=0
setlocal tabstop=4
setlocal noexpandtab
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal formatoptions-=t formatoptions=croqlj
setlocal textwidth=100
setlocal comments=sO:#\ -,mO:#\ \ ,b:#
setlocal commentstring=#\ %s
setlocal suffixesadd+=~,.o,.h,.obj,.cpp
setlocal keywordprg=:Man
setlocal include=^\\s*include
let b:man_default_sects = '3,2'

let b:undo_ftplugin='setl mp< efm< ep< sw< sts< ts< noet< fdm< fde< fo< tw< com< cms< sua< kp< inc<'
