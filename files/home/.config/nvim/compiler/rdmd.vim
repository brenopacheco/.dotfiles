if exists("current_compiler")
  finish
endif
let current_compiler = "rdmd"

let s:save_cpo = &cpo
set cpo-=C

CompilerSet errorformat=
	\%-G\(spec:%*[0-9]\)\ %m,
	\%*[^@]@%f\(%l\):\ %m,
	\%f-mixin-%*[0-9]\(%l\\,%c\):\ %m,
	\%f-mixin-%*[0-9]\(%l\):\ %m,
	\%f\(%l\\,%c\):\ %m,
	\%f\(%l\):\ %m

CompilerSet makeprg=rdmd

let &cpo = s:save_cpo
unlet s:save_cpo
