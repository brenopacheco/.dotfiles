set clipboard^=unnamed,unnamedplus

function! Fzy(choice_command, vim_command)
  try
    let output = system(a:choice_command . " | fzy ")
    exec a:vim_command . ' ' . output
  catch /Vim:Interrupt/
    " Swallow errors from ^C
  endtry
  redraw!
endfunction

command Find :call Fzy("fd . -t f", ":e")

nnoremap <space>f :Find<cr>
