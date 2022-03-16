if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" compiler gcc
" setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal formatoptions=croqlj
setlocal textwidth=80
setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s
setlocal suffixesadd+=~,.mod,.go
setlocal keywordprg=zeal\ go:\

iab <buffer> eq  :=
iab <buffer> t   type
iab <buffer> v   var
iab <buffer> c   const
iab <buffer> r   range
iab <buffer> af  func() {<CR>
iab <buffer> fn  func() {<CR><ESC>?(<CR>i
" iab <buffer> in  interface {<CR><ESC>?{<CR><LEFT>i
iab <buffer> if  if {<CR><ESC>?{<CR><LEFT>i
iab <buffer> ife if err != nil {<CR>
iab <buffer> for for {<CR><ESC>?{<CR><LEFT>i
iab <buffer> sw  switch {<CR><ESC>?{<CR><LEFT>i
iab <buffer> st  struct {<CR>
iab <buffer> s] []string
iab <buffer> i] []int
iab <buffer> r] []rune
iab <buffer> b] []byte

let b:undo_ftplugin='setl ep< sw< ts< fdm< fde< fo< tw< com< cms< sua< kp<'
