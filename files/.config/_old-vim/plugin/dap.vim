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

command! -nargs=1 -complete=customlist,utils#cmd_complete
    \ Dap call utils#cmd_exec('dap',<q-args>)

" augroup dap_repl_settings
"     au!
"     au FileType dap-repl lua require('dap.ext.autocompl').attach()
"     au FileType dap-repl set nobuflisted
" augroup end

" function! JestStrategy(cmd)
"   echoerr a:cmd
"   let testName = matchlist(a:cmd, '\v -t ''(.*)''')[1]
"   let fileName = matchlist(a:cmd, '\v'' -- (.*)$')[1]
"   call luaeval("require'debugHelper'.debugJest([[" . testName . "]], [[" . fileName . "]])")
" endfunction

" fun! Attach()
"     lua require'debugHelper'.attach()
" endfun

" fun! TestJest()
"     TestNearest -strategy=jest
" endf
" let g:test#javascript#runner = 'jest'

" let g:test#custom_strategies = {'jest': function('JestStrategy')}
" " https://github.com/David-Kunz/vim/blob/master/init.vim
