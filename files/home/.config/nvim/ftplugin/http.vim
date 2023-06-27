if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal formatoptions=croqlj
setlocal textwidth=80
setlocal comments=
setlocal commentstring=#\ %s
setlocal suffixesadd+=.http,.rest

let b:undo_ftplugin='setl ep< sw< ts< fdm< fde< fo< tw< com< cms< sua<'
