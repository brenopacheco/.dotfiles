"  File: plugin/toggle.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"  Last Modified: February 23, 2021
"  Description: 

if exists('g:loaded_toggle_plugin')
    finish
endif
let g:loaded_toggle_plugin = 1

command! NetrwToggle    call utils#toggle('netrw', 'Lexplore')
command! TreeToggle     call utils#toggle('vimtree', 'VGTree')
command! TerminalToggle call utils#toggle('term', 'Term')
command! QuickfixToggle call utils#toggle('qf', 'copen') | wincmd p

" command! VGTree         call s:vgtree()
" command! OTree          call s:otree()
" command! Term           call s:termopen()

