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
    let g:completion_trigger_on_delete      = 0
    let g:completion_abbr_length            = 20
    let g:completion_menu_length            = 8
    let g:completion_trigger_character      = []
    let g:completion_timer_cycle            = 80
    let g:completion_confirm_key = ""
    let g:completion_enable_auto_popup      = 0
    let g:completion_chain_complete_list = {
       \  'default': [
       \    {'complete_items': ['lsp', 'vim-vsnip', 'buffer']}
       \ ]
       \ }
    let g:completion_items_priority = {
            \ 'Value':      10,
            \ 'Field':      12,
            \ 'Method':     10,
            \ 'Property':   10,
            \ 'Constant':   10,
            \ 'vim-vsnip':  9,
            \ 'Snippet':    8,
            \ 'Function':   7,
            \ 'Variables':  8,
            \ 'Interfaces': 7,
            \ 'Class':      7,
            \ 'Struct':     7,
            \ 'Keyword':    8,
            \ 'Buffer':     5,
            \}

"}}}
" Mappings {{{

    " pum OPEN:
    "   -> tab   complets/expands
    "   -> s-tab jumps next
    " pum CLOSED:
    "   -> tab   jumps next
    "   -> s-tab jumps prev

    au TextChangedI * if !pumvisible() | call s:popup_check() | endif

    fun! s:popup_check()
        let word = matchstr(getline("."), '\(\S\+\)\%' . col(".") . 'c')
        let char = word[len(word)-1]
        let omni = &omnifunc != ''
        if char == '/'
            call feedkeys("\<c-x>\<c-f>")
        elseif char == '.'
            if omni 
                call feedkeys("\<c-x>\<c-o>")
            endif
        elseif char =~ '\k'
            if match(word, '\.') == -1
                call feedkeys("\<c-space>")
            else
                if omni 
                    call feedkeys("\<c-x>\<c-o>")
                endif
            endif
        endif
    endf

    imap <silent><expr> <tab> <SID>handle_completion()

    fun! s:handle_completion()
        let popupopen = pumvisible()
        let selected   = complete_info()["selected"] != "-1"
        let expandable = vsnip#expandable()
        let jumpable   = vsnip#jumpable(1)
        let beforefun  = getline('.')[col('.')-1] == '('
        if popupopen
            if selected
                if beforefun
                    return "\<c-y>\<Right>"
                endif
                if expandable
                    return "\<c-y>\<Plug>(vsnip-expand)"
                else
                    let info = complete_info()
                    let mode = info.mode
                    let kind = info.items[info.selected].kind
                    if mode == "files" || kind == "Variable" || kind == "Field"
                        return "\<c-y>"
                    elseif kind == "Function" || kind == "Method"
                        return "\<c-y>("
                    else
                        return "\<c-y>\<space>"
                    endif
                endif
            else
                return "\<c-n>\<tab>"
            endif
        elseif !popupopen
            if expandable
                return "\<Plug>(vsnip-expand)"
            elseif jumpable
                return "\<Plug>(vsnip-jump-next)"
            else
                return "\<tab>"
            endif
            return "none of the candidates worked"
        endif
    endf

    imap <expr> <c-l> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : ''
    smap <expr> <c-l> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : ''
    imap <expr> <c-h> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : ''
    smap <expr> <c-h> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : ''
    imap <expr> <S-tab> pumvisible() ? "\<c-l>" : "\<c-h>"
    smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
    smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : ''

    imap <silent> <C-space> <Plug>(completion_trigger)
    xmap s <Plug>(vsnip-cut-text)

    smap <Backspace> a<Backspace>


" }}}

