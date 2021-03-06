" File: autoload#utils.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description:


""
" Return a list of files from the fd command run at the root of a git project
" {pattern} the pattern to search for
fun! utils#files(...)
    let pat = a:0 == 0 ? "" : a:1
    return systemlist('fd "'.pat.'" -H -j 2 -t f '.utils#root())
endf


""
" Returns root of given [optional] directory or current directory
" used .git as root indicator. if not a git directory, returns current
" directory. throws exception if given directory is invalid.
" [directory path] default: getcwd
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
" Tells wether current directory is a fit repo or not.
fun! utils#is_git()
    let root = system('git status')
    return v:shell_error ? v:false : v:true
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
" [ optional ] direction (true or false). toggle open or close
fun! utils#toggle(filetype, open, ...) abort
    echo a:0
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&ft') == a:filetype
            if !a:0 || !a:1
                silent exe i . 'close'
            endif
            return
        endif
    endfor
    if !a:0 || a:1
        exec a:open
    endif
endfunction

""
"
fun! utils#short_folderpath()
    let l:path = substitute(getcwd(), expand($HOME), "~", "")
    let l:maxwidth = winwidth(0) / 5
    if strlen(l:path) > l:maxwidth
        let l:path = '???'.matchstr(l:path, '.\{'.l:maxwidth.'\}$')
    end
    return l:path.'/'
endfunction

" HELPER FUNCS ==============================================================

""
" command complete used with -complete=customlist,utils#cmd_complete
" only works for commands whose name is the same as the autocmd file
" requires the cmd to be defined as such:
" com! -nargs=1 -complete=customlist,utils#cmd_complete Lsp
"        \  call utils#cmd_exec('lsp',<q-args>)
" {required} a:1 = cmd prefix, a:2 = cmd origin, a:3 = length
fun! utils#cmd_complete(...)
    let cmd = substitute(a:2, '\s.*', '', '')
    return filter(utils#function_list(cmd),
        \ { _,s -> match(s, '^'. a:1) != -1 && len(s) > 0 })
endf

fun! utils#function_list(name)
    return sort(map(split(execute('function /^'.tolower(a:name).'#'),"\n"),
        \ { _,s -> matchstr(s[13:-1], '^\S\+()')[0:-3] }),
        \ { x,y -> len(x) - len(y) })
endf

""
" completes cmd_complete
fun! utils#cmd_exec(name, ...)
    echo execute('echo ' . a:name . '#' . a:1 . '()')
endf

