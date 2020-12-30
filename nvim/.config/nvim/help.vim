let g:quickhelp_show_clippy = v:true
let g:quickhelp_display = "floating"
" let g:quickhelp_display = "echo"
let s:noft = [ "test - wow" ]

call quickhelp#register("", s:noft)

