" File: dap.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 25, 2021
" Description:
"
if exists('g:loaded_dap_plugin')
    finish
endif
let g:loaded_dap_plugin = 1

" command! DapStartRestart     call dap#start_restart()
" command! DapPlayPause        call dap#play_pause()
" command! DapStepOver         call dap#step_over()
" command! DapStepOut          call dap#step_out()
" command! DapStepIn           call dap#step_in()
" command! DapToggleBreakpoint call dap#toggle_breakpoint()
" command! DapBreakpoints      call dap#breakpoints()
" command! DapStackUp          call dap#stack_up()
" command! DapStackDown        call dap#stack_down()
" command! DapToggleRepl       call dap#toggle_repl()
" command! DapHover            call dap#hover()
" command! DapScope            call dap#scope()

augroup dap_repl_settings
    au!
    au FileType dap-repl lua require('dap.ext.autocompl').attach()
    au FileType dap-repl set nobuflisted
augroup end
