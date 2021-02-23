" File: autoload#java.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description: 

" return package name from file path
" {required} file path
fun! java#package(path)
    let root    = utils#root(a:path)
    let package = substitute(a:path, root, '', '')
    let package = substitute(package, '.*\/java\/','','g')
    let package = substitute(package,'/','\.','g')
    return package
endf

