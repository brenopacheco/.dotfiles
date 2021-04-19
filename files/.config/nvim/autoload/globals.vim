"  File: autoload/globals.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"  Last Modified: February 23, 2021
"  Description: global variables accessible from anywhere.
"  These are made accessible so that they can be referenced at any point
"  during vim's startup

let s:backupdir     = '~/.cache/nvim/backup/'
let s:plugdir       = '~/.cache/nvim/plug/'
let s:undodir       = '~/.cache/nvim/undo/'
let s:swapdir       = '~/.cache/nvim/swap//'
let s:tagsdir       = '~/.cache/nvim/tags/'
let s:snippetdir    = '~/.config/nvim/snippet/'
let s:templatedir   = '~/.config/nvim/template/'
let s:dictionarydir = '~/.config/nvim/dict/'
let s:fdignore      = '~/.fdignore'
let s:rgignore      = '~/.rgignore'
let s:extensions    = '^.*\.(sh|vim|lua|jsx|js|tsx|ts|java|c|h|cpp|html|css)$'

fun! globals#get(name)
    return expand(get(s:, a:name, ''))
endf
