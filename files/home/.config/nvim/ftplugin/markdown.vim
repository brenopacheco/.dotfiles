if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal equalprg=
setlocal shiftwidth=4
setlocal tabstop=4
setlocal expandtab
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal formatoptions=croqlj
setlocal textwidth=80
setlocal comments=fb:*,fb:-,fb:+,n:>
setlocal commentstring=<!--%s-->

let b:undo_ftplugin='setl ep< sw< ts< et< fdm< fde< fo< tw< com< cms<'
