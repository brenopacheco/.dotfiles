
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


let s:toggables = [ "term", "quickfix", "tagbar", "vimtree" ]
" do not list toggable windows
augroup ignore_buffers
    autocmd!
    au Filetype qf,tagbar,term,vimtree 
                \ set nobuflisted |
    au BufEnter * call s:leave()
augroup END

function! s:leave()
    if index(s:toggables, &ft) > -1
        if winbufnr(2) == -1
          quit!
        endif
    endif
endfunction

" toggable windows should not be left alone. " TODO: task
" function! s:keep_layout()
"     if index(s:toggables, &ft) > -1
"         echo "leaving"
"         buffer #
"     endif
" endfunction
