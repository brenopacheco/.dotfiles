"  File: make.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"  Last Modified: February 22, 2021
"  Description: provides a :Run and :Make functions
"  :Run will try to run an interepreter for the file
"  :Make will look for project's root, set up the appropriate compiler,
"  and launch an FZF menu for selecting the correct target. If the target
"  is has a corresponding :compiler plugin, the FZF sink will set it up
"  and run with makeprg. Otherwise, the command is run in a terminal buffer.

if exists('g:loaded_make_plugin')
    finish
endif
let g:loaded_make_plugin = 1

command! Make call make#build()  " project-wide make
command! Run  call make#run()   " run file through interpreter
command! Lint call make#lint()  " lint file
command! Serve call make#serve()  " serve static files
command! Eval call make#eval_line()  " eval line through interpreter

" nnoremap #          <cmd>Eval<CR>
" nnoremap <leader>#  <cmd>Run<CR>
" nnoremap <leader>m  <cmd>Lint<CR>
" nnoremap <leader>fm <cmd>Make<CR>

