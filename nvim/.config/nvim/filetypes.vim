
au Filetype vim set foldmethod=marker | set iskeyword+=:
au BufNewFile,BufRead *.h set ft=c
au BufNewFile,BufRead *.org set filetype=org


function OrgFold(lnum)
  let level = strlen(matchstr(getline(a:lnum), '\v^\s*\zs\*+'))
  if level > 0
    return '>'.level
  else
    return '='
  endif
endfunction

au Filetype org setlocal
        \ foldmethod=expr 
        \ foldexpr=OrgFold(v:lnum)
        " \ foldtext=getline(v:foldstart).'...'.repeat('\ ',999)


