if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

"compiler
setlocal equalprg=
setlocal foldmethod=expr 
"setlocal foldmarker=
setlocal foldexpr=OrgFold(v:lnum)
setlocal formatoptions=croqlj
setlocal textwidth=78
setlocal comments=fb:*,b:#,fb:-
setlocal commentstring=#\ %s
setlocal suffixesadd=.org
" setlocal keywordprg=:help
" setlocal iskeyword+=#

let b:undo_ftplugin='setl mp< efm< ep< fdm< fmr< fde< fo< tw< com< cms< sua< kp< isk<'

"============================================================================

function! OrgFold(lnum)
    let level = strlen(matchstr(getline(a:lnum), '\v^\zs\*+'))
    if level > 0
        return '>'.level
    else
        return '='
    endif
endfunction


