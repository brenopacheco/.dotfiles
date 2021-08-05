"  File: fzf.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"  Last Modified: February 23, 2021
"  Description:

if exists('g:loaded_fzf_plugin')
    finish
endif
let g:loaded_fzf_plugin = 1

command! Snippets  call fzf#run(wrappers#snippets())
command! Args      call fzf#run(wrappers#args())
command! PFiles    call fzf#run(wrappers#files('', utils#git_root()))
command! FFiles    call fzf#run(wrappers#files('', utils#npm_root()))
command! Sources   call fzf#run(wrappers#sources())

inoremap <expr> <c-x><c-f> fzf#vim#complete#path(
    \ "find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'",
    \ fzf#wrap({'dir': expand('%:p:h')}))


" FZF CONFIGURATIONS ========================================================

let $FZF_DEFAULT_COMMAND = 'fd --hidden'
let preview_file = $HOME.'/.fzf/bin/preview.sh'
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8, 'yoffset': 0.2 } }

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

command! -bang -nargs=* Tags
  \ call fzf#vim#tags(<q-args>, {
  \      'options': '
  \         --with-nth 1,2
  \         --prompt "=> "
  \         --preview-window="50%"
  \         --preview ''' . preview_file . ' {2}:$(echo {3} | cut -d ";" -f 1)'''
  \ }, <bang>0)
