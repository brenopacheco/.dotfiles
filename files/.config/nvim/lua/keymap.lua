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
    nnoremap !           <cmd>lua utils.spawn_terminal()<cr>
]]

local actions = [[
    nnoremap ]<space>  mzo<C-[>0D`z
    nnoremap [<space>  mzO<C-[>0D`z
    inoremap jk        <C-[>l
    inoremap kj        <C-[>l
    nmap     ""        ^v$hS"
    xmap     ge        :EasyAlign<cr>
    nmap     ge        :EasyAlign<cr>
    nnoremap g#        <cmd>source %<cr>
    nnoremap gm        <cmd>make<cr>
    xnoremap gs        <cmd>lua utils.substitute()<cr>
    nnoremap gs        <cmd>lua utils.substitute()<cr>
    nnoremap qf        <cmd>lua utils.qf_global()<CR>
    nnoremap qv        <cmd>lua utils.qf_vglobal()<CR>
    nnoremap qp        <cmd>lua utils.qf_colder()<CR>
    nnoremap qn        <cmd>lua utils.qf_cnewer()<CR>
]]

local movement = [[
    nnoremap ]s            :tag<cr>
    nnoremap [s            :pop<cr>
    nnoremap ]t            :tnext<cr>
    nnoremap [t            :tprevious<cr>
    nnoremap ]a            :next<cr>
    nnoremap [a            :previous<cr>
    nnoremap ]b            :bnext<cr>
    nnoremap [b            :bprevious<cr>
    nnoremap ]f            <cmd>lua utils.next_file()<cr>
    nnoremap [f            <cmd>lua utils.prev_file()<cr>
    nnoremap ]g            <cmd>lua utils.next_gitfile()<cr>
    nnoremap [g            <cmd>lua utils.prev_gitfile()<cr>
    nnoremap ]c            <cmd>lua utils.next_hunk()<cr>
    nnoremap [c            <cmd>lua utils.prev_hunk()<cr>
    nnoremap ]q            <cmd>lua utils.next_qf()<cr>
    nnoremap [q            <cmd>lua utils.prev_qf()<cr>
    nnoremap ]l            <cmd>lua utils.next_ll()<cr>
    nnoremap [l            <cmd>lua utils.prev_ll()<cr>
]]

local bufwintabs = [[
    nnoremap <tab>         :tabnext<cr>
    nnoremap <s-tab>       :tabprevious<cr>
    nnoremap <C-w>t        :tabnew<CR>
    nnoremap <C-w>e        :enew<CR>
    nnoremap <C-w>m        <C-W>_<C-W>\|
    nmap     <leader>w     <c-w>
]]

local toggles = [[
  nnoremap <leader>´ :Lf<cr>
  nnoremap <leader>' :Terminal<cr>
  nnoremap <leader>n :NvimTree<cr>
  nnoremap <leader>q :Quickfix<cr>
  nnoremap <leader>l :Loclist<cr>
  nnoremap <leader>t :SymbolsOutline<cr>
  nnoremap <leader>z :ZenMode<cr>
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

   " nnoremap hs :HunkStage<cr>
   " vnoremap hs :HunkStage<cr>
   " nnoremap hu :HunkUnstage<cr>
   " nnoremap hr :HunkReset<cr>
   " vnoremap hr :HunkReset<cr>
   " nnoremap hp :HunkPreview<cr>
   " nnoremap hb :HunkBlame<cr>

   " nnoremap hs <cmd>lua require"gitsigns".stage_hunk()<cr>
   " vnoremap hs <cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>
   " nnoremap hu <cmd>lua require"gitsigns".undo_stage_hunk()<cr>
   " nnoremap hr <cmd>lua require"gitsigns".reset_hunk()<cr>
   " vnoremap hr <cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>
   " nnoremap hp <cmd>lua require"gitsigns".preview_hunk()<cr>
   " nnoremap hb <cmd>lua require"gitsigns".blame_line(true)<cr> // fugitive?
]]

local lsp = [[
    nnoremap <buffer> <C-]>     :Telescope lsp_definitions<cr>
    nnoremap <buffer> <leader>r :Telescope lsp_references<cr>
    nnoremap <buffer> <leader>a :Telescope lsp_code_actions<cr>
    xnoremap <buffer> <leader>a :Telescope lsp_range_code_actions<cr>
    nnoremap <buffer> <leader>i :Telescope lsp_implementations<cr>
    nnoremap <buffer> <leader>o :Telescope lsp_document_symbols<cr>
    nnoremap <buffer> <leader>s :Telescope lsp_dynamic_workspace_symbols<cr>

    " nnoremap <buffer> <C-]>     <cmd>lua vim.lsp.goto_definition()<cr>
    " nnoremap <buffer> gr        <cmd>lua vim.lsp.buf.references()<cr>
    " nnoremap <buffer> <leader>a <cmd>lua vim.lsp.buf.code_action()<cr>
    " xnoremap <buffer> <leader>a :<c-u>lua vim.lsp.buf.range_code_action()<cr>
    " nnoremap <buffer> g*        <cmd>lua vim.lsp.buf.workspace_symbol(vim.fn.expand('<cword>'))<cr>
    " nnoremap <buffer> gd        <cmd>lua vim.lsp.buf.declaration()<cr>

    " nnoremap <buffer> gi        <cmd>lua vim.lsp.buf.implementation()<cr>
    " nnoremap <buffer> gI        <cmd>lua vim.lsp.buf.incoming_calls()<cr>
    " nnoremap <buffer> go        <cmd>lua vim.lsp.buf.outgoing_calls()<cr>
    " nnoremap <buffer> gy        <cmd>lua vim.lsp.buf.type_definition()<cr>

    nnoremap <buffer> ==        :Format<cr>
    nnoremap <buffer> ]e        :DiagnosticNext<cr>
    nnoremap <buffer> [e        :DiagnosticPrev<cr>
    nnoremap <buffer> <c-k>     :Hover<cr>
    nnoremap <buffer> <leader>e :Diagnostics<cr>
    nnoremap <buffer> gr        :Rename<cr>
    "nnoremap <buffer> ==        <cmd>lua utils.format()<cr>
    " nnoremap <buffer> ]e        <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
    " nnoremap <buffer> [e        <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
    " nnoremap <buffer> <c-k>     <cmd>lsp vim.lsp.buf.hover()<cr>
    " nnoremap <buffer> <leader>e <cmd>lua vim.lsp.diagnostic.set_loclist()<cr>
    " nnoremap <buffer> gr        <cmd>lua vim.lsp.buf.rename()<cr>
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
