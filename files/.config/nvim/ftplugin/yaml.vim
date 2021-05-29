if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler yaml
setlocal equalprg=prettier\ --parser\ yaml
setlocal foldmethod=indent
setlocal formatoptions=croqlj
setlocal textwidth=78
setlocal comments=:#
setlocal commentstring=#\ %s
setlocal expandtab

let b:undo_ftplugin='setl mp< efm< ep< fdm< fo< tw< com< cms< et<'
