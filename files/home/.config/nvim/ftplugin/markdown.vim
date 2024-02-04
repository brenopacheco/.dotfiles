if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal expandtab
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
" setlocal formatoptions=croqlj
setlocal formatoptions=cqj
setlocal textwidth=80
setlocal colorcolumn=80
setlocal comments=fb:*,fb:-,fb:+,n:>
setlocal commentstring=<!--%s-->

let b:undo_ftplugin='setl ep< sw< ts< et< fdm< fde< fo< tw< cc< com< cms<'
