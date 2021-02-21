

""
" returns all mappings given a command. skips <Plug>(commands).
" returns [ "mode", "map" ] list
" {cmd} nmap, tmap, map, vmap, ...
fun! utils#maps(cmd)
    return filter(map(split(execute(a:cmd), "\n"), 
        \ { _,s -> [split(s, " ")[0], split(s, " ")[2]] }), 
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


