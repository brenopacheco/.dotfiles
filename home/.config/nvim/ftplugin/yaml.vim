if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal foldmethod=indent
setlocal formatoptions=croqlj
setlocal textwidth=78
setlocal comments=:#
setlocal commentstring=#\ %s
setlocal expandtab

let b:undo_ftplugin='setl ep< sw< fdm< fo< tw< com< cms< et<'
