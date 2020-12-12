" Settings {{{

    set completeopt=menuone,noinsert,noselect
    set pumheight=8

    autocmd BufEnter * lua require'completion'.on_attach()

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
    let g:completion_timer_cycle            = 50 " required for fast typing

    au CompleteDone * if getline('.')[col('.')-2] == '/' 
                \ | call feedkeys("\<c-space>") | endif
                
    au TextChangedI * if getline('.')[col('.')-2] == ' ' 
                \ && getline('.')[col('.')-3] == ':'
                \ | call feedkeys("\<c-space>") | endif

    let g:completion_auto_change_source     = 1
    let g:completion_enable_auto_popup      = 1
    let g:completion_chain_complete_list = {
       \  'default': [
       \    {'complete_items': ['lsp', 'vim-vsnip']},
       \    {'complete_items': ['lsp']},
       \    {'mode': '<c-n>'},
       \    {'mode': 'file'},
       \ ]
       \ }

    set spelllang=custom
    set nospell
    set complete=.,kspell
    set iskeyword+=/
    set iskeyword-==

    let g:completion_items_priority = {
            \ 'Value':      10,
            \ 'Field':      10,
            \ 'Method':     10,
            \ 'Property':   10,
            \ 'Constant':   10,
            \ 'vim-vsnip':  9,
            \ 'Function':   8,
            \ 'Variables':  8,
            \ 'Interfaces': 8,
            \ 'Class':      8,
            \ 'Struct':     8,
            \ 'Keyword':    8,
            \}

"}}}
" Mappings {{{

    " i_CTRL-E closes popup
    inoremap <CR> <c-g>u<cr>
    let g:completion_confirm_key = "\<C-y>"
    imap <expr> <TAB>
                \ pumvisible() ?
                \     complete_info()["selected"] != "-1" ?
                \       "\<Plug>(completion_confirm_completion)"  :
                \       "\<C-n>\<C-y>" :
                \   vsnip#jumpable(1) ?
                \         "\<Plug>(vsnip-jump-next)" :
                \       "\<TAB>"

    imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
    smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
    smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
    xmap s <Plug>(vsnip-cut-text)

    imap <silent> <C-space> <Plug>(completion_trigger)
    imap <c-j> <Plug>(completion_next_source)
    imap <c-k> <Plug>(completion_prev_source)

    " sometimes C-n C-p will trigger first completion.
    inoremap <c-n> <Down>
    inoremap <c-p> <Up>

" }}}
" Notes {{{
    " triggered_only will IF it is in trigger_character
    " <c-n> instead of buffer, <c-x><c-f> instead of path and omni instead
    " i.e: {'mode': 'file', 'triggered_only': ['/']},
    
    " first try path, but path is only triggered by /
    " then try lsp and snip, which is default for programming
    " then try buffer and then buffers
"}}}

