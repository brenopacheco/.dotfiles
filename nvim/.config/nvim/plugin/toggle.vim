"  File: plugin/toggle.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"  Last Modified: February 23, 2021
"  Description: 

if exists('g:loaded_toggle_plugin')
    finish
endif
let g:loaded_toggle_plugin = 1

command! TreeToggle     call utils#toggle('vimtree', 'VGTree')
command! TerminalToggle call utils#toggle('term', 'call term#open()')
command! QuickfixToggle call quickfix#toggle()

" command! VGTree         call s:vgtree()
" command! OTree          call s:otree()
" command! Term           call s:termopen()

