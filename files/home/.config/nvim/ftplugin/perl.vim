if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal makeprg=perl
setlocal foldmethod=marker
setlocal foldmarker={{{,}}}
setlocal formatoptions=croqlj
setlocal textwidth=78
setlocal comments=:#
setlocal commentstring=#%s
setlocal suffixesadd=.perl,.pl,.pm
setlocal keywordprg=perldoc\ -f
setlocal iskeyword+=:
setlocal expandtab
" TODO: add include, includeexpr, define

let b:undo_ftplugin='setl mp< ep< fdm< fmr< fde< fo< tw< com< cms< sua< kp< isk< et<'

