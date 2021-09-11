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
    inoremap jk          <C-[>l
    inoremap kj          <C-[>l
]]

local actions = [[
    nnoremap g]        mzo<C-[>0D`z
    nnoremap g[        mzO<C-[>0D`z
    xmap     ge        :EasyAlign<cr>
    nmap     ge        :EasyAlign<cr>
    xnoremap gs        <cmd>lua u.substitute()<cr>
    nnoremap gs        <cmd>lua u.substitute()<cr>
    nnoremap gy        <cmd>lua require('gitlinker').get_buf_range_url('n', {action_callback = require"gitlinker.actions".open_in_browser})<cr>
    xnoremap gy        :lua require('gitlinker').get_buf_range_url('v', {action_callback = require"gitlinker.actions".open_in_browser})<cr>
    nnoremap qf        <cmd>lua u.qf_global()<CR>
    nnoremap qv        <cmd>lua u.qf_vglobal()<CR>
    nnoremap qp        <cmd>lua u.colder()<CR>
    nnoremap qn        <cmd>lua u.cnewer()<CR>
    nnoremap <leader># <cmd>source %<cr>
    nnoremap <leader>! <cmd>lua u.spawn_terminal()<cr>
    nnoremap <leader>m <cmd>make<cr>
    nnoremap <leader>/ <cmd>call quickfix#global_grep()<cr>
    xnoremap <leader>/ <cmd>call quickfix#global_grep()<cr>
    nnoremap <leader>* <cmd>call quickfix#global_star()<cr>
    xnoremap <leader>* <cmd>call quickfix#global_star()<cr>
    xnoremap g=         :Neoformat<cr>
    nnoremap <leader>=  :Neoformat<cr>
    nnoremap <leader>p  <Plug>RestNvim
]]

local movement = [[
    nnoremap ]t            :tabnext<cr>
    nnoremap [t            :tabprev<cr>
    nnoremap ]a            :next<cr>
    nnoremap [a            :previous<cr>
    nnoremap ]b            :bnext<cr>
    nnoremap [b            :bprevious<cr>
    nnoremap ]f            <cmd>lua u.fnext()<cr>
    nnoremap [f            <cmd>lua u.fprev()<cr>
    nnoremap ]c            <cmd>lua u.hnext()<cr>
    nnoremap [c            <cmd>lua u.hprev()<cr>
    nnoremap ]q            <cmd>lua u.cnext()<cr>
    nnoremap [q            <cmd>lua u.cprev()<cr>
    nnoremap ]l            <cmd>lua u.lnext()<cr>
    nnoremap [l            <cmd>lua u.lprev()<cr>
]]

vim.cmd([[
  au OptionSet diff if v:option_new ==# 'diff' | nunmap ]c | nunmap [c | endif
]])

local bufwintabs = [[
    "nnoremap <tab>   :tabnext<cr>
    "nnoremap <s-tab> :tabprevious<cr>
    nnoremap  <C-w>t  :tabnew<CR>
    nnoremap  <C-w>e  :enew<CR>
    nnoremap  <c-w>m  <cmd>lua u.maximize()<cr>
    nmap      <leader>w   <c-w>
]]

local toggles = [[
  nnoremap ´         <cmd>lua u.lf()<cr>
  nnoremap <leader>' <cmd>lua u.terminal()<cr>
  nnoremap <leader>n <cmd>lua u.ntree()<cr>
  nnoremap <leader>l <cmd>lua u.gtree()<cr>
  nnoremap <leader>q <cmd>lua u.copen()<cr>
  nnoremap <leader>e <cmd>lua u.diagnostics()<cr>
  nnoremap <leader>q <cmd>lua u.quickfix()<cr>
  nnoremap <leader>t <cmd>lua u.tagbar()<cr>
  nnoremap <leader>z <cmd>lua u.zen()<cr>
]]

local find = [[
  nnoremap <leader><leader> :Telescope<cr>
  nnoremap <leader>fb :Telescope buffers<cr>
  nnoremap <leader>f. :Telescope find_files<cr>
  nnoremap <leader>fh :Telescope help_tags<cr>
  nnoremap <leader>f' :Telescope marks<cr>
  nnoremap <leader>fc :Telescope oldfiles<cr>
  nnoremap <leader>ff :Telescope git_files<cr>
  nnoremap <leader>fp <cmd>lua u.projects()<cr>
  nnoremap <leader>f* <cmd>lua u.grep_string()<cr>
  nnoremap <leader>f~ <cmd>lua u.home_files()<cr>
  nnoremap <leader>f/ <cmd>lua u.live_grep()<cr>
]]

local git = [[
   nnoremap <leader>gg <cmd>lua u.fugitive()<cr>
   nnoremap <leader>gv <cmd>lua u.gv()<cr>
   nnoremap <leader>gd <cmd>lua u.diff()<cr>
   nnoremap <leader>gs <cmd>lua u.stage_hunk()<cr>
   nnoremap <leader>gu <cmd>lua u.undo_stage_hunk()<cr>
   nnoremap <leader>gr <cmd>lua u.reset_hunk()<cr>
   nnoremap <leader>gp <cmd>lua u.preview_hunk()<cr>
   nnoremap <leader>gb <cmd>lua u.blame_line()<cr>
   nnoremap <leader>gB <cmd>lua u.blame()<cr>
]]

local lsp = [[
    nnoremap <buffer> <C-]> <cmd>lua vim.lsp.buf.definition()<cr>
    nnoremap <buffer> gd    <cmd>lua vim.lsp.buf.declaration()<cr>
    nnoremap <buffer> gr    <cmd>lua vim.lsp.buf.references()<cr>
    nnoremap <buffer> gi    <cmd>lua vim.lsp.buf.implementation()<cr>
    nnoremap <buffer> gy    <cmd>lua vim.lsp.buf.type_definition()<cr>

    nnoremap <buffer> <leader>fs :Telescope lsp_document_symbols<cr>
    nnoremap <buffer> <leader>fw :Telescope lsp_dynamic_workspace_symbols<cr>
    nnoremap <buffer> <leader>fi <cmd>lua vim.lsp.buf.incoming_calls()<cr>
    nnoremap <buffer> <leader>fo <cmd>lua vim.lsp.buf.outgoing_calls()<cr>

    nnoremap <buffer> <leader>r  <cmd>lua vim.lsp.buf.rename()<cr>
    nnoremap <buffer> <leader>a  <cmd>lua vim.lsp.buf.code_action()<cr>
    xnoremap <buffer> <leader>a  <cmd>lua vim.lsp.buf.range_code_action()<cr>

    nnoremap <buffer> ]e         <cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<cr>
    nnoremap <buffer> [e         <cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<cr>
    nnoremap <buffer> <c-k>      <cmd>lua require('lspsaga.hover').render_hover_doc()<cr>
    nnoremap <buffer> <c-p>      <cmd>lua require('lspsaga.provider').preview_definition()<cr>
    nnoremap <silent> <C-f>      <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
    nnoremap <silent> <C-b>      <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
]]

local complete = [[
  inoremap <silent><expr> <C-Space> pumvisible() ? compe#close() : compe#complete()
  inoremap <silent><expr> <TAB>     compe#confirm({'keys': '<TAB>', 'select': v:true})
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-b>     compe#scroll({ 'delta': -4 })
  smap <Backspace> a<Backspace>
]]

local snippets = require('paq').list()["LuaSnip"] and [[
  inoremap <silent> <C-k> <cmd>lua require'luasnip'.jump(1)<Cr>
  inoremap <silent> <C-j> <cmd>lua require'luasnip'.jump(-1)<Cr>
  vnoremap <silent> <C-k> <cmd>lua require('luasnip').jump(1)<Cr>
  vnoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<Cr>
]] or [[
  imap <expr> <C-k> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : ''
  smap <expr> <C-k> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : ''
  imap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : ''
  smap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : ''
  " xmap s   <Plug>(vsnip-cut-text)
  " nmap s   v<Plug>(vsnip-cut-text)
]]

local trouble = [[

-- movements
]]

vim.cmd(defaults)
vim.cmd(actions)
vim.cmd(movement)
vim.cmd(bufwintabs)
vim.cmd(find)
vim.cmd(toggles)
vim.cmd(git)
vim.cmd(complete)
vim.cmd(snippets)

local M = {}

function M.register_lsp() vim.cmd(lsp) end

function M.register_trouble() vim.cmd(trouble) end

-- vim.api.nvim_set_keymap('n','<leader><tab>', [[<cmd>lua u.hello()<cr>]],  { noremap = true, silent = true })

return M
