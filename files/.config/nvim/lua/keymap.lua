-- 1. decidir o mapeamento
-- 2. definir como vai ser executado
--  2.1 como pode ser attached pelo lsp
-- 3. verificar which key
--
-- apply all mappings but complete and lsp
-- lsp is applied on buf attach

local defaults = [[
    nnoremap Y           :norm v$hy<cr>
    nnoremap Q           <Nop>
    xnoremap p           pgvy
    xnoremap <expr>p     'pgv"'.v:register.'y`>'
    xnoremap <           <gv
    xnoremap >           >gv
    nnoremap >           >>
    nnoremap <           <<
    xnoremap *           "zy/\V<C-r>=escape(@z, '\/')<cr><cr>
    nnoremap           :nohlsearch<cr>
    nnoremap #           :b #<cr>
]]

local actions = [[
    nnoremap ]<space>  mzo<C-[>0D`z
    nnoremap [<space>  mzO<C-[>0D`z
    inoremap jk        <C-[>l
    inoremap kj        <C-[>l
    nmap     ""        ^v$hS"
    xmap     ga        <cmd>EasyAlign<cr>
    nmap     ga        <cmd>EasyAlign<cr>
    nnoremap <leader># <cmd>source %<cr>
    nnoremap <leader>m <cmd>make<cr>
    xnoremap <leader>s <cmd>lua    utils.substitute()<cr>
    nnoremap <leader>s <cmd>lua    utils.substitute()<cr>
    nnoremap <leader>! <cmd>lua    utils.spawn_terminal()<cr>
]]

movement = [[
    nnoremap ]s :tag<cr>
    nnoremap [s :pop<cr>
    nnoremap ]t :tnext<cr>
    nnoremap [t :tprevious<cr>
    nnoremap ]a :next<cr>
    nnoremap [a :previous<cr>
    nnoremap ]b :bnext<cr>
    nnoremap [b :bprevious<cr>
    nnoremap ]l :lnext<cr>
    nnoremap [l :lprevious<cr>
    nnoremap ]f <cmd>lua utils.next_file()<cr>
    nnoremap [f <cmd>lua utils.prev_file()<cr>
    nnoremap ]c <cmd>lua utils.next_hunk()<cr>
    nnoremap [c <cmd>lua utils.prev_hunk()<cr>
    nnoremap ]q <cmd>lua utils.next_qf()<cr>
    nnoremap [q <cmd>lua utils.prev_qf()<cr>
    nnoremap ]q <cmd>lua utils.next_ll()<cr>
    nnoremap [q <cmd>lua utils.prev_ll()<cr>
    nnoremap <tab> :tnext
    nnoremap <s-tab> :tprevious
]]

window = [[
    nmap     <leader>w <C-W>
    nnoremap <C-w>t    :tabnew<CR>
    nnoremap <C-w>e    :enew<CR>
    nnoremap <C-w>m    <C-W>_<C-W>\|
    nnoremap T :tabnew<CR>
]]

toggles = [[
  nnoremap -- terminal
  nnoremap -- tree
  nnoremap -- quickfix
  nnoremap -- loclist
  nnoremap -- tags/symbols
  nnoremap -- git
  nnoremap -- full ide style
]]

find = [[
    nnoremap <leader>f~ <cmd>Files ~<CR>
    nnoremap <leader>f. <cmd>Files .<CR>
    nnoremap <leader>fg <cmd>GFiles?<CR>
    nnoremap <leader>fp <cmd>PFiles<CR>
    nnoremap <leader>ff <cmd>FFiles<CR>
    nnoremap <leader>fa <cmd>Args<CR>
    nnoremap <leader>fb <cmd>Buffers<CR>
    nnoremap <leader>f/ <cmd>Rg<CR>
    nnoremap <leader>f* <cmd>exec 'Rg ' . expand("<cword>")<CR>
    nnoremap <leader>fs <cmd>Tags<CR>
    nnoremap <leader>fo <cmd>BTags<CR>
    nnoremap <leader>fm <cmd>Marks<CR>
    nnoremap <leader>fr <cmd>History<CR>
    nnoremap <leader>f: <cmd>History:<CR>
    nnoremap <leader>fh <cmd>Helptags<CR>
    nnoremap <leader>fi <cmd>Snippets<CR>
]]

grep = [[
    xnoremap <leader>* <cmd>call quickfix#global_star2()<CR>
    nnoremap <leader>* <cmd>call quickfix#global_star2()<CR>
    nnoremap <leader>/ <cmd>call quickfix#global_grep2()<CR>
    xnoremap q*        <cmd>call quickfix#buffer_star()<CR>
    nnoremap q*        <cmd>call quickfix#buffer_star()<CR>
    nnoremap q/        <cmd>call quickfix#buffer_grep()<CR>
    nnoremap qf        <cmd>call quickfix#filter(input("QF/"))<CR>
    nnoremap qs        <cmd>call quickfix#source()<CR>
    nnoremap qp        <cmd>call quickfix#colder()<CR>
    nnoremap qn        <cmd>call quickfix#cnewer()<CR>
]]

git =  [[
  -- stage hunk
  -- unstage hunk
  -- reset hunk
  -- preview hunk
  -- toggle blame
  -- open fugitive
  -- open log
  -- show diffs
        -- ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        -- ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
        -- ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        -- ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        -- ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
        -- ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
        -- ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        -- ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
]]

lsp = [[
    nnoremap <C-]>     <cmd>call lsp#goto_definition()<CR>
    nnoremap  gd       <cmd>call lsp#goto_declaration()<CR>
    nnoremap  gr       <cmd>call lsp#goto_references()<CR>
    nnoremap  gi       <cmd>call lsp#goto_implementation()<CR>
    nnoremap  gy       <cmd>call lsp#goto_type_definition()<CR>
    nnoremap  go       <cmd>call lsp#goto_document_symbol()<CR>
    nnoremap  gs       <cmd>call lsp#goto_workspace_symbol()<CR>
    nnoremap <leader>= <cmd>call lsp#format()<CR>
    xnoremap <leader>= <cmd>call lsp#format()<CR>
    xnoremap =         <cmd>call lsp#format()<CR>
    nnoremap <leader>e <cmd>call lsp#toggle_diagnostics()<CR>
    nnoremap [e        <cmd>call lsp#goto_prev_diagnostic()<CR>
    nnoremap ]e        <cmd>call lsp#goto_next_diagnostic()<CR>
    nnoremap <leader>a <cmd>call lsp#code_action(v:false)<CR>
    vnoremap <leader>a :<c-u>call lsp#code_action(v:true)<CR>
    nnoremap <leader>r <cmd>call lsp#rename()<CR>
    inoremap <C-k>     <cmd>call lsp#show_help()<CR>
    nnoremap <C-k>     <cmd>call lsp#show_help()<CR>
    nnoremap <C-p>     <cmd>call lsp#show_definition()<CR>
    nnoremap <C-f>     <cmd>call lsp#scrolldown_hover()<CR>
    nnoremap <C-b>     <cmd>call lsp#scrollup_hover()<CR>
]]
complete = [[
  inoremap <silent><expr> <C-Space> pumvisible() ? compe#close() : compe#complete()
  inoremap <silent><expr> <TAB>     compe#confirm({'keys': '<TAB>', 'select': v:true})
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-b>     compe#scroll({ 'delta': -4 })
  smap <Backspace> a<Backspace>
  inoremap <silent> <C-k> <cmd>lua require'luasnip'.jump(1)<Cr>
  inoremap <silent> <C-j> <cmd>lua require'luasnip'.jump(-1)<Cr>
  vnoremap <silent> <C-k> <cmd>lua require('luasnip').jump(1)<Cr>
  vnoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<Cr>
  " xmap s <Plug>(vsnip-cut-text)
]]

local utils = require('utils')

-- utils.parse_map(lsp)

utils.map({
 defaults,
 actions,
 movement,
 toggles,
 window,
 find,
 grep,
 -- git,
 -- lsp
})

return lsp
