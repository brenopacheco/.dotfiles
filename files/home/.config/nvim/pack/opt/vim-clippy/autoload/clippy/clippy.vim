scriptencoding

let s:clippy =
            \ [ ' ╭──╮   ',
            \   ' │  │   ',
            \   ' @  @  ╭',
            \   ' ││ ││ │',
            \   ' ││ ││ ╯',
            \   ' │╰─╯│  ',
            \   ' ╰───╯  ',
            \   '        ' ]

let s:map = {}

""
" @public
" Register a clippy.
fun! clippy#register(filetype, message)
    if type(a:message) != 3
        echomsg 'Message argument must be a list of strings.'
        return
    endif
    let s:map[a:name] = a:message
endf

""
" @public
" Opens a specific clippy.
" @default filetype=&ft
fun! clippy#open(name)
    if !has_key(s:map, a:name)
        echomsg 'Filetype has no clippy set.'
        return
    endif
    let clippy = ''
    if g:clippy_show_clippy
        let clippy = s:merge(s:clippy, s:enbox(s:merge(s:map[a:name], [])))
    else
        let clippy = s:enbox(s:merge(s:map[a:name], []))
    endif
    if g:clippy_display ==? 'echo'
        echo join(clippy, '\n')
    elseif g:clippy_display ==? 'floating'
        let buffer = bufadd('clippy:///buffer')
        silent call nvim_open_win(buffer, v:true, {
            \   'relative': 'editor',
            \   'width': strdisplaywidth(clippy[0]),
            \   'height': len(clippy) - 1,
            \   'col': &columns - strdisplaywidth(clippy[0]),
            \   'row': &lines - len(clippy) - &cmdheight,
            \   'style': 'minimal'
            \ })
        setlocal noswapfile bufhidden=wipe nowrap nobuflisted 
            \ buftype=nofile nolist modifiable scrolloff=999
        call deletebufline(buffer, 1, '$')
        call appendbufline(buffer, 0, clippy)
        call deletebufline(buffer, '$')
        call deletebufline(buffer, '$')
        setlocal nomodifiable
        set ft=clippy
        wincmd p
    else
        echomsg 'Invalid g:clippy_display.'
    endif
endf

fun! clippy#close()
    exec bufnr('clippy:///buffer') . 'bw!'
endf

fun! clippy#toggle(name)
    if bufexists('clippy:///buffer')
        call clippy#close()
    else
        call clippy#open(a:name)
    endif
endf


""
" @public
" List registered clippy filetypes
fun! clippy#list()
    return keys(s:map)
endf

""
" @private
" Merges two string lists respecting str length. i.e:
" l1 = ["hello"]
" l2 = [" world", "wow"]
" [ "hello world", "     wow" ]
fun! s:merge(list1, list2)
    let width1 = max(map(copy(a:list1), 'strdisplaywidth(v:val)'))
    let width2 = max(map(copy(a:list2), 'strdisplaywidth(v:val)'))
    let height1 = len(a:list1)
    let height2 = len(a:list2)
    let height = max([height1, height2])
    return map(range(1, height),
        \ { idx -> (idx < height1 ? a:list1[idx] . repeat(' ',
        \          width1 - strdisplaywidth(a:list1[idx])) : repeat(' ', width1))
        \          . (idx < height2 ? a:list2[idx] . repeat(' ',
        \          width2 - strdisplaywidth(a:list2[idx])) : repeat(' ', width2))
        \})
endf

""
" @private
" Encloses list of strings of same length in box.
fun! s:enbox(list)
    let box = map(copy(a:list), { _,s -> '┃ '. s . ' ┃' })
    let width = strdisplaywidth(a:list[0])
    call insert(box, '┏' . repeat('━', width+2) . '┓')
    call add(box, '┗' . repeat('━', width+2) . '┛')
    return box
endf
