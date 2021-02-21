" File: autoload#tailwind.vim
" Author: brenopacheco
" Description: tailwind omnifunc setup
" Last Modified: February 21, 2021
"
" add dicionary completion to nvim-compe as dictionary completion

fun! tailwind#setup()
    setlocal dictionary=/home/breno/.config/nvim/dict/tailwind
    let b:compe = deepcopy(g:compe)
    let b:compe.source.dict = {
                \    "priority": 65,
                \    "dup": 0,
                \    "menu": "[DICT]",
                \ }
    call compe#setup(b:compe, 0)
endf
