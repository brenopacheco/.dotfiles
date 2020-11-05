" Commentary {{{
	autocmd FileType c,cpp setlocal commentstring=//\ %s
"}}}
" EasyMotion {{{
	let g:EasyMotion_add_search_history = 0
	let g:EasyMotion_do_mapping = 0
	let g:EasyMotion_inc_highlight = 1
"}}}
" Quickscope{{{
	let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
"}}}
" Undotree{{{
	set undofile
	set undodir=~/.config/nvim/.undodir
"}}}
" Gutentags{{{
	let g:gutentags_file_list_command = 'rg --files'
	" let g:gutentags_cache_dir = $HOME . "./configs/tags"
"}}}
" Tagbar{{{
	let g:tagbar_width=30
"}}}
" Lf{{{
	let g:bclose_no_plugin_maps=1
	let g:lf_map_keys = 0
	au  Filetype lf tmapclear
"}}}
" FZF{{{
"}}}
" Limelight{{{
	let g:limelight_default_coefficient = 0.7
"}}}
" Goyo{{{
	autocmd! User GoyoEnter Limelight
	autocmd! User GoyoLeave Limelight!
"}}}
" Tree-sitter {{{

" lua <<EOF
" 	require'nvim-treesitter.configs'.setup {
" 	  ensure_installed = "all",     
" 	  highlight = {
" 		enable = true,             
" 		disable = {},  
" 	  },
" 	}
" EOF

" 	au! Filetype c,cpp,go,python,java,javascript,html,yaml
" 		\ setlocal foldmethod=expr | 
" 		\ setlocal foldexpr=nvim_treesitter#foldexpr()

" }}}
" Zeavim{{{
    let g:zv_disable_mapping = 1
	augroup plugin-zeavim
	  autocmd!
	  autocmd FileType c,cpp,sh,javascript,html,css
				  \ nmap <buffer>K <Plug>Zeavim
	augroup END
	let g:zv_file_types = {
		\   'css':  'css,foundation,bootstrap_4',
		\   'cpp':  'c',
		\   'sh':   'bash',
		\   '\v^(md|mdown|mkd|mkdn)$': 'markdown',
		\ }
"}}}
" Netrw {{{
	let g:netrw_liststyle = 3
	let g:netrw_banner = 0
	let g:netrw_browse_split = 4
	let g:netrw_winsize = 30
	let g:netrw_altv = 1
" }}} 
" Doge {{{
	let g:doge_enable_mappings = 0
	let g:doge_mapping         = 0
	let g:doge_buffer_mappings = 0
"}}}
" template {{{
	let g:templates_directory = $HOME . "/.config/nvim/templates"
" }}}
" signify {{{
    let g:signify_line_highlight = 0
" }}}
" Lightline {{{

	let g:lightline = 
			\ {
			\     'colorscheme': 'wombat',
			\     'active': {
			\         'left': [
			\             [
			\                 'mode',
			\                 'paste'
			\             ],
			\             [
			\                 'readonly',
			\                 'filename',
			\                 'modified'
			\             ]
			\         ],
			\         'right': [
			\             [
			\                 'lsp',
			\                 'filetype',
			\                 'percent'
			\             ],
			\             [
			\                 'git'
			\             ],
			\             [
			\                 'folder'
			\             ]
			\         ]
			\     },
			\     'component': {
			\         'folder': '%{ShortFolderPath()}',
			\         'git':    '%{FugitiveStatusline()}',
			\         'lsp':    '%{LspStatus()}'
			\     }
			\ }

	" Components {{{

		function! ShortFolderPath() 
			let l:path = substitute(getcwd(), expand($HOME), "~", "") 
			let l:maxwidth = winwidth(0) / 5
			if strlen(l:path) > l:maxwidth 
				let l:path = '…'.matchstr(l:path, '.\{'.l:maxwidth.'\}$')
			end
			return l:path.'/'
		endfunction

		function! LspStatus() abort
		  if luaeval('#vim.lsp.buf_get_clients() > 0')
			return luaeval("require('lsp-status').status()")
		  endif
		  return ''
		endfunction

	"}}}
"}}}
