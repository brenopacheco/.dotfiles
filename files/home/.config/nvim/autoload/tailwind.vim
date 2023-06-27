" File: autoload#tailwind.vim
" Author: brenopacheco
" Last Modified: February 21, 2021
" Description: sets up compe dicionary completion for tailwind

fun! tailwind#setup()
    exec 'setlocal dictionary='.globals#get('dictionarydir').'tailwind'
    let b:compe = deepcopy(g:compe)
    let b:compe.source.dict = {
                \    'priority': 65,
                \    'dup': 0,
                \    'menu': '[DICT]',
                \ }
    call compe#setup(b:compe, 0)
endf
