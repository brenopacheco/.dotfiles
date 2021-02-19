set completeopt=menuone,noinsert,noselect
set pumheight=10

let g:compe                      = {}
let g:compe.enabled              = v:true
let g:compe.autocomplete         = v:true
let g:compe.debug                = v:false
let g:compe.min_length           = 1
let g:compe.preselect            = 'always'
let g:compe.throttle_time        = 80
let g:compe.source_timeout       = 200
let g:compe.incomplete_delay     = 400
let g:compe.max_abbr_width       = 100
let g:compe.max_kind_width       = 10000
let g:compe.max_menu_width       = 100
let g:compe.documentation        = v:true

let g:compe.source               = {}
let g:compe.source.path          = v:true
let g:compe.source.buffer        = v:true
let g:compe.source.vsnip         = v:true
let g:compe.source.nvim_lsp      = v:true
let g:compe.source.treesitter    = v:true
let g:compe.source.omni          = v:false
let g:compe.source.tags          = v:false
let g:compe.source.nvim_lua      = v:false
let g:compe.source.spell         = v:false
let g:compe.source.calc          = v:false
let g:compe.source.snippets_nvim = v:false

if has_key(g:plugs, 'lexima.vim')
    let g:lexima_no_default_rules = v:true
    call lexima#set_default_rules()
endif

" inoremap <silent><expr> <CR>  compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <F6>  compe#confirm("\<F6>")
inoremap <silent><expr> <C-Space> pumvisible() ? compe#close('<C-e>') : compe#complete()
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : ''
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : ''
xmap s <Plug>(vsnip-cut-text)
smap <Backspace> a<Backspace>

imap <silent><expr> <Tab> pumvisible() ?
        \   (complete_info()["selected"] == "-1" ? "\<F6>" : "\<F6>") :
        \   (vsnip#available(1) ? "\<plug>(vsnip-expand-or-jump)" : "\<TAB>")

" Tailwind omni completion {{{

au FileType html,javascriptreact,typescriptreact
    \ let g:compe.source.omni = v:true
    \ | set omnifunc=TailwindOmni
    \ | call compe#setup(g:compe, 0)

" TODO: replace filread by opening a nonlisted buffer and placing contents
"       into it. this way fileread is not called all time

function g:TailwindOmni(findstart, base)
  if a:findstart
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\k'
      let start -= 1
    endwhile
    return start
  else
    return filter(readfile('/home/breno/.config/nvim/dict/tailwind'), 
        \ { _,s -> !match(s, '^' . a:base) })
  endif
endfun

"}}}
