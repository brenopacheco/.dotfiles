if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler tidy
setlocal equalprg=
setlocal foldmethod=marker
setlocal foldmarker=<,/>
" setlocal foldexpr=
setlocal formatoptions=croqlj
" setlocal textwidth=78
setlocal comments=s:<!--,m:\ \ \ \ ,e:-->
setlocal commentstring=<!--%s-->
setlocal suffixesadd=.html,.js,.css
" setlocal keywordprg=:help
" setlocal iskeyword+=#
setlocal matchpairs+=<:>

" call tailwind#setup()

let b:undo_ftplugin='setl mp< efm< ep< fdm< fmr< fde< fo< tw< com< cms< sua<'
    \ . ' kp< isk< mps< dict<'
