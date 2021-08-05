" File: proxy.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 25, 2021
" Description: provides a proxy method for wrapping existing functions

" TODO: generate random name so that it's possible to wrap multiple times
""
" Proxies an existing public function of name fun (string) through a wrapper
" function (funcref). The wrapper function must take a funcref to the proxied
" function as single named argument and a rest parameter as second argument.
" For instance:
" proxy#wrap('Example', { fun, ... -> a:000 > 2 ? fun(a1, a2) : fun() })
" The function works by copying and rewriting the original public function.
fun! proxy#wrap(fun, wrapper)
    let def = map(split(execute('function '.a:fun), "\n"),{ _,s -> s[3:]})
    let def[0] = substitute(def[0], '^\s*function', 'fun!', '')
    let original = def[0]
    let args     = substitute(substitute(matchstr(def[0], 
        \ '(.*)')[1:-2], '\.\.\.', '0', ''), '\(\S\+\)', 'a:\1', 'g')
    let def[0]   = substitute(def[0], ' ', ' _', '')
    let def      = join(def, "\n")
    call execute(def)
    let copy = original . "\n\treturn " . string(a:wrapper)
        \ . "(funcref('_" . a:fun . "')," . args .")\nendf"
    call execute(copy)
endf


