" Settings {{{

    set completeopt=menuone,noinsert,noselect
    set pumheight=8

    autocmd BufEnter * lua require'completion'.on_attach()

    let g:completion_enable_auto_paren      = 1
    let g:completion_enable_server_trigger  = 0
    let g:completion_enable_snippet         = "vim-vsnip"
    let g:completion_trigger_keyword_length = 1
    let g:completion_enable_auto_hover      = 1
    let g:completion_enable_auto_signature  = 1
    let g:completion_sorting                = "length"
    let g:completion_matching_strategy_list = ['exact']
    let g:completion_matching_ignore_case   = 1
    let g:completion_trigger_on_delete      = 1
    let g:completion_abbr_length            = 20
    let g:completion_menu_length            = 8
    " let g:completion_trigger_character      = ['.', '{', '_']
    let g:completion_trigger_character      = []
    let g:completion_timer_cycle            = 80 " required for fast typing

    " au CursorMovedI * if getline('.')[col('.')-2] == '/' 
    "             \ | call feedkeys("\<c-x>\<c-f>") | endif
    " au CursorMovedI * if !pumvisible() | call s:popup_check() | endif
    au TextChangedI * if !pumvisible() | call s:popup_check() | endif


    fun! s:i_aword() abort
        let idx_start = match(getline("."), '\(\S\+\)\%' . col(".") . 'c')
        let idx_end = col(".") - 2
        return getline(".")[idx_start:idx_end]
    endfun

    fun! s:popup_check()
        let word = matchstr(getline("."), '\(\S\+\)\%' . col(".") . 'c')
        let char = word[len(word)-1]
        if char == '/'
            call feedkeys("\<c-x>\<c-f>")
        elseif char == '.'
            call feedkeys("\<c-x>\<c-o>")
        elseif char =~ '\k'
            if match(word, '\.') == -1
                call feedkeys("\<c-space>")
            else
                call feedkeys("\<c-x>\<c-o>")
            endif
        endif
    endf

    " issues w/ 1 completion. i.e: vim fun
    " let g:completion_auto_change_source     = 1 
    let g:completion_enable_auto_popup      = 0
    let g:completion_chain_complete_list = {
       \  'default': [
       \    {'complete_items': ['lsp', 'vim-vsnip', 'buffer']},
       \ ]
       \ }

    set spelllang=custom
    set nospell
    set complete=.,kspell
    set iskeyword-==
    set iskeyword-=/

    let g:completion_items_priority = {
            \ 'Value':      10,
            \ 'Field':      12,
            \ 'Method':     10,
            \ 'Property':   10,
            \ 'Constant':   10,
            \ 'vim-vsnip':  9,
            \ 'Snippet':    8,
            \ 'Function':   7,
            \ 'Variables':  7,
            \ 'Interfaces': 7,
            \ 'Class':      7,
            \ 'Struct':     7,
            \ 'Keyword':    7,
            \ 'Buffer':     5,
            \}

"}}}
" Mappings {{{

    " i_CTRL-E closes popup
    " iunmap <CR>
    inoremap <CR> <c-e><cr>
    let g:completion_confirm_key = ""
    imap <expr> <TAB>
                \ pumvisible() ?
                \     complete_info()["selected"] != "-1" ?
                \       getline('.')[col('.')-1] != '(' ?
                \           "\<Plug>(completion_confirm_completion)" :
                \           "\<C-y>" :
                \       "\<C-n>\<Plug>(completion_confirm_completion)" :
                \   vsnip#jumpable(1) ?
                \         "\<Plug>(vsnip-jump-next)" :
                \       "\<tab>"

    imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
    smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
    smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
    xmap s <Plug>(vsnip-cut-text)

    imap <silent> <C-space> <Plug>(completion_trigger)

    smap <Backspace> a<Backspace>

" }}}
" Notes {{{
    " triggered_only will IF it is in trigger_character
    " <c-n> instead of buffer, <c-x><c-f> instead of path and omni instead
    " i.e: {'mode': 'file', 'triggered_only': ['/']},
    
    " first try path, but path is only triggered by /
    " then try lsp and snip, which is default for programming
    " then try buffer and then buffers
"}}}

