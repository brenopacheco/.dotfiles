if exists('current_compiler')
  finish
endif
let current_compiler = 'cc-run'

let s:save_cpo = &cpo
set cpo-=C

if !filereadable('/tmp/cc-run')
  call writefile([
	  \ "#!/usr/bin/env sh",
	  \ "OUT=$(mktemp) || exit 1",
      \ "CMD=\"cc $1 -o $OUT\"",
	  \ "if eval \"$CMD\"; then",
	  \ "    chmod +x \"$OUT\"",
	  \ "    \"$OUT\"",
	  \ "fi",
	  \ "rm \"$OUT\""
	  \ ], '/tmp/cc-run')
  call system("chmod +x /tmp/cc-run")
endif

CompilerSet errorformat=
      \%*[^\"]\"%f\"%*\\D%l:%c:\ %m,
      \%*[^\"]\"%f\"%*\\D%l:\ %m,
      \\"%f\"%*\\D%l:%c:\ %m,
      \\"%f\"%*\\D%l:\ %m,
      \%-G%f:%l:\ %trror:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once,
      \%-G%f:%l:\ %trror:\ for\ each\ function\ it\ appears\ in.),
      \%f:%l:%c:\ %trror:\ %m,
      \%f:%l:%c:\ %tarning:\ %m,
      \%f:%l:%c:\ %m,
      \%f:%l:\ %trror:\ %m,
      \%f:%l:\ %tarning:\ %m,
      \%f:%l:\ %m,
      \%f:\\(%*[^\\)]\\):\ %m,
      \\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m,
      \%D%*\\a[%*\\d]:\ Entering\ directory\ %*[`']%f',
      \%X%*\\a[%*\\d]:\ Leaving\ directory\ %*[`']%f',
      \%D%*\\a:\ Entering\ directory\ %*[`']%f',
      \%X%*\\a:\ Leaving\ directory\ %*[`']%f',
      \%DMaking\ %*\\a\ in\ %f

CompilerSet makeprg=/tmp/cc-run

let &cpo = s:save_cpo
unlet s:save_cpo
