

function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction

let s:actions = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

let s:preview_window = ['right:50%', 'ctrl-/']

" up / down / left / right / window are allowed
let s:layout = { 
    \   'window': { 
    \     'width': 0.9, 
    \     'height': 0.9,
    \     'border': 'sharp'
    \   } 
    \}

" " list or string
" let s:options = {
"     \   [
"     \       '--reverse',
"     \       '--prompt', '>'
"     \   ]
"     \}

" fzf#run(specs) -> takes options, layout, actions, sources & sink
"                   do not respect global opts
" fzf#wrap(specs) -> merges specs with global opts
" fzf#run(fzf#wrap(specs)) -> runs mangled specs

" call fzf#run({
"     \   'source': 'ls',
"     \   'sink': 'e',
"     \   'options': '--prompt ">#" --preview "cat {}"'
"     \})
