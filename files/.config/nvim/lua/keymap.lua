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
    snoremap jk          <ESC>
    snoremap kj          <ESC>
    nnoremap q<leader>   q:
    "nnoremap q<leader>   <cmd>lua u.toggle_cmdline()<cr>
    nnoremap <leader><leader> :
    "nnoremap <Tab>      <cmd>lua u.org_tab()<cr>
    "nnoremap <S-Tab>    <cmd>lua u.org_untab()<cr>
    vnoremap <C-p>       dkP1v
    vnoremap <C-n>       dp1v
    nnoremap <C-p>       ddkP
    nnoremap <C-n>       ddp
    nnoremap <leader>Q   :qa<cr>
]]

local actions = [[
    nnoremap g]         mzo<C-[>0D`z
    nnoremap g[         mzO<C-[>0D`z
    xmap     ga         :EasyAlign<cr>
    nmap     ga         :EasyAlign<cr>
    nnoremap gy         <cmd>lua require('gitlinker').get_buf_range_url('n', {action_callback = require"gitlinker.actions".open_in_browser})<cr>
    xnoremap gy         :lua require('gitlinker').get_buf_range_url('v', {action_callback = require"gitlinker.actions".open_in_browser})<cr>
    nnoremap qf         <cmd>lua u.qf_global()<CR>
    nnoremap qv         <cmd>lua u.qf_vglobal()<CR>
    nnoremap qp         <cmd>lua u.colder()<CR>
    nnoremap qn         <cmd>lua u.cnewer()<CR>
    nnoremap <leader>#  <cmd>source %<cr>
    nnoremap <leader>!  <cmd>lua u.spawn_terminal()<cr>
    "nnoremap <leader>m  <cmd>make<cr>
    nnoremap <leader>m   <cmd>lua require('utils.picker').npm()<cr>
    nnoremap <leader>/  <cmd>call quickfix#global_grep2()<cr>
    nnoremap <leader>*  <cmd>call quickfix#global_star()<cr>
    xnoremap <leader>*  <cmd>call quickfix#global_star()<cr>
    xnoremap g=         :Neoformat<cr>
    nnoremap <leader>=  :Neoformat<cr>
    nnoremap <leader>pi :PaqInstall<cr>
    nnoremap <leader>pu :PaqUpdate<cr>
    nnoremap <leader>pc :PaqClean<cr>
    nnoremap <leader>pl :PaqList<cr>
    xnoremap <leader>s  <cmd>lua u.substitute()<cr>
    nnoremap <leader>s  <cmd>lua u.substitute()<cr>
    nmap <leader>p      <Plug>RestNvim <Plug>RestNvimPreview
    nnoremap gx         <cmd>lua u.open_url()<cr>
    xnoremap gx         <cmd>lua u.open_url()<cr>
    nnoremap <leader>i  <cmd>Neogen<cr>
]]

local movement = [[
    nnoremap ]a            <cmd>lua u.next()<cr>
    nnoremap [a            <cmd>lua u.prev()<cr>
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
    nnoremap ]'            :FloatermNext<cr>
    nnoremap ['            :FloatermPrev<cr>
]]

vim.cmd([[
  au OptionSet diff if v:option_new ==# 'diff' | nunmap ]c | nunmap [c | endif
]])

local bufwintabs = [[
    nnoremap  <C-w>t  :tabnew<CR>
    nnoremap  <C-w>e  :enew<CR>
    nnoremap  <c-w>m  <cmd>lua u.maximize()<cr>
    nmap      <leader>w   <c-w>
]]

local toggles = [[
  nnoremap ´         <cmd>lua u.lf()<cr>
  nnoremap <leader>' <cmd>FloatermToggle<cr>
  nnoremap <leader>" <cmd>FloatermNew<cr>
  nnoremap <leader>n <cmd>lua u.ntree()<cr>
  nnoremap <leader>l <cmd>lua u.gtree()<cr>
  nnoremap <leader>e <cmd>lua u.diagnostics(0)<cr>
  nnoremap <leader>E <cmd>lua u.diagnostics()<cr>
  nnoremap <leader>q <cmd>lua u.quickfix()<cr>
  nnoremap <leader>t <cmd>lua u.tagbar()<cr>
  nnoremap <leader>z <cmd>lua u.zen()<cr>
  nnoremap <leader><tab> <cmd> lua u.toggle_scrolloff()<cr>
]]

local find = [[
  nnoremap <leader>f? :Telescope<cr>
  nnoremap <leader>fb :Telescope buffers<cr>
  nnoremap <leader>f. :Telescope find_files<cr>
  nnoremap <leader>fh :Telescope help_tags<cr>
  nnoremap <leader>f' :Telescope marks<cr>
  nnoremap <leader>fc :Telescope oldfiles<cr>
  nnoremap <leader>ff <cmd>lua u.files(true)<cr>
  nnoremap <leader>fg <cmd>lua u.files()<cr>
  nnoremap <leader>fp <cmd>lua u.projects()<cr>
  nnoremap <leader>fl <cmd>lua require('utils.picker').lua()<cr>
  "nnoremap <leader>fs <cmd>lua u.stash()<cr>
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
   nnoremap <leader>gb <cmd>Telescope git_branches<cr>
   nnoremap <leader>gB <cmd>lua u.blame()<cr>
   nnoremap <leader>g2 :diffget //2<CR>
   nnoremap <leader>g3 :diffget //3<CR>
]]

local lsp = [[
    " GOTOS <AWORD>
    nnoremap <buffer> <C-]> <cmd>lua vim.lsp.buf.definition()<cr>
    nnoremap <buffer> gd    <cmd>lua vim.lsp.buf.declaration()<cr>
    nnoremap <buffer> gr    <cmd>lua vim.lsp.buf.references()<cr>
    nnoremap <buffer> gi    <cmd>lua vim.lsp.buf.implementation()<cr>
    nnoremap <buffer> gy    <cmd>lua vim.lsp.buf.type_definition()<cr>
    nnoremap <buffer> gI    <cmd>lua vim.lsp.buf.incoming_calls()<cr>
    nnoremap <buffer> gO    <cmd>lua vim.lsp.buf.outgoing_calls()<cr>

    " FINDS
    nnoremap <buffer> <leader>fo <cmd>Telescope lsp_document_symbols<cr>
    nnoremap <buffer> <leader>fs <cmd>Telescope lsp_dynamic_workspace_symbols<cr>

    " ACTIONS
    nnoremap <buffer> <leader>r  <cmd>lua vim.lsp.buf.rename()<cr>
    nnoremap <buffer> <leader>a  <cmd>lua vim.lsp.buf.code_action()<cr>
    xnoremap <buffer> <leader>a  <cmd>lua vim.lsp.buf.range_code_action()<cr>

    " JUMPS
    nnoremap <buffer> ]e         <cmd>lua vim.diagnostic.goto_next()<cr>
    nnoremap <buffer> [e         <cmd>lua vim.diagnostic.goto_prev()<cr>

    " INFO
    nnoremap <buffer> <c-k>      <cmd>lua vim.lsp.buf.hover()<cr>
    nnoremap <buffer> <c-p>      <cmd>lua vim.lsp.buf.peek_definition()<cr>
]]

local complete = [[
  inoremap <silent><expr> <C-Space> pumvisible() ? compe#close() : compe#complete()
  inoremap <silent><expr> <TAB>     compe#confirm({'keys': '<TAB>', 'select': v:true})
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-b>     compe#scroll({ 'delta': -4 })
  smap <Backspace> a<Backspace>
]]


local luasnip = [[
  inoremap <silent> <C-k> <cmd>lua require'luasnip'.jump(1)<Cr>
  inoremap <silent> <C-j> <cmd>lua require'luasnip'.jump(-1)<Cr>
  vnoremap <silent> <C-k> <cmd>lua require('luasnip').jump(1)<Cr>
  vnoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<Cr>
]]


local snippets = [[
  imap <expr> <C-k> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : ''
  smap <expr> <C-k> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : ''
  imap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : ''
  smap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : ''
  xmap s   <Plug>(vsnip-cut-text)
]]

local args = [[
  " fix wrapping issue
  nnoremap ++        <cmd>lua u.argadd()<cr>
  nnoremap --        <cmd>lua u.argdelete()<cr>
  nnoremap <leader>+ <cmd>lua u.args()<cr>
]]

local dap = [[
  nnoremap <leader>d> <cmd>lua require('dap').continue()<cr>
  nnoremap <leader>d< <cmd>lua require('dap').reverse_continue()<cr>
  nnoremap <leader>d. <cmd>lua require('dap').run_to_cursor()<cr>

  nnoremap <leader>dr <cmd>lua require('dap').run_last()<cr>
  nnoremap <leader>dd <cmd>lua require('utils/dap').toggle_debug()<cr>

  nnoremap <leader>di <cmd>lua require('dap').set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>
  nnoremap <leader>db <cmd>lua require('dap').toggle_breakpoint()<cr>
  nnoremap <leader>dq <cmd>lua require('dap').list_breakpoints()<cr>
  nnoremap <leader>dc <cmd>lua require('dap').clear_breakpoints()<cr>
  nnoremap <leader>ds <cmd>lua require('dap').pause(vim.fn.input("Thread id: "))<cr>

  nnoremap <leader>dl <cmd>lua require('dap').step_over()<cr>
  nnoremap <leader>dj <cmd>lua require('dap').step_into()<cr>
  nnoremap <leader>dk <cmd>lua require('dap').step_out()<cr>
  nnoremap <leader>dh <cmd>lua require('dap').step_back()<cr>
  nnoremap <leader>dp <cmd>lua require('dap').up()<cr>
  nnoremap <leader>dn <cmd>lua require('dap').down()<cr>

  nnoremap <leader>dt <cmd>lua require('dap').repl.toggle()<cr>
  nnoremap <leader>dK <cmd>lua require('dapui').eval()<CR>
  nnoremap <leader>du <cmd>lua require('dapui').toggle()<cr>
  nnoremap <leader>da <cmd>lua require('utils/dap').attach()<cr>
  nnoremap <leader>dL <cmd>lua require('utils/dap').open_log()<cr>
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
vim.cmd(args)
vim.cmd(dap)

local M = {}

function M.register_lsp() vim.cmd(lsp) end

return M
