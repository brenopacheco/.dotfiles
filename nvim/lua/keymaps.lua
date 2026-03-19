local my = require('my.misc')

vim.g.mapleader = ','

-- map c-1 to 1gt to mimick browser keybindings
for i = 1, 9 do
  vim.keymap.set({ 'n' }, '<c-' .. tostring(i) .. '>', tostring(i) .. 'gt')
end

-- stylua: ignore
for _, map in pairs({
  { { 'n'      }, 'grn'   },
  { { 'n', 'x' }, 'gra'   },
  { { 'n'      }, 'grr'   },
  { { 'n'      }, 'gri'   },
  { { 'n'      }, 'grt'   },
  { { 'n'      }, 'gO'    },
  { { 'i', 's' }, '<c-s>' },
}) do
  pcall(vim.keymap.del, unpack(map))
end

-- vim.keymap.set('K', keywordprg) -- we need to set it such that K is not
-- overriden buffer local whenever LSP is attached

--[[
format          ,=
rename          ,r
substitute      ,s
align           ,a ,\
code action     ,a ,c

hover/signature <c-k>
docs/keywordprg K

terminal
zk new


references      gr
implementation  gi
definition      gd
type definition gy
outline         gO

open permalink  gX
copy url        gp/gP

git preview    <c-p>


git fugitive
git log
git blame
git stage
git unstage












--]]

-- stylua: ignore start
-- vim.keymap.set('n', 'grn', function() vim.lsp.buf.rename() end, { desc = 'vim.lsp.buf.rename()' })
-- vim.keymap.set({ 'n', 'x' }, 'gra', function() vim.lsp.buf.code_action() end, { desc = 'vim.lsp.buf.code_action()' })
-- vim.keymap.set('n', 'grr', function() vim.lsp.buf.references() end, { desc = 'vim.lsp.buf.references()' })
-- vim.keymap.set('n', 'gri', function() vim.lsp.buf.implementation() end, { desc = 'vim.lsp.buf.implementation()' })
-- vim.keymap.set('n', 'grt', function() vim.lsp.buf.type_definition() end, { desc = 'vim.lsp.buf.type_definition()' })
-- vim.keymap.set('n', 'gO', function() vim.lsp.buf.document_symbol() end, { desc = 'vim.lsp.buf.document_symbol()' })
-- vim.keymap.set({ 'i', 's' }, '<c-k>', function() vim.lsp.buf.signature_help() end, { desc = 'vim.lsp.buf.signature_help()' })
-- stylua: ignore end

vim.keymap.set({ 'i', 'x' }, '<c-c>', '<c-[>')
vim.keymap.set({ 'i' }, 'jk', '<c-[>l')
vim.keymap.set({ 'i' }, 'kj', '<c-[>l')
vim.keymap.set({ 'c' }, 'jk', '<c-c>')
vim.keymap.set({ 'c' }, 'kj', '<c-c>')
vim.keymap.set({ 't' }, 'jk', '<c-\\><c-n>')
vim.keymap.set({ 't' }, 'kj', '<c-\\><c-n>')
vim.keymap.set({ 'x' }, '<', '<gv')
vim.keymap.set({ 'x' }, '>', '>gv')
vim.keymap.set({ 'n' }, '>', '>>')
vim.keymap.set({ 'n' }, '<', '<<')
vim.keymap.set({ 'n' }, 'Y', 'v$hy')
vim.keymap.set({ 'x' }, 'p', 'pgvy')
vim.keymap.set({ 'n', 'x' }, 'Q', '<Nop>')
vim.keymap.set({ 'n' }, '<esc>', vim.cmd.nohlsearch)
vim.keymap.set({ 'n' }, '<c-w>y', '<c-w>T')
vim.keymap.set({ 'n' }, '<c-w><c-y>', '<c-w>T')
vim.keymap.set({ 'n' }, '<c-w>t', function() vim.cmd('tab split') end)
vim.keymap.set({ 'n' }, '<c-w><c-t>', function() vim.cmd('tab split') end)
vim.keymap.set({ 'n' }, '<c-w>e', vim.cmd.enew)
vim.keymap.set({ 'n' }, '<c-w><c-e>', vim.cmd.enew)

vim.keymap.set({ 'n' }, 'gm', vim.cmd.messages)

-- vim.keymap.set({'n', 'v'}, '<leader>x', vim.lsp.buf.references, { buffer = true })

-- vim.cmd('nnoremap <c-k> <cmd>lua vim.lsp.buf.hover()<cr>')

-- ACTIONS =====================================================================
vim.keymap.set({ 'n' }, ',=', require('conform').format)
vim.keymap.set({ 'n' }, ',g', vim.cmd.Git)
vim.keymap.set({ 'n' }, ',e', vim.cmd.Oil)

local p = require('snacks').picker

-- vim.keymap.set({ 'n' }, ',m', p.make)
vim.keymap.set({ 'n' }, ',r', vim.cmd.Recompile)
vim.keymap.set({ 'n' }, ',c', function() my.feedkeys(':Compile ') end)
vim.keymap.set({ 'n' }, ',b', p.buffers)
vim.keymap.set({ 'n' }, ',h', p.help)
vim.keymap.set({ 'n' }, ',s', p.lsp_symbols)
vim.keymap.set({ 'n' }, ',p', p.projects)
vim.keymap.set({ 'n' }, ',o', p.recent)
-- vim.keymap.set({ 'n' }, ',u', p.git_diff) -- or p.git_status ?
vim.keymap.set({ 'n' }, ',w', p.lsp_workspace_symbols)
vim.keymap.set({ 'n' }, ',:', p.command_history)

-- vim.keymap.set(
--   { 'n' },
--   ',l',
--   function() p.files({ cwd = vim.fn.stdpath('config'), hidden = true }) end
-- )

vim.keymap.set({ 'n' }, ',,', p.smart) -- buffer, recent, git-files
vim.keymap.set({ 'n' }, ',/', p.grep) -- grep (curdir)
-- vim.keymap.set({ 'n' }, ',f', function() p.files({ hidden = true }) end) -- files curdir

-- vim.keymap.set({ 'n' }, ',j', p.git_files) -- local dir (project) files
-- vim.keymap.set({ 'n', 'x' }, ',d', p.grep_word, { noremap = true }) -- will work from curdir, not what we want

-- ,k docs (zeal, tldr?, hover?, symbol?)
-- ,j git_files
-- ,g Git toggle
-- ,d grep_word
-- ,e new/explore/scratch???
-- ,m make
-- ,c compile
-- ,l is for lua (config)
-- ,t terminal
-- ,g git files
-- ,v set variables/options
-- ,z zk (new or find?)
-- ,, smart
-- ,i :File!
-- ,x execute something?

-- git
-- 	qy git permalink
-- 	qp preview (or qd)
-- 	qs stage
-- 	qu untage

vim.keymap.set({ 'n' }, ',,', p.smart) -- modifty to use { buffer, recent, git-files }
vim.keymap.set({ 'n' }, ',/', p.grep) -- global dir (project) grep (need fixing)
vim.keymap.set({ 'n' }, ',j', p.git_files) -- local dir (project) files
vim.keymap.set({ 'n' }, ',.', function() p.files({ hidden = true }) end) -- local dir (project) files
vim.keymap.set({ 'n', 'x' }, ',d', p.grep_word, { noremap = true }) -- will work from curdir, not what we want
-- vim.keymap.set(
--   { 'n', 'x' },
--   ',f',
--   function() Snacks.picker.grep({ dirs = { my.root() } }) end -- global dir
-- ) -- I actually want a grep that works in current dir
-- vim.keymap.set({ 'n' }, ',.', p.files) -- global dir (project) files
-- vim.keymap.set({ 'n' }, ',.', p.grep) -- local  dir (buffer)  grep

-- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
-- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
-- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
-- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
-- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
-- { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
-- { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
-- { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
-- { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

-- { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
-- { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
-- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
-- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
-- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
-- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
-- { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },

-- { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
-- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
-- { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
-- { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
-- { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },

-- { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
-- { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
--
-- { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },

-- vim.keymap.set(
--   { 'n' },
--   ',t',
--   function() Snacks.terminal(nil, { auto_insert = false, start_insert = false })jk
-- ) -- togggler
-- vim.keymap.set({ 'n' }, ',e', my.toggler('oil'))
-- vim.keymap.set({ 'n' }, ',t', my.toggler('terminal'))
-- vim.keymap.set(
--   { 'n' },
--   ',t',
--   function() Snacks.terminal.toggle({ auto_insert = false }) end
-- )
-- vim.keymap.set({ 'n' }, ',o', my.toggler('outline'))
-- vim.keymap.set({ 'n' }, ',q', my.toggler('quickfix'))
-- vim.keymap.set({ 'n' }, ',;', my.toggler('fugitive')

-- gx
-- vim.ui.open("https://neovim.io/")

-- WANT THOSE ==================================================================
--[[goto
	g* grep <cword>
	gp file-url
	gm messages
	gk keywordprg (or K?)
	gr references
	gi implementation
	gy typedef
	go outgoing-calls
	go outgoing-calls
	gO buf-symbols
	gx browse

action
	,= format
	,| align (or ,\)
	,, code-action (or ,.)
	,s substitute
	,t terminal
	,z zk-new
	,k hover
	,e enew

find
	,f  find (curdir)
	,p  find (project/git-files)
	,u  git-diffs
	,r  recent
	,j  switch to project (or ,\ or ,~)
	,z  zk-notes
	,w  workspace-symbols
	,o  buf-symbols (outline)
	,h  helptags
	,b  buffers

git
	,y git permalink
	,g git fugitive
	,l git log
	,? preview
	,+ stage
	,- untage

quickfix
	qf global
	qv vglobal
	qp colder
	qn cnewer

jump
	]b 󰒭 buffer
	[b 󰒮 buffer
	]c 󰒭 chunk/hunk
	[c 󰒮 chunk/hunk
	]e 󰒭 error
	[e 󰒮 error
	]q 󰒭 qf-entry
	[q 󰒮 qf-entry

toggle
	,q quickfix
	,` terminal
	-  oil
--]]

---[[ Remap common jump motions so they don't mess with the jumplist
-- stylua: ignore
for _, motion in ipairs({
  "}", "{",               -- paragraph motions
  ")", "(",               -- sentence motions
  "]]", "[[", "][", "[]", -- section / function motions
  "]m", "[m", "]M", "[M", -- method motions
  "]}", "[{",             -- block motions
}) do
  vim.keymap.set("n", motion, "<cmd>keepjumps normal! " .. motion .. "<CR>")
end
--]]

--[[ *:map-arguments* reference
  buffer: current buffer only                                   (default false)
  remap:  recursive mapping                                     (default false)
  nowait: don't wait for other mappings, immediatly evaluate    (default false)
  silent: don't echo the command                                (default false)
  script: use {rhs} mappings defined in the script - <SID>      (default false)
  expr:   evaluate {rhs} as an expression                       (default false)
  unique: don't remap if already mapped                         (default false)
  desc:   human-readable description                            (default '')
--]]
