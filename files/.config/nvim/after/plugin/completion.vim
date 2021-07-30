" File: after/plugin/completion.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description: definitions for nvim-compe
" Provide a fix for working with "lexima"

if exists('g:loaded_completion_plugin')
    finish
endif
let g:loaded_completion_plugin = 1

set completeopt=menuone,noinsert,noselect
set pumheight=10
let g:compe                      = {}
let g:compe.enabled              = v:true
let g:compe.autocomplete         = v:true
let g:compe.debug                = v:true
let g:compe.min_length           = 1
let g:compe.preselect            = 'never'
let g:compe.throttle_time        = 80
let g:compe.source_timeout       = 200
let g:compe.incomplete_delay     = 400
let g:compe.max_abbr_width       = 24
let g:compe.max_kind_width       = 10
let g:compe.max_menu_width       = 20
let g:compe.documentation        = v:true

let g:compe.source = {}
let g:compe.source.path                = v:false " Path completion.
let g:compe.source.buffer              = v:false " Buffer completion.
let g:compe.source.tags                = v:false " Tag completion.
let g:compe.source.spell               = v:false " Spell file completion.
let g:compe.source.calc                = v:false " Lua math expressions.
let g:compe.source.omni                = v:false " Omni completion.
let g:compe.source.dict                = v:false " Dictionary files completion.
let g:compe.source.nvim_lsp            = v:false " Neovim's builtin LSP completion.
let g:compe.source.nvim_lua            = v:false " Neovim's Lua "stdlib" completion.
let g:compe.source.vim_lsp             = v:false " vim-lsp completion.
let g:compe.source.vim_lsc             = v:false " vim-lsc completion.
let g:compe.source.vsnip               = v:false " vim-vsnip completion.
let g:compe.source.ultisnips           = v:false " UltiSnips completion.
let g:compe.source.snippets_nvim       = v:false " snippets.nvim completion.
let g:compe.source.treesitter          = v:false " nvim-treesitter completion.

let g:compe.source = {
    \ 'path':       { 'priority': 100, 'dup': 0, 'menu': '[PATH]'},
    \ 'treesitter': { 'priority': 90,  'dup': 1, 'menu': '[TREESITTER]' },
    \ 'vsnip':      { 'priority': 80,  'dup': 1, 'menu': '[SNIP]' },
    \ 'nvim_lsp':   { 'priority': 70,  'dup': 0, 'menu': '[LSP]' },
    \ 'buffer':     { 'priority': 60,  'dup': 0, 'menu': '[BUFFER]' },
    \ }

call compe#setup(g:compe)

inoremap <silent><expr> <C-Space> pumvisible() ? compe#close() : compe#complete()
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : ''
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : ''
xmap s <Plug>(vsnip-cut-text)
smap <Backspace> a<Backspace>

inoremap <silent><expr> <F6>      compe#confirm()
imap <silent><expr> <Tab> pumvisible() ?
    \   (complete_info()["selected"] == "-1" ? "\<c-n>\<F6>" : "\<F6>") :
    \   (vsnip#available(1) ? "\<plug>(vsnip-expand-or-jump)" : "\<TAB>")

if exists('g:plugs["lexima.vim"]')
    let g:lexima_no_default_rules = 1
    call lexima#set_default_rules()
    call lexima#insmode#map_hook('before', '<CR>', '')
    imap <silent><expr><CR>
        \ pumvisible() ?
        \   complete_info()["selected"] == "-1" ?
        \       compe#close() . "\<CR>"
        \       :
        \       "\<tab>\<CR>"
        \   :
        \   lexima#expand('<LT>CR>', 'i')
endif
