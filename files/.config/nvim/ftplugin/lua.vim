if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler lua
setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal foldmarker=[[,]]
setlocal foldexpr=marker
setlocal expandtab
" setlocal foldmethod=expr
" setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal formatoptions=croqlj
setlocal textwidth=78
setlocal comments=s:--[[,m:\ ,e:]],:--
setlocal commentstring=--%s
setlocal suffixesadd=.lua
setlocal keywordprg=:help
setlocal iskeyword+=.
setlocal isfname+=.,/

iab <buffer> af  function() <CR><CR>end<ESC>ki<TAB>
iab <buffer> fn  function() <CR><CR>end<ESC>?(<CR>i

let b:undo_ftplugin='setl mp< sw< ts< efm< ep< fdm< fde< fo< tw< com< cms< sua< kp< isf<'
