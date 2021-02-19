au BufNewFile,BufRead *.h set filetype=c
au BufNewFile,BufRead *.org set filetype=org
au FileType typescriptcss,less,scss,json,markdown,vue,yaml,html,angular
    \ let &equalprg = "prettier --parser " . &ft
au Filetype lua setlocal equalprg=lua-format
au Filetype lua setlocal foldmethod=marker foldmarker=[[,]]
au Filetype org setlocal foldmethod=expr foldexpr=OrgFold(v:lnum)
au Filetype vim setlocal foldmethod=marker foldmarker={{{,}}}

function OrgFold(lnum)
  let level = strlen(matchstr(getline(a:lnum), '\v^\zs\*+'))
  if level > 0
    return '>'.level
  else
    return '='
  endif
endfunction


au Filetype qf,tagbar,term,vimtree set nobuflisted

" " toggables {{{
" let s:quitables = [ "term", "quickfix", "tagbar" ]
" " do not list toggable windows
" augroup ignore_buffers
"     autocmd!
"     au Filetype qf,tagbar,term,vimtree 
"                 \ set nobuflisted |
"     au BufEnter * call s:leave()
" augroup END

" function! s:leave()
"     if index(s:quitables, &ft) > -1
"         if winbufnr(2) == -1
"           quit!
"         endif
"     endif
" endfunction

" toggable windows should not be left alone. " TODO: task
" function! s:keep_layout()
"     if index(s:quitables, &ft) > -1
"         echo "leaving"
"         buffer #
"     endif
" endfunction
"}}}
" lua{{{


"}}}

" formatters

    " lsp provides formatter for c,cpp 
