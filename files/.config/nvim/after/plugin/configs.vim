" File: after/plugin/configs.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 23, 2021
" Description: default plugin configurations

if exists('g:loaded_configs_plugin')
    finish
endif
let g:loaded_configs_plugin = 1

let g:tagbar_width=30
let g:gutentags_file_list_command = 'rg --files'
let g:gutentags_cache_dir = globals#get('tagsdir')
let g:gutentags_ctags_extra_args = ['--excmd=number']
let g:EditorConfig_exclude_patterns = ['fugitive://.*']"
let g:zv_disable_mapping = 1
let g:vsnip_extra_mapping = v:false
let g:vsnip_snippet_dirs = [ globals#get('snippetdir') ]
let g:vsnip_snippet_dir  = globals#get('snippetdir')
let g:vsnip_filetypes = {
    \ 'javascript':      [ 'html', 'node',               'react', 'react-js',    'express' ],
    \ 'typescript':      [ 'html', 'node', 'javascript', 'react', 'react-ts',    'express' ],
    \ 'javascriptreact': [ 'html', 'node', 'javascript', 'react', 'react-js'  ],
    \ 'typescriptreact': [ 'html', 'node', 'javascript', 'react', 'react-ts'  ],
    \ }

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

let g:wildfire_objects = ['iw', 'iW', "i'", "a'", 'i`', 'a`', 'i"', 'a"',
    \ 'i)', 'a)', 'i]', 'a]', 'i}', 'a}', 'ip', 'it']

let g:lightline =
    \ {
    \     'colorscheme': 'nightfly',
    \     'active': {
    \       'left':  [['mode','paste'],['readonly','filename','modified']],
    \       'right': [['lsp', 'filetype', 'percent'], ['git'], ['folder']]
    \     },
    \     'component': {
    \         'folder': '%{utils#short_folderpath()}',
    \         'git':    '%{FugitiveStatusline()}',
    \         'lsp':    '%{lsp#status()}'
    \     }
    \ }

set background=dark
set termguicolors
let g:nightflyUndercurls = 0
colorscheme nightfly
