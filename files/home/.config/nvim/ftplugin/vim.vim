if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" There is no vimscript formatter :(
setlocal foldmethod=marker
setlocal foldmarker={{{,}}}
setlocal formatoptions=croqlj
setlocal textwidth=78
setlocal comments=:\"
setlocal commentstring=\"\ %s
setlocal suffixesadd=.vim,.lua
setlocal keywordprg=:help
setlocal iskeyword-==

let b:undo_ftplugin='setl ep< fdm< fmr< fde< fo< tw< com< cms< sua< kp< isk<'

