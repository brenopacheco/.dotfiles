if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal equalprg=
setlocal foldmethod=marker
setlocal foldmarker=<,/>
setlocal formatoptions=croqlj
setlocal comments=s:<!--,m:\ \ \ \ ,e:-->
setlocal commentstring=<!--%s-->
setlocal suffixesadd=.html,.js,.css
setlocal matchpairs+=<:>

let b:undo_ftplugin='setl ep< fdm< fmr< fde< fo< tw< com< cms< sua<'
    \ . ' kp< isk< mps<'
