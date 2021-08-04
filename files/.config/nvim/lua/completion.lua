-- File: completion.vim
-- Description: completion/snippet/pairs integration
-- TODO: manage my own snippets
-- TODO: add wrapper snippets (wrap around x)
-- TODO: replace vsnip with luasnip when it resolves https://github.com/L3MON4D3/LuaSnip/issues/89
-- TODO: avoid register overriding by select-mode

vim.o.completeopt = "menuone,noselect"

vim.cmd([[
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.emoji = v:false
let g:compe.source.vsnip = v:false
let g:compe.source.ultisnips = v:false
let g:compe.source.calc = v:false
let g:compe.source.path =       { 'priority': 100, 'dup': 0 }
let g:compe.source.luasnip =    { 'priority': 90,  'dup': 1 }
" let g:compe.source.vsnip =    { 'priority': 90,  'dup': 1 }
" let g:compe.source.luasnip =    v:false
let g:compe.source.treesitter = { 'priority': 80,  'dup': 1 }
let g:compe.source.nvim_lsp =   { 'priority': 70,  'dup': 0 }
let g:compe.source.nvim_lua =   { 'priority': 70,  'dup': 0 }
let g:compe.source.buffer =     { 'priority': 50,  'dup': 0 }
]])

require('nvim-autopairs').setup{}
require("nvim-autopairs.completion.compe").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true -- it will auto insert `(` after select function or method item
})
vim.cmd([[
inoremap <silent><expr> <C-Space> pumvisible() ? compe#close() : compe#complete()
inoremap <silent><expr> <TAB>     compe#confirm({'keys': '<TAB>', 'select': v:true})
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-b>     compe#scroll({ 'delta': -4 })
]])


local luasnip = require("luasnip")

luasnip.config.set_config({
  history = true,
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI",
})

require("luasnip/loaders/from_vscode").load()

vim.cmd([[
smap <Backspace> a<Backspace>
inoremap <silent> <C-k> <cmd>lua require'luasnip'.jump(1)<Cr>
inoremap <silent> <C-j> <cmd>lua require'luasnip'.jump(-1)<Cr>
vnoremap <silent> <C-k> <cmd>lua require('luasnip').jump(1)<Cr>
vnoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<Cr>

" smap <Backspace> a<Backspace>
" inoremap <silent> <C-k> <Plug>(vsnip-jump-next)<CR>
" inoremap <silent> <C-j> <Plug>(vsnip-jump-prev)<CR>
" vnoremap <silent> <C-k> <Plug>(vsnip-jump-next)<CR>
" vnoremap <silent> <C-j> <Plug>(vsnip-jump-prev)<CR>
" xmap s <Plug>(vsnip-cut-text)
]])







