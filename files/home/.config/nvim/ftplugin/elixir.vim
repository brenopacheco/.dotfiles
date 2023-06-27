if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" https://github.com/elixir-editors/vim-elixir/blob/master/compiler/mix.vim

setlocal shiftwidth=2 softtabstop=2 expandtab iskeyword+=!,?
setlocal comments=:#
setlocal commentstring=#\ %s
setlocal suffixesadd=.ex,.exs,.eex,.heex,.leex,.sface,.erl,.xrl,.yrl,.hrl
setlocal formatoptions-=t formatoptions+=croqlj

let b:undo_ftplugin='setl sw< com< cms< sua< fo<'

iab <buffer> def def do<CR><BS>end<UP>
iab <buffer> defp defp do<CR><BS>end<UP><RIGHT>
iab <buffer> defm defmodule do <CR><BS>end<ESC>?do<CR><LEFT>i
