if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler lua
setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal foldmarker=[[,]]
" setlocal foldexpr=marker
setlocal foldexpr=expr
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal expandtab
setlocal formatoptions=croqlj
setlocal textwidth=78
setlocal comments=s:--[[,m:\ ,e:]],:--
setlocal commentstring=--%s
setlocal suffixesadd=.lua
setlocal keywordprg=:help
setlocal isfname+=.,/
setlocal formatexpr=

let b:undo_ftplugin='setl mp< sw< ts< efm< ep< fdm< fde< fo< tw< com< cms< sua< kp< isf< fex<'
