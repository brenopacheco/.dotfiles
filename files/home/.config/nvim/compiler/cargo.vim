if exists('current_compiler')
	finish
endif
let current_compiler = "cargo"

let s:save_cpo = &cpo
set cpo-=C

CompilerSet makeprg=cargo\ run\ $*

CompilerSet errorformat+=
			\%-G%\\s%#Downloading%.%#,
			\%-G%\\s%#Compiling%.%#,
			\%-G%\\s%#Finished%.%#,
			\%-G%\\s%#error:\ Could\ not\ compile\ %.%#,
			\%-G%\\s%#To\ learn\ more\\,%.%#

let &cpo = s:save_cpo
unlet s:save_cpo
