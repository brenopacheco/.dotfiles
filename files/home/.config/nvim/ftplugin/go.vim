if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler go
setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal formatoptions=croqlj
setlocal textwidth=80
setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s
setlocal suffixesadd+=~,.mod,.go
setlocal keywordprg=zeal\ go:\

iab <buffer> eq  :=
iab <buffer> ife if err != nil {<CR>

let b:undo_ftplugin='setl mp< efm< ep< sw< ts< fdm< fde< fo< tw< com< cms< sua< kp<'
