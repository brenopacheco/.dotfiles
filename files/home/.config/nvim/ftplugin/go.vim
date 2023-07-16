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
" iab <buffer> re  return
" iab <buffer> tt  type
" iab <buffer> vv  var
" iab <buffer> cc  const
" iab <buffer> rr  range
" iab <buffer> af  func() {<CR>
" iab <buffer> fn  func() {<CR><ESC>?(<CR>i
" iab <buffer> ti  type interface {<CR><ESC>?interface<CR><LEFT>i
" iab <buffer> ts  type struct {<CR><ESC>?struct<CR><LEFT>i
" iab <buffer> ai  interface{<RIGHT>
" iab <buffer> if  if {<CR><ESC>?{<CR><LEFT>i
iab <buffer> ife if err != nil {<CR>
" iab <buffer> for for {<CR><ESC>?{<CR><LEFT>i
" iab <buffer> fori for i := 0; i < 1; i++ {<CR>
" iab <buffer> forr for := range foo {<CR><ESC>?for<CR>w<LEFT>i
" iab <buffer> sw  switch {<CR><BACKSPACE><TAB><ESC>?{<CR><LEFT>i
" iab <buffer> st  struct {<CR>
" iab <buffer> ss  []string
" iab <buffer> si  []int
" iab <buffer> sr  []rune
" iab <buffer> sb  []byte

let b:undo_ftplugin='setl ep< sw< ts< fdm< fde< fo< tw< com< cms< sua< kp<'
