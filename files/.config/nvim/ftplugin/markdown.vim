if exists('b:did_ftplugin')
  finish
endif

setlocal formatoptions+=tcqln formatoptions-=r formatoptions-=o
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\\+\\\|^\\[^\\ze[^\\]]\\+\\]:
" setlocal foldexpr=MarkdownLevel()
" setlocal foldmethod=expr
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()

let b:undo_ftplugin='setl fo< flp< fde< fm<'

function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return '>1'
    endif
    if getline(v:lnum) =~ '^## .*$'
        return '>2'
    endif
    if getline(v:lnum) =~ '^### .*$'
        return '>3'
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return '>4'
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return '>5'
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return '>6'
    endif
    return '=' 
endfunction
