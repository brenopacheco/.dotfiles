" Settings {{{

	" NOTE: seems to be working as of qua 21 out 2020 10:30:38 WEST
	autocmd BufEnter * lua require'completion'.on_attach()

	let g:vsnip_extra_mapping                        =  v:false
	let g:vsnip_snippet_dir = expand('~/.config/nvim/snippets')
	let g:vsnip_integ_config = {}
	let g:vsnip_integ_config.vim_lsp                 =  v:false
	let g:vsnip_integ_config.vim_lsc                 =  v:false
	let g:vsnip_integ_config.lamp                    =  v:false
	let g:vsnip_integ_config.deoplete_lsp            =  v:false
	let g:vsnip_integ_config.language_client_neovim  =  v:false
	let g:vsnip_integ_config.asyncomplete            =  v:false
	let g:vsnip_integ_config.deoplete                =  v:false
	let g:vsnip_integ_config.mucomplete              =  v:false
	let g:vsnip_integ_config.nvim_lsp                =  v:true
	let g:vsnip_integ_config.auto_expand             =  v:false

	let g:completion_enable_snippet         = "vim-vsnip"
	let g:completion_enable_auto_popup      = 1
	let g:completion_enable_auto_hover      = 1
	let g:completion_enable_auto_signature  = 1
	" let g:completion_sorting                = "length"
	" let g:completion_matching_strategy_list = ['exact']
	let g:completion_matching_strategy_list = ['fuzzy']
	let g:completion_matching_ignore_case   = 1
	let g:completion_trigger_keyword_length = 1
	let g:completion_trigger_on_delete      = 1
	" let g:completion_trigger_character      = ['.', '::']
	let g:completion_chain_complete_list = {
	   \   'default' : {
	   \     'default': [
	   \       {'complete_items': ['lsp', 'vim-vsnip', 'buffer']}],
	   \     'comment': [
	   \       {'complete_items': ['buffer']}],
	   \     'path': [
	   \       {'complete_items': ['path']}],
	   \   }
	   \ }

	au BufEnter * syn match PATH './'
	let g:completion_menu_length = 6

	inoremap <CR> <c-g>u<cr>
	let g:completion_confirm_key = ""
	
"}}}
" Mappings{{{
	" set completeopt=menuone,noinsert
	" smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
	" imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
	" smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
    " xmap s <Plug>(vsnip-cut-text)
	" imap <expr> <TAB>  
	" 			\ pumvisible() ? 
	" 			\ 	complete_info()["selected"] != "-1" ?
	" 			\   	"\<Plug>(completion_confirm_completion)"  : 
	" 			\       "\<c-e>\<TAB>" :  
	" 			\   vsnip#jumpable(1) ? 
	" 			\ 		"\<Plug>(vsnip-jump-next)" :
	" 			\   	"\<TAB>"
"}}}
" Mappings 2 {{{
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
	smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
	imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
	smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
    xmap s <Plug>(vsnip-cut-text)
" }}}
