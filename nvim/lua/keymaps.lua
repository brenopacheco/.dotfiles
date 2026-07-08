local maps = {}

vim.g.mapleader = ','

-- UNDO DEFAULTS ===============================================================
-- stylua: ignore
for _, map in pairs({
  { { 'n'      }, 'grn'   },
  { { 'n', 'x' }, 'gra'   },
  { { 'n'      }, 'grr'   },
  { { 'n'      }, 'gri'   },
  { { 'n'      }, 'grt'   },
  { { 'n'      }, 'grx'   },
  { { 'n'      }, 'gO'    },
  { { 'i', 's' }, '<c-s>' },
}) do
  pcall(vim.keymap.del, unpack(map))
end

-- DEFAULTS ====================================================================
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
vim.keymap.set({ 'n' }, '<esc>', vim.cmd.nohlsearch)
vim.keymap.set({ 'n' }, '<c-w>e', vim.cmd.enew)
vim.keymap.set({ 'n' }, '<c-w><c-e>', vim.cmd.enew)
vim.keymap.set({ 'n' }, '<c-w><c-t>', function() vim.cmd('tabnew') end)
vim.keymap.set({ 'n', 'x' }, 'Q', '<Nop>')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- WINDOW NAVIGATION ===========================================================
-- vim.keymap.set({ 'n' }, '<c-k>', '<c-w>w')   -- next window
-- vim.keymap.set({ 'n' }, '<c-j>', '<c-w>W')   -- previous window
-- vim.keymap.set({ 'n' }, '<c-x>', '<c-w>c')   -- close window
-- vim.keymap.set({ 'n' }, '<c-s>', '<c-w>s')   -- horizontal split
-- vim.keymap.set({ 'n' }, '<c-v>', '<c-w>v')   -- vertical split (visual block via <C-q>)
-- vim.keymap.set({ 'n' }, '<c-m>', '<c-w>o')   -- maximize (only) windo
vim.keymap.set({ 'n' }, '<c-n>', 'gt')
vim.keymap.set({ 'n' }, '<c-p>', 'gT')
vim.keymap.set({ 'n' }, '<c-1>', '1gt')
vim.keymap.set({ 'n' }, '<c-2>', '2gt')
vim.keymap.set({ 'n' }, '<c-3>', '3gt')
vim.keymap.set({ 'n' }, '<c-4>', '4gt')
vim.keymap.set({ 'n' }, '<c-5>', '5gt')
if true then return end

-- CYCLE =======================================================================
vim.keymap.set({ 'n' }, ']b', vim.cmd.bprevious)
vim.keymap.set({ 'n' }, '[b', vim.cmd.bnext)
vim.keymap.set({ 'n' }, ']e', vim.cmd.cnewer)
vim.keymap.set({ 'n' }, '[e', vim.cmd.colder)
--vim.keymap.set({ 'n' }, ']q', maps.qf_item_next)
--vim.keymap.set({ 'n' }, '[q', maps.qf_item_prev)
--vim.keymap.set({ 'n' }, ']d', maps.diag_prev)
--vim.keymap.set({ 'n' }, '[d', maps.diag_next)
--vim.keymap.set({ 'n' }, ']t', maps.term_prev)
--vim.keymap.set({ 'n' }, '[t', maps.term_next)
--vim.keymap.set({ 'n' }, ']c', maps.chunk_prev)
--vim.keymap.set({ 'n' }, '[c', maps.chunk_next)

-- QUICKFIX ====================================================================
vim.keymap.set({ 'n' }, 'qf', maps.qf_global) -- ':Cfilter //<left>') -- figure out a better mapping
vim.keymap.set({ 'n' }, 'qv', maps.qf_vglobal) -- ':Cfilter! //<left>')

-- TOOLS =======================================================================
vim.keymap.set({ 'n' }, ',g', maps.toggle_git)
vim.keymap.set({ 'n' }, ',e', maps.toggle_explorer)
vim.keymap.set({ 'n' }, ',t', maps.toggle_terminal)
vim.keymap.set({ 'n' }, ',q', maps.toggle_quickfix)
vim.keymap.set({ 'n' }, ',o', maps.toggle_outline)
vim.keymap.set({ 'n' }, 'gm', maps.toggle_messages)

-- ACTIONS =====================================================================
vim.keymap.set({ 'n', 'x' }, ',=', maps.format)
vim.keymap.set({ 'n', 'x' }, ',a', maps.code_action)
vim.keymap.set({ 'n' }, ',r', maps.rename)
vim.keymap.set({ 'n', 'x' }, ',s', maps.substitute)
vim.keymap.set({ 'n', 'x' }, 'gp', maps.yank_path)
vim.keymap.set({ 'n', 'x' }, ',a', maps.align)
vim.keymap.set({ 'n' }, ',x', maps.bufdelete)
vim.keymap.set({ 'n' }, ',m', maps.make) -- note sure is not the same as compile
vim.keymap.set({ 'n' }, ',c', maps.compile)
vim.keymap.set({ 'n' }, ',r', maps.recompile) -- not

-- UNCAT =======================================================================
vim.keymap.set({ 'n' }, '<c-k>', maps.hover)
vim.keymap.set({ 'n' }, ',v', maps.set_option) -- via picker, then input
vim.keymap.set({ 'n' }, 'K', maps.keywordprg)

-- GIT   =======================================================================
vim.keymap.set({ 'n', 'x' }, 'gy', maps.git_permalink)
vim.keymap.set({ 'n', 'x' }, 'gp', maps.git_preview)
vim.keymap.set({ 'n', 'x' }, 'gs', maps.git_stage)
vim.keymap.set({ 'n', 'x' }, 'gu', maps.git_unstage)
vim.keymap.set({ 'n', 'x' }, 'gb', maps.git_blame)
vim.keymap.set({ 'n', 'x' }, 'gl', maps.git_logs)

-- PICKERS =====================================================================
local p = require('snacks').picker
--
vim.keymap.set({ 'n' }, ',,', p.smart) -- buffer, recent, git-files
vim.keymap.set({ 'n' }, ',/', p.grep) -- grep (curdir)

-- ,k docs (zeal, tldr?, hover?, symbol?)
-- ,j git_files
-- ,g Git toggle
-- ,d grep_word
-- ,l is for lua (config)
-- ,g git files
-- ,v set variables/options
-- ,z zk (new or find?)

vim.keymap.set({ 'n' }, ',,', p.smart) -- modifty to use { buffer, recent, git-files }
vim.keymap.set({ 'n' }, ',/', p.grep) -- global dir (project) grep (need fixing)
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
--]]
