if exists('current_compiler')
  finish
endif
let current_compiler = 'go'

let s:save_cpo = &cpo
set cpo-=C

CompilerSet makeprg=go\ run
CompilerSet errorformat=
    \%-G#\ %.%#,
    \%A%f:%l:%c:\ %m,
    \%A%f:%l:\ %m,
    \%C%*\\s%m,
    \%-G%.%#

let &cpo = s:save_cpo
unlet s:save_cpo
