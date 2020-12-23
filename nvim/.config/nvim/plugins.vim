" Plug {{{
    " checks wether a plugin is loaded
    function! s:plugged(name)
        return has_key(g:plugs, a:name)
    endfunction
" }}}
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
    let &undodir=g:undodir
"}}}
" Gutentags{{{
    let g:gutentags_file_list_command = 'rg --files'
    " let g:gutentags_cache_dir = $HOME . "./configs/tags"
    let g:gutentags_ctags_extra_args = ['--excmd=number']
"}}}
" Tagbar{{{
    let g:tagbar_width=30
"}}}
" Lf{{{
    let g:bclose_no_plugin_maps=1
    let g:lf_map_keys = 0
    au  FileType lf tmapclear
"}}}
" FZF{{{

    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
      copen
      cc
    endfunction

    let $FZF_DEFAULT_COMMAND = 'fd --hidden'
    let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

    let g:fzf_preview_window = ['right:50%', 'ctrl-/']
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8, 'yoffset': 0.2 } }

"}}}
" Limelight{{{
    let g:limelight_default_coefficient = 0.7
"}}}
" Goyo{{{
    autocmd! User GoyoEnter Limelight
    autocmd! User GoyoLeave Limelight!
"}}}
" Tree-sitter {{{
if s:plugged('nvim-treesitter')
lua <<EOF
    require'nvim-treesitter.configs'.setup {
      ensure_installed = { "bash", "c", "css", "html", "java", 
                           "javascript", "json", "lua", "typescript" },
      highlight = {
        enable = true
      }
    }
EOF
" augroup plugin-treesiter
"   au FileType sh,bash,c,cpp,lua,java,css,html,json,
"                 \javascript,typescript,typescriptreact,javascriptreact
"                 \ set foldmethod=expr |
"                 \ set foldexpr=nvim_treesitter#foldexpr()
" augroup END
endif
" }}}
" Zeavim{{{

    let g:zv_disable_mapping = 1
    augroup plugin-zeavim
      autocmd!
      au FileType sh,bash,c,cpp,lua,java,css,html,json,
                  \javascript,typescript,typescriptreact,javascriptreact
                  \ nmap <buffer>K <Plug>Zeavim | vmap <buffer>K <Plug>ZVVisSelection
    augroup END
    let g:zv_file_types = {
        \   'css':                              'css,bootstrap',
        \   '^c\(pp\)\?$':                      'c',
        \   '^\(sh|bash|zsh\)$':                'bash',
        \   '^java$':                           'java,spring',
        \   'javascript\(react\)\?':            'javascript,node,express,react',
        \   'typescript\(react\)\?':            'typescript,node,express,react',
        \   '\v^(md|mdown|mkd|mkdn|markdown)$': 'markdown',
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
    let g:templates_no_autocmd = 1
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

        function! LspStatus() abort
            return "LSP disabled"
        endfunction

        function! ShortFolderPath() 
            let l:path = substitute(getcwd(), expand($HOME), "~", "") 
            let l:maxwidth = winwidth(0) / 5
            if strlen(l:path) > l:maxwidth 
                let l:path = '…'.matchstr(l:path, '.\{'.l:maxwidth.'\}$')
            end
            return l:path.'/'
        endfunction

    "}}}
"}}}
" autopairs/lexima {{{
    " let g:AutoPairsMapBS = 0
    " let g:AutoPairsMapCh = 0
    " always insert new line on <CR> regardless of pum
    let g:lexima_accept_pum_with_enter = 0
" }}}
" Vista {{{
    " let g:vista_default_executive = 'ctags'
     let g:vista_default_executive = 'nvim_lsp'
" }}}
" vim-qf {{{
    " let g:qf_auto_resize = 0
    " let g:qf_max_height = 10
    let g:qf_auto_quit = 0
    let g:qf_shorten_path = 1
    let g:qf_auto_open_quickfix = 1

    " fork things
    " shorten path
    " auto open
    " Find/Keep Reject/Discard Restore
    "    -> from anywhere. finds list
    " toggle

" }}}
" editor-config {{{
    let g:EditorConfig_exclude_patterns = ['fugitive://.*']"
" }}}
" vsnip {{{

    let g:vsnip_filetypes = {
                \ 'javascript': [ 'javascript-express' ],
                \ 'javascriptreact': [ 'javascript', 'html' ],
                \ 'typescriptreact': [ 'javascript', 'html' ]
                \ }
    let g:vsnip_extra_mapping = v:false
    let g:vsnip_snippet_dir   = expand('~/.config/nvim/snippets')

" }}}
" vim-easy-align {{{

    let g:easy_align_delimiters = {
        \  ',': { 'pattern': ',',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
        \  ';': { 'pattern': ';',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
        \  ']': { 'pattern': ']',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
        \  '[': { 'pattern': '[',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
        \  '(': { 'pattern': '(',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
        \  ')': { 'pattern': ')',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
        \  '-': { 'pattern': '-',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 1 },
        \  '/': { 'pattern': '/',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 }
        \ }

" }}}
" Codi {{{

let g:codi#raw = 1
let g:codi#width = 70
let g:codi#use_buffer_dir = 1
let g:codi#virtual_text = 0
"}}}
" Asyncrun {{{
    let g:asyncrun_open = 10
" }}}
