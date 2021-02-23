
" if exists('g:vscode')
"     source $HOME/.config/nvim/vscode.vim
" else

set clipboard     =unnamed,unnamedplus    " copy/pasting from x11 clipboard

inoremap jk <C-[>l
inoremap kj <C-[>l
nnoremap <space><space> VSCodeNotify('whichkey.show')<cr>

nnoremap <C-k>     <cmd>call VSCodeNotify('editor.action.showHover')<cr>
nnoremap <c-]>     <cmd>call VSCodeNotify('editor.action.revealDefinition ')<cr>
nnoremap gd        <cmd>call VSCodeNotify('editor.action.goToDeclaration')<cr>
nnoremap gr        <cmd>call VSCodeNotify('editor.action.goToReferences')<cr>
nnoremap gi        <cmd>call VSCodeNotify('editor.action.goToImplementation')<cr>
nnoremap gy        <cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<cr>
nnoremap go        <cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>
nnoremap gs        <cmd>call VSCodeNotify('workbench.action.showAllSymbols')<cr>
nnoremap ]e        <cmd>call VSCodeNotify('editor.action.marker.next')<cr><ESC>
nnoremap [e        <cmd>call VSCodeNotify('editor.action.marker.prev')<cr><ESC>
nnoremap <space>d <cmd>call VSCodeNotify('workbench.actions.view.toggleProblems')<cr>
nnoremap <space>a <cmd>call VSCodeNotify('editor.action.quickFix')<cr>
nnoremap <space>r <cmd>call VSCodeNotify('editor.action.rename')<cr>
nnoremap <space>= <cmd>call VSCodeNotify('editor.action.formatDocument')<cr>

