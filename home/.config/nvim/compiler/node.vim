if exists("current_compiler")
  finish
endif
let current_compiler = "eslint"

let s:save_cpo = &cpo
set cpo-=C

let &l:errorformat  = '%AError: %m' . ','
let &l:errorformat .= '%AEvalError: %m' . ','
let &l:errorformat .= '%ARangeError: %m' . ','
let &l:errorformat .= '%AReferenceError: %m' . ','
let &l:errorformat .= '%ASyntaxError: %m' . ','
let &l:errorformat .= '%ATypeError: %m' . ','
let &l:errorformat .= '%Z%*[\ ]at\ %f:%l:%c' . ','
let &l:errorformat .= '%Z%*[\ ]%m (%f:%l:%c)' . ','
let &l:errorformat .= '%*[\ ]%m (%f:%l:%c)' . ','
let &l:errorformat .= '%*[\ ]at\ %f:%l:%c' . ','
let &l:errorformat .= '%Z%p^,%A%f:%l,%C%m' . ','
let &l:errorformat .= '%-G%.%#'

CompilerSet makeprg=node

let &cpo = s:save_cpo
unlet s:save_cpo
