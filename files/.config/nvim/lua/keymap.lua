-- 3. verificar which key
-- 4. apply all mappings but complete and lsp
-- 4. apply all mappings but complete and lsp
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
    inoremap jk          <C-[>l
    inoremap kj          <C-[>l
]]

local actions = [[
    nnoremap g]        mzo<C-[>0D`z
    nnoremap g[        mzO<C-[>0D`z
    xmap     ge        :EasyAlign<cr>
    nmap     ge        :EasyAlign<cr>
    xnoremap gs        <cmd>lua utils.substitute()<cr>
    nnoremap gs        <cmd>lua utils.substitute()<cr>
    nnoremap qf        <cmd>lua utils.qf_global()<CR>
    nnoremap qv        <cmd>lua utils.qf_vglobal()<CR>
    nnoremap qp        <cmd>lua utils.colder()<CR>
    nnoremap qn        <cmd>lua utils.cnewer()<CR>
    nnoremap <leader>#   <cmd>source %<cr>
    nnoremap <leader>!   <cmd>lua utils.spawn_terminal()<cr>
    nnoremap <leader>m   <cmd>make<cr>
]]

local movement = [[
    nnoremap ]t            :tabnext<cr>
    nnoremap [t            :tabprev<cr>
    nnoremap ]a            :next<cr>
    nnoremap [a            :previous<cr>
    nnoremap ]b            :bnext<cr>
    nnoremap [b            :bprevious<cr>
    nnoremap ]f            <cmd>lua utils.fnext()<cr>
    nnoremap [f            <cmd>lua utils.fprev()<cr>
    nnoremap ]c            <cmd>lua utils.hnext()<cr>
    nnoremap [c            <cmd>lua utils.hprev()<cr>
    nnoremap ]q            <cmd>lua utils.cnext()<cr>
    nnoremap [q            <cmd>lua utils.cprev()<cr>
    nnoremap ]l            <cmd>lua utils.lnext()<cr>
    nnoremap [l            <cmd>lua utils.lprev()<cr>
]]

vim.cmd([[
  au OptionSet diff if v:option_new ==# 'diff' | nunmap ]c | nunmap [c | endif
]])

local bufwintabs = [[
    "nnoremap <tab>   :tabnext<cr>
    "nnoremap <s-tab> :tabprevious<cr>
    nnoremap  <C-w>t  :tabnew<CR>
    nnoremap  <C-w>e  :enew<CR>
    nnoremap  <c-w>m  <cmd>lua utils.maximize()<cr>
    nmap      <Del>   <c-w>
]]

local toggles = [[
"  nnoremap <leader>´ <cmd>lua utils.lf()<cr>
  nnoremap <leader>' <cmd>lua utils.terminal()<cr>
  nnoremap <leader>n <cmd>lua utils.tree()<cr>
  nnoremap <leader>q <cmd>lua utils.copen()<cr>
  nnoremap <leader>e <cmd>lua utils.diagnostics()<cr>
  nnoremap <leader>q <cmd>lua utils.quickfix()<cr>
  nnoremap <leader>t <cmd>lua utils.tagbar()<cr>
  nnoremap <leader>z <cmd>lua utils.zenmode()<cr>
]]

local find = [[
  nnoremap <leader><leader> :Telescope<cr>
  nnoremap <leader>fb :Telescope buffers<cr>
  nnoremap <leader>f. :Telescope find_files<cr>
  nnoremap <leader>ff :Telescope git_files<cr>
  nnoremap <leader>f* :Telescope grep_string cwd=utils#root()<cr>
  nnoremap <leader>fh :Telescope help_tags<cr>
  nnoremap <leader>f~ :Telescope home_files cwd=~<cr>
  nnoremap <leader>f/ :Telescope live_grep cwd=utils#root()<cr>
  nnoremap <leader>f' :Telescope marks<cr>
  " nnoremap <leader>fp :Telescope projects<cr>
  nnoremap <leader>fc :Telescope oldfiles<cr>
]]

local git = [[
   nnoremap <leader>gg <cmd>lua utils.fugitive<cr>
   nnoremap <leader>gv <cmd>lua utils.gv<cr>
   nnoremap <leader>gd <cmd>lua utils.diff<cr>
   nnoremap <leader>gs <cmd>lua utils.stage_hunk()<cr>
   nnoremap <leader>gu <cmd>lua utils.undo_stage_hunk()<cr>
   nnoremap <leader>gr <cmd>lua utils.reset_hunk()<cr>
   nnoremap <leader>gp <cmd>lua utils.preview_hunk()<cr>
   nnoremap <leader>gb <cmd>lua utils.blame_line(true)<cr>
]]

local lsp = [[
    nnoremap <buffer> <C-]>      :Telescope lsp_definitions<cr>
    nnoremap <buffer> <leader>fr :Telescope lsp_references<cr>
    nnoremap <buffer> <leader>fi :Telescope lsp_implementations<cr>
    nnoremap <buffer> <leader>fo :Telescope lsp_document_symbols<cr>
    nnoremap <buffer> <leader>fs :Telescope lsp_dynamic_workspace_symbols<cr>

    nnoremap <buffer> <leader>fd <cmd>lua vim.lsp.buf.declaration()<cr>
    nnoremap <buffer> <leader>fI <cmd>lua vim.lsp.buf.incoming_calls()<cr>
    nnoremap <buffer> <leader>fO <cmd>lua vim.lsp.buf.outgoing_calls()<cr>
    nnoremap <buffer> <leader>fy <cmd>lua vim.lsp.buf.type_definition()<cr>

    nnoremap <buffer> ga         :Telescope lsp_code_actions<cr>
    xnoremap <buffer> ga         :Telescope lsp_range_code_actions<cr>
    nnoremap <buffer> ]e         <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
    nnoremap <buffer> [e         <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
    nnoremap <buffer> <c-k>      <cmd>lua lsp vim.lsp.buf.hover()<cr>
    nnoremap <buffer> gr         <cmd>lua vim.lsp.buf.rename()<cr>
    nnoremap <buffer> g=         :Neoformat<cr>
    vnoremap <buffer> =          :Neoformat<cr>
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

local M = {}

function M.register_lsp() vim.cmd(lsp) end

function M.register_trouble() vim.cmd(trouble) end

-- vim.api.nvim_set_keymap('n','<leader><tab>', [[<cmd>lua utils.hello()<cr>]],  { noremap = true, silent = true })
-- will fix tab issue



return M
