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
    "nnoremap #           :b #<cr>
    inoremap jk          <C-[>l
    inoremap kj          <C-[>l
    snoremap jk          <ESC>
    snoremap kj          <ESC>
    nnoremap <C-h> :exe printf('match lCursor /\V\%%(\<\k\*\%%#\k\*\>\)\@!\&\<%s\>/', escape(expand('<cword>'), '/\'))<cr>
		nnoremap <leader>D :diffthis<cr>
    "nnoremap } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>
    "nnoremap { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>
    nnoremap <leader><leader> :
    cnoremap <C-x> <C-w>
]]

-- TODO: diff toggle in leader D

local actions = [[
    nnoremap <leader>bd :bd!<cr>
    nnoremap <leader>bc :%bd\|e#<cr>
    xmap     ga         :EasyAlign<cr>
    nmap     ga         :EasyAlign<cr>
    nnoremap gy         <cmd>lua require('gitlinker').get_buf_range_url('n', {action_callback = require"gitlinker.actions".open_in_browser})<cr>
    xnoremap gy         :lua require('gitlinker').get_buf_range_url('v', {action_callback = require"gitlinker.actions".open_in_browser})<cr>
    nnoremap qf         <cmd>lua u.qf_global()<CR>
    nnoremap qp         <cmd>lua u.colder()<CR>
    nnoremap qn         <cmd>lua u.cnewer()<CR>
    nnoremap <leader>#  <cmd>source %<cr>
    nnoremap <leader>!  <cmd>lua u.spawn_terminal()<cr>
    nnoremap <leader>m  <cmd>lua require('util.picker').run()<cr>
    nnoremap <leader>/  <cmd>call quickfix#global_grep2()<cr>
    nnoremap <leader>*  <cmd>call quickfix#global_star()<cr>
    xnoremap <leader>*  <cmd>call quickfix#global_star()<cr>
    xnoremap g=         :Neoformat<cr>
    xnoremap <leader>=  :Neoformat<cr>
    nnoremap <leader>=  :Neoformat<cr>
    nnoremap <leader>pi :PaqInstall<cr>
    nnoremap <leader>pu :PaqUpdate<cr>
    nnoremap <leader>pc :PaqClean<cr>
    nnoremap <leader>pl :PaqList<cr>
    nnoremap <leader>po :PaqLogOpen<cr>
    xnoremap <leader>s  <cmd>lua u.substitute()<cr>
    nnoremap <leader>s  <cmd>lua u.substitute()<cr>
    nnoremap gx         <cmd>lua u.open_url()<cr>
    xnoremap gx         <cmd>lua u.open_url()<cr>
    nnoremap <leader>i  <cmd>Neogen<cr>
    nnoremap mc         <cmd>lua u.clearmarks()<cr>
    nnoremap <C-n>      <cmd>lua u.marks()<cr>
]]

local movement = [[
    nnoremap ]b            :bnext<cr>
    nnoremap [b            :bprevious<cr>
    nnoremap ]f            <cmd>lua u.fnext()<cr>
    nnoremap [f            <cmd>lua u.fprev()<cr>
    nnoremap ]c            <cmd>lua u.hnext()<cr>
    nnoremap [c            <cmd>lua u.hprev()<cr>
    nnoremap ]q            <cmd>lua u.cnext()<cr>
    nnoremap [q            <cmd>lua u.cprev()<cr>
    nnoremap ]Q            :clast<cr>
    nnoremap [Q            :cfirst<cr>
    nnoremap ]l            <cmd>lua u.lnext()<cr>
    nnoremap [l            <cmd>lua u.lprev()<cr>
    nnoremap ]'            :FloatermNext<cr>
    nnoremap ['            :FloatermPrev<cr>
]]

local test = [[
  nmap <silent> <leader>t. <cmd>TestNearest<CR>
  nmap <silent> <leader>tf <cmd>TestFile<CR>
  nmap <silent> <leader>ta :TestSuite<CR>
  nmap <silent> <leader>tp :TestLast<CR>
  nmap <silent> <leader>tc :TestVisit<CR>
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
  nnoremap ´             <cmd>lua u.lf()<cr>
  nnoremap -             <cmd>lua require("oil").open()<cr>
  nnoremap <leader>'     <cmd>FloatermToggle<cr>
  nnoremap <leader>"     <cmd>FloatermNew<cr>
  nnoremap <leader>n     <cmd>lua require('nvim-tree.api').tree.toggle({focus = false})<cr>
  "nnoremap <leader>l     <cmd>lua u.gtree()<cr>
  nnoremap <leader>e     <cmd>lua u.diagnostics(0)<cr>
  nnoremap <leader>E     <cmd>lua u.diagnostics()<cr>
  nnoremap <leader>q     <cmd>lua u.quickfix()<cr>
  nnoremap <leader><tab> <cmd>lua u.tagbar()<cr>
  "nnoremap <leader>z     <cmd>lua u.zen()<cr>
  nnoremap <leader>o     <cmd> lua u.toggle_scrolloff()<cr>
]]

local find = [[
  nnoremap <leader>f? :Telescope<cr>
  nnoremap <leader>fb :Telescope buffers<cr>
  nnoremap <leader>f. <cmd>lua require('telescope.builtin').find_files({cwd = vim.fn.getcwd(), hidden = true})<cr>
  nnoremap <leader>fh :Telescope help_tags<cr>
  nnoremap <leader>f' :Telescope marks<cr>
  nnoremap <leader>fc :Telescope oldfiles<cr>
  nnoremap <leader>ff <cmd>lua u.files(true)<cr>
  nnoremap <leader>fp <cmd>lua u.files()<cr>
  nnoremap <leader>fg :Telescope git_status<cr>
  nnoremap <leader>fl <cmd>lua require('util.picker').lua()<cr>
  nnoremap <leader>fd <cmd>lua require('util.picker').dotfiles()<cr>
  nnoremap <leader>f* <cmd>lua u.grep_string()<cr>
  nnoremap <leader>f~ <cmd>lua u.home_files()<cr>
  nnoremap <leader>f/ <cmd>lua u.live_grep()<cr>
  nnoremap <leader>fz <cmd>ZkNotes { sort = { 'modified' } }<cr>
]]

local git = [[
   nnoremap <leader>gg <cmd>lua u.fugitive()<cr>
   nnoremap <leader>gv <cmd>lua u.gv()<cr>
   nnoremap <leader>gl <cmd>Git log<cr>
   nnoremap <leader>gt <cmd>Telescope git_branches<cr>
   nnoremap <leader>gT <cmd>Twiggy<cr>
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
    "nnoremap <buffer> gO    <cmd>lua vim.lsp.buf.outgoing_calls()<cr>

    " FINDS
    nnoremap <buffer> <leader>fo <cmd>Telescope lsp_document_symbols<cr>
    nnoremap <buffer> <leader>fs <cmd>Telescope lsp_dynamic_workspace_symbols<cr>

    " ACTIONS
    nnoremap <buffer> <leader>r  <cmd>lua vim.lsp.buf.rename()<cr>
    nnoremap <buffer> <leader>a  <cmd>lua vim.lsp.buf.code_action()<cr>
    xnoremap <buffer> <leader>a  <cmd>lua vim.lsp.buf.code_action()<cr>

    " JUMPS
    nnoremap <buffer> ]e         <cmd>lua vim.diagnostic.goto_next()<cr>
    nnoremap <buffer> [e         <cmd>lua vim.diagnostic.goto_prev()<cr>

    " INFO
    nnoremap <buffer> <c-k>      <cmd>lua vim.lsp.buf.hover()<cr>
    "nnoremap <buffer> <c-p>      <cmd>lua vim.lsp.buf.peek_definition()<cr>
    nnoremap <buffer> <c-p>      <cmd>lua vim.lsp.buf.signature_help()<cr>
]]

local complete = [[
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-b>     compe#scroll({ 'delta': -4 })
  smap <Backspace> a<Backspace>
]]

vim.keymap.set("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		vim.fn["compe#confirm"]({ keys = "<TAB>", select = true })
		return ""
	end
	if require("copilot.suggestion").is_visible() then
		vim.schedule(require("copilot.suggestion").accept)
		return ""
	end
	return "<Tab>"
end, { expr = true, noremap = true })

vim.keymap.set("i", "<C-n>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-n>"
	end
	vim.schedule(require("copilot.suggestion").next)
	return ""
end, { silent = true })

vim.keymap.set("i", "<C-p>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-p>"
	end
	vim.schedule(require("copilot.suggestion").prev)
	return ""
end, { silent = true })

vim.keymap.set("i", "<S-Tab>", function()
	require("copilot.panel").open()
end, { silent = true })

local snippets = [[
  imap <expr> <C-k> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : ''
  smap <expr> <C-k> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : ''
  imap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : ''
  smap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : ''
  xmap s   <Plug>(vsnip-cut-text)
]]

-- local args = [[
--   " fix wrapping issue
--   nnoremap ++        <cmd>lua u.argadd()<cr>
--   nnoremap --        <cmd>lua u.argdelete()<cr>
--   nnoremap <leader>+ <cmd>lua u.args()<cr>
-- ]]

local dap = [[
  nnoremap <leader>d> <cmd>lua require('dap').continue()<cr>
  nnoremap <leader>d< <cmd>lua require('dap').reverse_continue()<cr>
  nnoremap <leader>d. <cmd>lua require('dap').run_to_cursor()<cr>

  nnoremap <leader>dr <cmd>lua require('dap').run_last()<cr>
  nnoremap <leader>dd <cmd>lua require('util.dap').toggle_debug()<cr>

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
  nnoremap <leader>da <cmd>lua require('util.dap').attach()<cr>
  nnoremap <leader>dL <cmd>lua require('util.dap').open_log()<cr>
]]

local term = [[
  nnoremap <buffer> <C-n> :FloatermNext<cr>
  nnoremap <buffer> <C-p> :FloatermPrev<cr>
]]

local zk = [[
  nnoremap <leader>zz <cmd>ZkNew { title = vim.fn.input('Title: ') }<cr>
  vnoremap <leader>z :'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: ') }<cr>
  nnoremap <leader>zb <cmd>ZkBacklinks<cr>
  nnoremap <leader>zl <Cmd>ZkLinks<cr>
  nnoremap <leader>zp <cmd>ZkInsertLink<cr>
  nnoremap <leader>zf <cmd>ZkNotes { sort = { 'modified' } }<cr>
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
-- vim.cmd(args)
vim.cmd(dap)
-- vim.cmd(test)
vim.cmd(zk)

local M = {}

function M.register_lsp(client, bufnr)
  if client.name ~= "efm" then
    vim.cmd(lsp)
  end
	if client.name == "eslint" then
		vim.cmd([[
      nnoremap <buffer> <leader>=  :EslintFixAll<cr>
    ]])
	end
end
function M.register_term()
	vim.cmd(term)
end

vim.cmd([[
  augroup FloatermKeys
  au!
  au FileType floaterm lua require('keymap').register_term()
  augroup END
]])

return M
