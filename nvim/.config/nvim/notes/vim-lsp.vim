
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('/tmp/vim-lsp.log')
" let g:asyncomplete_log_file = expand('/tmp/asyncomplete.log')
let g:lsp_settings_servers_dir = expand('~/.cache/nvim/vim-lsp')

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <silent><buffer> <C-]>     <plug>(lsp-definition)
    nmap <silent><buffer> gd        <plug>(lsp-declaration)
    nmap <silent><buffer> gr        <plug>(lsp-references)
    nmap <silent><buffer> gi        <plug>(lsp-implementation)
    nmap <silent><buffer> gy        <plug>(lsp-type-definition)
    nmap <silent><buffer> go        <plug>(lsp-document-symbol)
    nmap <silent><buffer> gs        <plug>(lsp-workspace-symbol)
    nmap <silent><buffer> [e        <plug>(lsp-previous-diagnostic-nowrap)
    nmap <silent><buffer> ]e        <plug>(lsp-next-diagnostic-nowrap)
    nmap <silent><buffer> <leader>r <plug>(lsp-rename)
    nmap <silent><buffer> <leader>d <plug>(lsp-document-diagnostics)
    nmap <silent><buffer> <leader>a <plug>(lsp-code-action)
    nmap <silent><buffer> <leader>= <plug>(lsp-document-format)
    nmap <silent><buffer> =         <plug>(lsp-document-range-format)
    xmap <silent><buffer> =         <plug>(lsp-document-range-format)
    nmap <silent><buffer> <C-k>     <plug>(lsp-hover)<plug>(lsp-signature-help)<plug>(lsp-code-lens)
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_signs_enabled                = 1
let g:lsp_diagnostics_echo_cursor      = 1
let g:lsp_highlight_references_enabled = 1
let g:lsp_highlights_enabled           = 1
let g:lsp_textprop_enabled             = 1
let g:lsp_signs_error                  = {'text': '✗'}
let g:lsp_signs_warning                = {'text': '‼'}
let g:lsp_signs_hint                   = {'text': '#'}
let g:lsp_virtual_text_prefix = " ‣ "
let g:lsp_highlights_enabled = 0

let g:servers = {
            \     'vim':        'vim-language-server',
            \     'c':          'clangd',
            \     'cpp':        'clangd',
            \     'json':       'json-languageserver',
            \     'typescript': 'typescript-language-server',
            \     'javascript': 'typescript-language-server'
            \ }
function! LspStatus() abort
    if has_key(g:servers, &ft)
        if lsp#get_server_status(g:servers[&ft]) == "running"
            let diagnostics = lsp#get_buffer_diagnostics_counts()
            return "E[" . diagnostics.error . "] W[" . diagnostics.warning . "] ✓"
        endif
    endif
    return ''
endfunction 

let g:vsnip_extra_mapping                        =  v:false
let g:vsnip_snippet_dir = expand('~/.config/nvim/snippets')
set completeopt=menuone,noinsert,noselect
imap <expr> <TAB>  
            \ pumvisible() ? 
            \     complete_info()["selected"] != "-1" ?
            \       asyncomplete#close_popup()  : 
            \       "\<C-n>\<F5>" :
            \   vsnip#jumpable(1) ? 
            \         "\<Plug>(vsnip-jump-next)" :
            \       "\<TAB>"
imap <F5> <TAB>
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
nmap <expr> <Tab>   vsnip#jumpable(1)  ? 'i<Plug>(vsnip-jump-next)' : '<Tab>'
nmap <expr> <S-Tab> vsnip#jumpable(1)  ? 'i<Plug>(vsnip-jump-prev)' : '<Tab>'
xmap s <Plug>(vsnip-cut-text)


au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#buffer#completor')
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'allowlist': ['*'],
    \ 'priority': 50,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

" au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
"     \ 'name': 'tags',
"     \ 'allowlist': ['*'],
"     \ 'completor': function('asyncomplete#sources#tags#completor')
"     \ }))



function! s:my_asyncomplete_preprocessor(options, matches) abort
    let l:visited = {}
    let l:items = []
    for [l:source_name, l:matches] in items(a:matches)
      for l:item in l:matches['items']
        if stridx(l:item['word'], a:options['base']) == 0
          if !has_key(l:visited, l:item['word'])
            call add(l:items, l:item)
            let l:visited[l:item['word']] = 1
          endif
        endif
      endfor
    endfor
    call sort(l:items, { a, b -> len(a.word) >= len(b.word) })
    call asyncomplete#preprocess_complete(a:options, l:items)
endfunction

let g:asyncomplete_preprocessor = [function('s:my_asyncomplete_preprocessor')]



