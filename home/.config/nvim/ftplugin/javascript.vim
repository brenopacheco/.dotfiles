if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler node
setlocal expandtab
setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal formatoptions=croqlj
setlocal textwidth=80
setlocal comments=s1:/*,mb:*,ex:*/
setlocal commentstring=//%s
setlocal suffixesadd+=.cjs,.css,.d.ts,.html,.js,.json,.jsx,.mjs,.ts,.tsx
setlocal keywordprg=:zeal\ javascript:\

let b:undo_ftplugin='setl et< mp< efm< ep< sw< ts< fdm< fde< fo< tw< com< cms< sua< kp< isk<'
