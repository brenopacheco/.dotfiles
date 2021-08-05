" TODO: fix here
if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler python
setlocal equalprg=yapf
" setlocal foldmethod=marker
" setlocal foldmarker={{{,}}}
" " setlocal foldexpr=
" setlocal formatoptions=croqlj
" setlocal textwidth=78
" setlocal comments=:\"
" setlocal commentstring=\"\ %s
" setlocal suffixesadd=.vim,.lua
" setlocal keywordprg=:help
" setlocal iskeyword+=#
" setlocal iskeyword-==

" let b:undo_ftplugin='setl mp< efm< ep< fdm< fmr< fde< fo< tw< com< cms< sua< kp< isk<'



setlocal cinkeys-=0#
setlocal indentkeys-=0#
setlocal include=^\\s*\\(from\\\|import\\)

setlocal suffixesadd=.py
setlocal comments=b:#,fb:-
setlocal commentstring=#\ %s

set wildignore+=*.pyc

setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8

setlocal keywordprg=pydoc
