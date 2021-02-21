function! RangedFun(arg)
    echom "a:firstline: " . a:firstline 
                \ . " a:lastline: " . a:lastline 
                \ . " line: " . line(".")
                \ . " arg: \"" . a:arg . "\""
endfunction

command! -range Ranged <line1>,<line2>call RangedFun(getline("."))

" 1,5call RangedFun(getline("."))
" 3,6Ranged

" -range     Range allowed, default is current line
" <line1>    The starting line of the command range.
" <line2>    The final line of the command range.
