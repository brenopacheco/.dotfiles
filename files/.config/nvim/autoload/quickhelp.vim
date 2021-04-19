" File: autoload/quickhelp.vim
" Author: brenopacheco
" Description:
" Last Modified:

let s:clippy =
            \ [ ' ╭──╮   ',
            \   ' │  │   ',
            \   ' @  @  ╭',
            \   ' ││ ││ │',
            \   ' ││ ││ ╯',
            \   ' │╰─╯│  ',
            \   ' ╰───╯  ',
            \   '        ' ]

""
" @private
" Map of quickhelps. Follows { 'filetype': string[] } format
let s:map = {}

""
" @public
" Register quickhelp for filetype. the "help" argument is a string to be
" displayed when calling quickhelp#open().
fun! quickhelp#register(filetype, help)
    if type(a:help) != 3
        echomsg "Help argument must be a list of strings."
        return
    endif
    let s:map[a:filetype] = a:help
endf

""
" @public
" Opens quickhelp for given [optional] filetype.
" If no filetype is given, opens current filetype's quickhelp.
" @default filetype=&ft
fun! quickhelp#open(...)
    if a:0 > 0
        let ft = a:1
    else
        let ft = &ft
    endif
    if !has_key(s:map, ft)
        echomsg "Filetype has no quickhelp set."
        return
    endif
    let quickhelp = ""
    if g:quickhelp_show_clippy
        let quickhelp = s:merge(s:clippy, s:enbox(s:merge(s:map[ft], [])))
    else
        let quickhelp = s:enbox(s:merge(s:map[ft], []))
    endif
    if g:quickhelp_display == "echo"
        echo join(quickhelp, "\n")
    elseif g:quickhelp_display == "floating"
        let buffer = bufadd('___quickhelp___')
        silent call nvim_open_win(buffer, v:true, {
            \   'relative': 'editor',
            \   'width': strdisplaywidth(quickhelp[0]),
            \   'height': len(quickhelp),
            \   'col': &columns - strdisplaywidth(quickhelp[0]),
            \   'row': &lines - len(quickhelp) - &cmdheight,
            \   'style': 'minimal'
            \ })
        setlocal noswapfile bufhidden=wipe nowrap nobuflisted 
            \ buftype=nofile nolist modifiable
        call deletebufline(buffer, 1, "$")
        call appendbufline(buffer, 0, quickhelp)
        call deletebufline(buffer, "$")
        " call deletebufline(buffer, "$")
        setlocal nomodifiable
        set ft=quickhelp
        wincmd p
    else
        echomsg "Invalid g:quickhelp_display."
    endif
endf

fun! quickhelp#close()
    exec bufnr('___quickhelp___') . 'bw!'
endf

fun! quickhelp#toggle(args)
    if bufexists('___quickhelp___')
        call quickhelp#close()
    else
        call quickhelp#open(a:args)
    endif
endf


""
" @public
" List registered quickhelp filetypes
fun! quickhelp#list()
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
        \ { idx -> (idx < height1 ? a:list1[idx] . repeat(" ",
        \          width1 - strdisplaywidth(a:list1[idx])) : repeat(" ", width1))
        \          . (idx < height2 ? a:list2[idx] . repeat(" ",
        \          width2 - strdisplaywidth(a:list2[idx])) : repeat(" ", width2))
        \})
endf

""
" @private
" Encloses list of strings of same length in box.
fun! s:enbox(list)
    let box = map(copy(a:list), { _,s -> "┃ ". s . " ┃" })
    let width = strdisplaywidth(a:list[0])
    call insert(box, "┏" . repeat("━", width+2) . "┓")
    call add(box, "┗" . repeat("━", width+2) . "┛")
    return box
endf
