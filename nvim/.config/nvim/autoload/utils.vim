" File: autoload#utils.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description: 

""
" Returns root of given [optional] directory or current directory
" used .git as root indicator. if not a git directory, returns current
" directory. throws exception if given directory is invalid.
" [optional] directory path. default: getcwd
fun! utils#root(...)
    let dir = a:0 == 0 ? getcwd() : a:1
    if !isdirectory(expand(dir))
        throw 'Invalid directory.'
    end
    let root = system('cd '.dir.'; git rev-parse --show-toplevel 2>/dev/null')
    let root = substitute(root, '\n', '', '')
    return len(root) == 0 ? './' : root
endf

""
" returns all mappings given a command. skips <Plug>(commands).
" returns [ "mode", "map" ] list
" {cmd} nmap, tmap, map, vmap, ...
fun! utils#maps(cmd)
    return filter(map(split(execute(a:cmd), '\n'), 
        \ { _,s -> [split(s, ' ')[0], split(s, ' ')[2], split(s, ' ')[3]] }), 
        \ { _,s -> match(s[1], '^<[Pp]lug>') == -1 })
endf

""
" unmaps all maps given a command
" {cmd} nmap, tmap, map, vmap, ...
fun! utils#unmap(cmd)
    let maps = uniq(sort(map(utils#maps(a:cmd), { _,s -> s[1] })))
    let unmap = substitute(a:cmd, 'map', 'unmap', '')
    let cmds =  map(maps, { _, s -> unmap . ' ' . s })
    call map(cmds, { _, s -> execute(s) })
endf

""
" clears undo, swap and backup cache
fun! utils#clear_cache()
    let s:base_dir = expand('~/.cache/nvim/')
    let s:cache_files = [ 'swap', 'backup', 'undo' ]
    for cache_file in s:cache_files
        echo 'rm -f ' . s:base_dir . cache_file . '/*'
        echo system('rm -f ' . s:base_dir . cache_file . '/*')
    endfor
endf

""
" GPG encrypt current file
fun! utils#gpg_encrypt()
    set noswapfile
    g/^gpg:/d
    %!gpg -easq
endf

""
" GPG decrypt current file
fun! utils#gpg_decrypt()
    set noswapfile
    %!gpg -dq
    g/^gpg:/d
endf

""
" Default foldtext function
function! utils#foldtext()
  let line = substitute(getline(v:foldstart), '{', ' ', 'g')
  let line = '# ' . substitute(line, '^[ "]\+', '', '')
  let lines = v:foldend-v:foldstart
  let length = 71 - strwidth(line) - len(lines)
  return  line . repeat(' ', length) . lines . ' #lines'
endfunction

""
" Toggle a window open given a filetype. If no buffer is visible with
" given filetype, execute open. Otherwise, close window.
" { required } filetype of the buffer
" { required } open command for creating the window/buffer
fun! utils#toggle(filetype, open) abort
    for i in range(1, winnr('$'))  " if buf is in a window, close
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&ft') == a:filetype
            silent exe i . 'close'
            return
        endif
    endfor
    exec a:open
endfunction

