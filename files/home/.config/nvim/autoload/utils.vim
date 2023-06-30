""
" Return a list of files from the fd command run at the root of a git project
" {pattern} the pattern to search for. if any, use v:false
" {dir} the dir to search for files. if current dir, use v:false
fun! utils#files(pat, dir)
    let pat = a:pat != v:false ? a:pat : ''
    let dir = a:dir != v:false ? a:dir : getcwd()
    return systemlist('fd "' . pat . '" -H -j 2 -t f ' . dir)
endf


fun! utils#root()
    return utils#git_root()
endf

""
" Returns root of given [optional] directory or current directory
" used .git as root indicator. if not a git directory, returns current
" directory. throws exception if given directory is invalid.
" [directory path] default: getcwd
fun! utils#git_root(...)
    let dir = a:0 == 0 ? getcwd() : a:1
    if !isdirectory(expand(dir))
        throw 'Invalid directory.'
    end
    let root = system('cd '.dir.'; git rev-parse --show-toplevel 2>/dev/null')
    let root = substitute(root, '\n', '', '')
    return len(root) == 0 ? './' : root
endf

""
" Returns the root of the current npm project
fun! utils#npm_root()
    let dir = getcwd()
    while dir !=# '/'
        let files = systemlist('ls ' . dir)
        if index(files, 'package.json') > -1 || index(files, 'README.md') > -1
            return dir
        endif
        let dir = substitute(dir, '[^\/]\+\(\/\)\?$', '', '')
    endwhile
    return utils#git_root()
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

" Hello there! {{{
""
" Toggle a window open given a filetype. If no buffer is visible with
" given filetype, execute open. Otherwise, close window.
" { required } filetype of the buffer
" { required } open command for creating the window/buffer
" [ optional ] direction (true or false). toggle open or close
fun! utils#toggle(filetype, open, ...) abort
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&ft') == a:filetype
            if !a:0 || (a:0 && !a:1)
                silent exe i . 'close'
            endif
            return
        endif
    endfor
    if !a:0 || (a:0 && a:1)
        exec a:open
    endif
endfunction
" }}}
