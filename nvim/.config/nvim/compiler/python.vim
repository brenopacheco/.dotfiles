if exists('current_compiler')
  finish
endif
let current_compiler = 'python'

let s:save_cpo = &cpo
set cpo-=C

setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
setlocal makeprg=python3

let &cpo = s:save_cpo
unlet s:save_cpo
