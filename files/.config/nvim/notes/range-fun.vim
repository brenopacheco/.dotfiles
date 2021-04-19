" INTRO
" When you press leader _, you enter command-line mode from visual mode.
" If you try to enter command-line mode from visual mode manually, you'll see that Vim automatically inserts this range:

" :'<,'>
"  ├┘ ├┘
"  │  └ mark put automatically on the last line of the visual selection
"  └ mark put automatically on the first line of the visual selection (see `:h '<`)

" So, when :call calls your MarkCodeBlock() function, Vim has automatically prefixed it with a range.
" And, from :h func-range:

"     If [range] is excluded, ":{range}call" will call the function for each line in the range, with the cursor on the start of each line.

" Because of this, your function is called once for every line in the range.

" You have 2 possibilities:

"     Eliminate the range by making your mapping press C-u (see :h c^u):

"     vnoremap <leader>_ :<c-u>call MarkCodeBlock()<CR>
"                         ^^^^^

"     Make Vim know that the function can handle the range itself and doesn't need :call to re-invoke it for every line in the range. You can do so by passing the range argument to :function:

"     function! MarkCodeBlock() range
"                               ^^^^^
"         ...
"     endfunction

" MY NOTES
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

" 1. calling '<,'>Function() will apply the function to every LINE selected
" 2. adding [ range ]  makes the command with '<,'> apply only ONCE
"   fun! Fun() range
"       echo mode()
"   endf
" 3. adding :<c-u> to the mapping deletes '<,'> when entering command mode
"   xnoremap <leader><leader> :<c-u>call Fun()<CR>
" 4. in the function we are given have a:firstline and b:firstline, even
" without a range. To get the curstor columns too, we need getpos("'<")

fun! PositionedFun() range
    let mode = visualmode()
    let [ _, sLine, sCol, _ ] = getpos("'<")
    let [ _, eLine, eCol, _ ] = getpos("'>")
    echomsg "Start: (line " . sLine . ",col " . sCol . ")"
    echomsg "End:   (line " . eLine . ",col " . eCol . ")"
    echomsg "Mode: " . mode
endf

xnoremap <leader><leader> :call PositionedFun()<CR>

