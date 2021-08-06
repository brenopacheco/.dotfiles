if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler lua
setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal foldmarker=[[,]]
setlocal formatoptions=croqlj
setlocal textwidth=78
setlocal comments=s:--[[,m:\ ,e:]],:--
setlocal commentstring=--%s
setlocal suffixesadd=.lua
setlocal keywordprg=:help
setlocal iskeyword-=.
setlocal isfname+=.,/

let b:undo_ftplugin='setl mp< sw< ts< efm< ep< fdm< fo< tw< com< cms< sua< kp< isf<'