"  File: autoload/cache.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"  Last Modified: February 23, 2021
"  Description: 

""
" Save a backup for the file
fun! cache#backup()
    let b:timestamp = strftime('%Y-%m-%d_%Hh%Mm')
    let b:expanded = expand('%:p')
    let b:subst = substitute(b:expanded, '/', "\\\\%", 'g')
    let b:dir = globals#get('backupdir')
    let b:backupfile = b:dir . b:timestamp . '_' . b:subst
    silent exec ':w! ' b:backupfile
endf

""
" Disable or enable backup for the buffer
fun! cache#toggle_backup()
    au! backup
endf

""
" Disable swap and remove swapfile
fun! cache#toggle_swap()
    throw "todo..."
endf

""
" clears undo, swap and backup cache
fun! cache#clear()
    let s:base_dir = expand('~/.cache/nvim/')
    let s:cache_files = [ 'swap', 'backup', 'undo' ]
    for cache_file in s:cache_files
        echo 'rm -f ' . s:base_dir . cache_file . '/*'
        echo system('rm -f ' . s:base_dir . cache_file . '/*')
    endfor
endf

