if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

set nobuflisted

tnoremap <buffer> <Esc> <C-\><C-n>
tnoremap <buffer> <C-[> <C-\><c-n>
tnoremap <buffer> jk <C-\><C-n>
tnoremap <buffer> kj <C-\><C-n>

let b:undo_ftplugin="call utils#unmap('tmap <buffer>')"

augroup repl
  au!
  au FileType repl setlocal nobuflisted bufhidden=unload
  au FileType repl setlocal noswapfile nonu nornu
  au WinEnter * if winnr('$') == 1 && &buftype == "repl" | q |endif
augroup END
