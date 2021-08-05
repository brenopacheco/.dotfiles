-- 3. verificar which key
-- 4. apply all mappings but complete and lsp

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
    nnoremap !           <cmd>lua utils.spawn_terminal()<cr>
    inoremap jk          <C-[>l
    inoremap kj          <C-[>l
]]

local actions = [[
    nnoremap g]        mzo<C-[>0D`z
    nnoremap g[        mzO<C-[>0D`z
    nmap     g"        ^v$hS"
    xmap     ge        :EasyAlign<cr>
    nmap     ge        :EasyAlign<cr>
    nnoremap g#        <cmd>source %<cr>
    nnoremap gm        <cmd>make<cr>
    xnoremap gs        <cmd>lua utils.substitute()<cr>
    nnoremap gs        <cmd>lua utils.substitute()<cr>
    nnoremap qf        <cmd>lua utils.qf_global()<CR>
    nnoremap qv        <cmd>lua utils.qf_vglobal()<CR>
    nnoremap qp        <cmd>lua utils.colder()<CR>
    nnoremap qn        <cmd>lua utils.cnewer()<CR>
]]


--  nnoremap ]s            :tag<cr>
--  nnoremap [s            :pop<cr>
--  nnoremap ]t            :tnext<cr>
--  nnoremap [t            :tprevious<cr>
local movement = [[
    nnoremap ]t            :tabnext<cr>
    nnoremap [t            :tabprev<cr>
    nnoremap ]a            :next<cr>
    nnoremap [a            :previous<cr>
    nnoremap ]b            :bnext<cr>
    nnoremap [b            :bprevious<cr>
    nnoremap ]f            <cmd>lua utils.fnext()<cr>
    nnoremap [f            <cmd>lua utils.fprev()<cr>
    nnoremap ]g            <cmd>lua utils.gfnext()<cr>
    nnoremap [g            <cmd>lua utils.gfprev()<cr>
    nnoremap ]c            <cmd>lua utils.hnext()<cr>
    nnoremap [c            <cmd>lua utils.hprev()<cr>
    nnoremap ]q            <cmd>lua utils.cnext()<cr>
    nnoremap [q            <cmd>lua utils.cprev()<cr>
    nnoremap ]l            <cmd>lua utils.lnext()<cr>
    nnoremap [l            <cmd>lua utils.lprev()<cr>
]]

local bufwintabs = [[
    "nnoremap <tab>   :tabnext<cr>
    "nnoremap <s-tab> :tabprevious<cr>
    nnoremap  <C-w>t  :tabnew<CR>
    nnoremap  <C-w>e  :enew<CR>
    nnoremap  <c-w>m  <c-w>_<c-w>\|
    nmap      ,       <c-w>
]]

local toggles = [[
  nnoremap <leader>´ <cmd>lua utils.lf()<cr>
  nnoremap <leader>' <cmd>lua utils.terminal()<cr>
  nnoremap <leader>n <cmd>lua utils.tree()<cr>
  nnoremap <leader>q <cmd>lua utils.copen()<cr>
  nnoremap <leader>l <cmd>lua utils.lopen()<cr>
  nnoremap <leader>t <cmd>lua utils.tagbar()<cr>
  nnoremap <leader>z <cmd>lua utils.zenmode()<cr>
]]

local find = [[
  nnoremap <leader><leader> :Telescope<cr>
  nnoremap <leader>b :Telescope buffers<cr>
  nnoremap <leader>. :Telescope find_files<cr>
  nnoremap <leader>f :Telescope project_files<cr>
  nnoremap <leader>g :Telescope git_files<cr>
  nnoremap <leader>* :Telescope grep_string<cr>
  nnoremap <leader>h :Telescope help_tags<cr>
  nnoremap <leader>~ :Telescope home_files<cr>
  nnoremap <leader>/ :Telescope live_grep<cr>
  nnoremap <leader>' :Telescope marks<cr>
  nnoremap <leader>m :Telescope make_targets<cr>
  nnoremap <leader>p :Telescope projects<cr>
  nnoremap <leader>c :Telescope oldfiles<cr>
]]

local git =  [[
   " nnoremap hs <cmd>lua require("gitsigns").stage_hunk()<cr>
   " vnoremap hs <cmd>lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>
   " nnoremap hu <cmd>lua require("gitsigns").undo_stage_hunk()<cr>
   " nnoremap hr <cmd>lua require("gitsigns").reset_hunk()<cr>
   " vnoremap hr <cmd>lua require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>
   " nnoremap hp <cmd>lua require("gitsigns").preview_hunk()<cr>
   " nnoremap hb <cmd>lua require("gitsigns").blame_line(true)<cr> // fugitive?
]]

local lsp = [[
    nnoremap <buffer> <C-]>     :Telescope lsp_definitions<cr>
    nnoremap <buffer> <leader>r :Telescope lsp_references<cr>
    nnoremap <buffer> <leader>a :Telescope lsp_code_actions<cr>
    xnoremap <buffer> <leader>a :Telescope lsp_range_code_actions<cr>
    nnoremap <buffer> <leader>i :Telescope lsp_implementations<cr>
    nnoremap <buffer> <leader>o :Telescope lsp_document_symbols<cr>
    nnoremap <buffer> <leader>s :Telescope lsp_dynamic_workspace_symbols<cr>

    nnoremap <buffer> <leader>d <cmd>lua vim.lsp.buf.declaration()<cr>
    nnoremap <buffer> <leader>I <cmd>lua vim.lsp.buf.incoming_calls()<cr>
    nnoremap <buffer> <leader>O <cmd>lua vim.lsp.buf.outgoing_calls()<cr>
    nnoremap <buffer> <leader>y <cmd>lua vim.lsp.buf.type_definition()<cr>

    nnoremap <buffer> ==        <cmd>lua utils.format()<cr>
    nnoremap <buffer> ]e        <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
    nnoremap <buffer> [e        <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
    nnoremap <buffer> <c-k>     <cmd>lsp vim.lsp.buf.hover()<cr>
    nnoremap <buffer> <leader>e <cmd>lua vim.lsp.diagnostic.set_loclist()<cr>
    nnoremap <buffer> gr        <cmd>lua vim.lsp.buf.rename()<cr>
]]


local complete = [[
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

vim.cmd(defaults)
vim.cmd(actions)
vim.cmd(movement)
vim.cmd(bufwintabs)
vim.cmd(find)
vim.cmd(toggles)
vim.cmd(git)
vim.cmd(complete)

local M = {}

function M.register_lsp()
  vim.cmd(lsp)
end

return M
