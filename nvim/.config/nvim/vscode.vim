function! s:showCommands()
    let startLine = line("v")
    let endLine = line(".")
    call VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
endfunction

xnoremap <silent> <C-P> <Cmd>call <SID>showCommands()<CR>



nnoremap <silent> <C-k> <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
nnoremap <silent> <leader>= <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>
nnoremap <silent> <leader><leader> <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>
