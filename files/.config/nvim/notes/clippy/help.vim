

let s:help =
    \ [
    \    "<c-n>       next file",
    \    "<c-p>       previous file",
    \    "<cr>        :Gedit",
    \    "cA          :Gcommit --amend --reuse-message=HEAD",
    \    "ca          :Gcommit --amend",
    \    "cc          :Gcommit",
    \    "cva         :Gcommit --amend --verbose",
    \    "cvc         :Gcommit --verbose",
    \    "D           :Gdiff",
    \    "ds          :Gsdiff",
    \    "dp          :Git! diff (p for patch; use :Gw to apply)",
    \    "dp          :Git add --intent-to-add (untracked files)",
    \    "dv          :Gvdiff",
    \    "O           :Gtabedit",
    \    "o           :Gsplit",
    \    "p           :Git add --patch",
    \    "p           :Git reset --patch (staged files)",
    \    "q           close status",
    \    "r           reload status",
    \    "S           :Gvsplit"
    \ ]

au! FileType fugitive call SetHelp()

fun! SetHelp() abort
    call setbufvar(0, 'help', s:help)
endf

function! ShowHelp() abort
  for item in getbufvar(0, 'help')
    echo item
  endfor
endfunction
