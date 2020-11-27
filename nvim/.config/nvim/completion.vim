" Settings {{{

	" NOTE: seems to be working as of qua 21 out 2020 10:30:38 WEST
	autocmd BufEnter * lua require'completion'.on_attach()

	let g:vsnip_extra_mapping                        =  v:false
	let g:vsnip_snippet_dir = expand('~/.config/nvim/snippets')

	let g:completion_enable_snippet         = "vim-vsnip"
	let g:completion_enable_auto_popup      = 1
	let g:completion_enable_auto_hover      = 1
	let g:completion_enable_auto_signature  = 1
	let g:completion_sorting                = "length"
	let g:completion_matching_strategy_list = ['exact', 'fuzzy']
	let g:completion_matching_ignore_case   = 1
	let g:completion_trigger_keyword_length = 1
	let g:completion_trigger_on_delete      = 1
	let g:completion_trigger_character      = ['.', '::']
	let g:completion_chain_complete_list = {
	   \   'default' : {
	   \     'default': [
	   \       {'complete_items': ['lsp', 'vim-vsnip', 'buffers']},
	   \       {'complete_items': ['path'], 'triggered_only': ['/']}],
	   \     'comment': [
	   \       {'complete_items': ['buffers', 'path']}],
	   \     'string': [
	   \       {'complete_items': ['buffers', 'path']}],
	   \     'path': [
	   \       {'complete_items': ['path']}],
	   \     'cIncluded': [
	   \       {'complete_items': ['path']}],
	   \   }
	   \ }

	au BufEnter * syn match PATH './'
	let g:completion_menu_length = 6

	inoremap <CR> <c-g>u<cr>
	let g:completion_confirm_key = ""
	
"}}}
" Mappings {{{
	set completeopt=menuone,noinsert,noselect
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
" }}}
