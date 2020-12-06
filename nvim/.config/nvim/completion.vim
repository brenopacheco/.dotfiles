" Settings {{{

	set completeopt=menuone,noinsert,noselect
    set pumheight=8

	autocmd BufEnter * lua require'completion'.on_attach()

	let g:completion_enable_snippet         = "vim-vsnip"
	let g:completion_enable_auto_popup      = 1
	let g:completion_enable_auto_hover      = 1
	let g:completion_enable_auto_signature  = 1
	let g:completion_sorting                = "length"
	let g:completion_matching_strategy_list = ['exact']
	let g:completion_matching_ignore_case   = 1
	let g:completion_trigger_keyword_length = 1
	let g:completion_trigger_on_delete      = 1
	let g:completion_trigger_character      = ['.']
    let g:completion_abbr_length = 20
    let g:completion_menu_length = 8
	let g:completion_chain_complete_list = {
	   \   'default' : {
	   \     'default': [
	   \       {'complete_items': ['lsp', 'vim-vsnip', 'buffers']},
	   \       {'complete_items': ['lsp']},
	   \       {'complete_items': ['vim-vsnip']},
	   \       {'complete_items': ['buffers']},
	   \       {'complete_items': ['path'], 'triggered_only': ['/']}],
	   \    'comment': [
	   \        {'complete_items': ['buffers', 'path', 'vim-vsnip']}],
	   \    'string': [
	   \        {'complete_items': ['buffers', 'path']}],
	   \    'path': [
	   \        {'complete_items': ['path']}],
	   \    'cIncluded': [
	   \        {'complete_items': ['path']}]
	   \   }
	   \ }

	"omni": i_CTRL-X_CTRL-O
	"keyn": i_CTRL-X_CTRL-N
	"file": i_CTRL-X_CTRL-F
	"user": i_CTRL-X_CTRL-U
    "
    " how to write user complete func that mixes other completion sources?
    " i.e: files, omni, keyn,  dict, tags?
    " getcompletion({pat}, {type} [, {filtered}])		*getcompletion()*

    let g:completion_items_priority = {
            \ 'vim-vsnip':  11,
            \ 'Method':     10,
            \ 'Field':      10,
            \ 'Function':   10,
            \ 'Variables':  10,
            \ 'Interfaces': 10,
            \ 'Constant':   10,
            \ 'Class':      10,
            \ 'Struct':     10,
            \ 'Keyword':    10,
            \ 'Buffers':    1,
            \ 'File':       1,
            \}

	au BufEnter * syn match PATH './'

	inoremap <CR> <c-g>u<cr>
	let g:completion_confirm_key = ""

"}}}
" Mappings {{{

	imap <expr> <TAB>
				\ pumvisible() ?
				\ 	complete_info()["selected"] != "-1" ?
				\   	"\<Plug>(completion_confirm_completion)"  :
				\       "\<C-n>\<F5>" :
				\   vsnip#jumpable(1) ?
				\ 		"\<Plug>(vsnip-jump-next)" :
				\   	"\<TAB>"
	imap <F5> <TAB>
	imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
	smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
	smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
	nmap <expr> <Tab>   vsnip#jumpable(1)  ? 'i<Plug>(vsnip-jump-next)' : '<Tab>'
	nmap <expr> <S-Tab> vsnip#jumpable(1)  ? 'i<Plug>(vsnip-jump-prev)' : '<Tab>'
    xmap s <Plug>(vsnip-cut-text)

    imap <silent> <C-space> <Plug>(completion_trigger)
    imap <c-j> <Plug>(completion_next_source)
    imap <c-k> <Plug>(completion_prev_source)

" }}}
