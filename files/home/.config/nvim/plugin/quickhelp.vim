" File: plugin/help.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 23, 2021
" Description: configurations for the clippy help plugin

set encoding=utf-8
scriptencoding utf-8

let g:quickhelp_show_clippy = v:true
let g:quickhelp_display     = 'floating'

command! Help call quickhelp#toggle()

let s:noft = [
    \ '_______GOTO__________   ___NAVIGATE____',
    \ 'C-]   definition        ]e   diagnostic',
    \ 'gd    declaration       ]g   git hunk  ',
    \ 'gr    references        ]s   tagstack  ',
    \ 'gi    implementation    ]t   tag /     ',
    \ 'gy    type definition   ]a   arg       ',
    \ 'go    symbol document   ]b   buffer    ',
    \ 'gs    symbol workspace  ]q   quickfix  ',
    \ '                                       ',
    \ '____FIND_FILE____   ____FIND_MISC._____',
    \ 'spc-f-~   home      spc-f-m   marks    ',
    \ 'spc-f-.   curdir    spc-f-s   symbols  ',
    \ 'spc-f-g   gitls     spc-f-o   outline  ',
    \ 'spc-f-p   project   spc-f-/   rg pat.  ',
    \ 'spc-f-r   recent    spc-f-*   rg <word>',
    \ 'spc-f-b   buffers   spc-f-:   cmd hist ',
    \ 'spc-f-a   args      spc-f-h   helptags ',
    \ 'spc-f-c   classes   spc-f-m   make     ',
    \ '                                       ',
    \ '_____TOGGLE_____    ______ACTION_______',
    \ "spc-'   terminal    spc-a   code action",
    \ 'spc-n   navbar      spc-=   format     ',
    \ 'spc-↹   tagbar      spc-r   rename     ',
    \ 'spc-l   lf          spc-s   substitute ',
    \ 'spc-u   undotree    spc-#   run file   ',
    \ 'spc-q   quickfix    spc--   open Tree  ',
    \ 'spc-g   goyo        spc-i   snippet    ',
    \ '                                       ',
    \ '____QUICKFIX______   __MISCELLANEOUS___',
    \ 'spc-*   rg word prj  spc-w   window    ',
    \ 'spc-/   rg patt prj  spc-?   help      ',
    \ 'q-*     rg word buf  #       eval line ',
    \ 'q-/     rg patt buf  ⏎/⌫     wildfire  ',
    \ 'q-f     filter qf    q-n/p   cnewer/old',
    \ ]

let s:window = [
    \ '_____SPLIT______    ___OVERRIDES____',
    \ 'spc-w-s   <c-w>s    spc-w-e    :enew',
    \ 'spc-w-v   <c-w>v    spc-w-t    :tabe',
    \ 'spc-w-q   <c-w>q    spc-w-m    maxim',
    \ 'spc-w-c   <c-w>c    spc-w-a    :ball',
    \ '                                    ',
    \ '___RESIZE MULT.__   __RESIZE SING.__',
    \ 'spc-w-=   <c-w>=    spc-w--   <c-w>-',
    \ 'spc-w-_   <c-w>_    spc-w-+   <c-w>+',
    \ 'spc-w-|   <c-w>|    spc-w-<   <c-w><',
    \ 'spc-w-o   <c-w>o    spc-w->   <c-w>>',
    \ '                                    ',
    \ '_____MOVE_TO_____   ______JUMP______',
    \ 'spc-w-K   <c-w>K    spc-w-h   <c-w>h',
    \ 'spc-w-J   <c-w>J    spc-w-j   <c-w>j',
    \ 'spc-w-H   <c-w>H    spc-w-k   <c-w>k',
    \ 'spc-w-L   <c-w>L    spc-w-l   <c-w>l',
    \ 'spc-w-T   <c-w>T    spc-w-w   <c-w>w',
    \ ]

let s:debug = [
    \ "_____________________DEBUG_______________________",
    \ "F1  F2  F3  F4  F5  F6  F7  F8  F9  F10  F11  F12",
    \ "         懶  菱  ●                      "
    \ ]

" <F1>       step OUT
" <F2>       step IN
" <F3>       step OVER
" <F4>  懶     play / pause
" <F5>  菱    start / restart
" <F6>  ●     breakpoint toggle
" <F7>       breakpoints list
" <F8>       hover
" <F9>       scope
" <F10>      repl toggle
" <F11>      stack UP
" <F12>      stack DOWN

" call quickhelp#register('noft', s:noft)
" call quickhelp#register('window', s:window)
call quickhelp#register('debug', s:debug)
