set encoding=utf-8
scriptencoding utf-8

let g:quickhelp_show_clippy = v:true
let g:quickhelp_display     = 'floating'

command! -nargs=1 -complete=custom,clippy#list Clippy call clippy#toggle(<args>)

let s:debug = [
    \ "_____________________DEBUG_______________________",
    \ "F1  F2  F3  F4  F5  F6  F7  F8  F9  F10  F11  F12",
    \ "         懶  菱  ●                      "
    \ ]
