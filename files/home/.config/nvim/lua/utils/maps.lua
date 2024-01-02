local bufutil = require('utils.buf')
local daputil = require('utils.dap')
local greputils = require('utils.grep')
local lsputil = require('utils.lsp')
local qfutil = require('utils.qf')
local rootutil = require('utils.root')

local M = {}

local _dummy = function()
	vim.notify('Not implemented', vim.log.levels.WARN)
end

-- Add buffer to arglist
M.args_add = function()
	vim.cmd('ArgAdd')
end

-- Clear arglist
M.args_clear = function()
	vim.cmd('ArgClear')
end

-- Remove buffer from arglist
M.args_delete = function()
	vim.cmd('ArgDelete')
end

-- Open buffer diagnostics in quickfix
M.errors_buffer = function()
	qfutil.errors({ workspace = false })
end

-- Open workspace diagnostics in quickfix
M.errors_workspace = function()
	qfutil.errors({ workspace = true })
end

-- Find file in arglist
M.find_args = require('utils.pickers.arglist')

-- Find buffer in buffer list
M.find_buffers = function()
	require('telescope.builtin').buffers({})
end

-- Find files in current directory
M.find_curdir = function()
	require('telescope.builtin').find_files({
		cwd = vim.fn.getcwd(),
		hidden = true,
	})
end

-- Find files in git directory
M.find_files = function()
	local root = rootutil.git_root()
	vim.notify("info: searching '" .. root .. "'", vim.log.levels.INFO)
	require('telescope.builtin').find_files({
		cwd = root,
		hidden = true,
	})
end

-- Find git files modified or staged
M.find_gitstatus = function()
	require('telescope.builtin').git_status({})
end

-- Find helptags
M.find_helptag = function()
	require('telescope.builtin').help_tags({})
end

-- Find files in nvim configuration directory
M.find_config = function()
	require('utils.pickers.configs')()
end

-- Run project target from Makefile, Go, Rust, etc.
M.find_make = function()
	require('utils.pickers.make')()
end

-- Find file in current project (nearest project file directory)
M.find_project = function()
	local roots = rootutil.project_roots()
	if #roots == 0 then
		roots = { rootutil.git_root() }
		vim.notify(
			'error: no project roots found - defaulting to git',
			vim.log.levels.WARN
		)
	end
	if #roots == 0 then
		return vim.notify('error: not a git repository', vim.log.levels.WARN)
	end
	vim.notify("info: searching '" .. roots[1].path .. "'", vim.log.levels.INFO)
	require('telescope.builtin').find_files({
		cwd = roots[1].path,
		hidden = true,
	})
end

-- Find quickfix entry
M.find_quickfix = function()
	require('telescope.builtin').quickfix({})
end

-- Find recent files
M.find_recent = function()
	require('telescope.builtin').oldfiles({})
end

-- Finds roots in current git project
M.find_roots = function()
	require('utils.pickers.roots')()
end

-- Find files in git directory using ripgrep
M.find_grep = function()
	require('telescope.builtin').live_grep({
		search_dirs = { rootutil.git_root() },
	})
end

-- Find files in git directory using pattern under cursor
M.find_star = function()
	require('telescope.builtin').grep_string({
		search_dirs = { rootutil.git_root() },
	})
end

-- Find zk notes
M.find_zk = function()
	vim.cmd([[ZkNotes { sort = { 'modified' } }]])
end

-- Find marks
M.find_mark = function()
	require('telescope.builtin').marks({})
end

-- Find symbol in buffer
M.find_doc_symbol = function()
	require('telescope.builtin').lsp_document_symbols({})
end

-- Find symbol in buffer
M.find_ws_symbol = function()
	require('telescope.builtin').lsp_workspace_symbols({})
end

-- Git show blame lines
M.git_blame = function()
	vim.cmd([[Git blame]])
end

-- Git open fugitive window
M.git_fugitive = function()
	bufutil.toggle('fugitive', function()
		vim.cmd('G')
	end)
end

-- Open permalink to current line in browser and copy to clipboard
M.git_link = function()
	require('gitlinker').get_buf_range_url(
		'n',
		{ action_callback = require('gitlinker.actions').open_in_browser }
	)
end

-- Git open log
M.git_log = function()
	vim.cmd([[G log]])
end

-- Git preview hunk under cursor
M.git_preview = function()
	require('gitsigns').preview_hunk()
end

-- Reset git hunk under cursor
M.git_reset = function()
	require('gitsigns').reset_hunk()
end

-- Stage git hunk under cursor
M.git_stage = function()
	require('gitsigns').stage_hunk()
end

-- Unstage git hunk under cursor
M.git_unstage = function()
	require('gitsigns').undo_stage_hunk()
end

-- Goto symbol declaration
M.goto_declaration = function()
	lsputil.wrap(vim.lsp.buf.declaration, { on_list = lsputil.on_list })
end

-- Goto symbol definition
M.goto_definition = function()
	if vim.o.ft == 'help' then
		vim.cmd(vim.o.keywordprg .. ' ' .. vim.fn.expand('<cword>'))
	else
		vim.lsp.buf.definition({ on_list = lsputil.on_list })
	end
end

-- Goto interface implementation
M.goto_implementation = function()
	vim.lsp.buf.implementation({ on_list = lsputil.on_list })
end

-- Goto symbol incoming calls
M.goto_incoming = function()
	vim.lsp.buf.incoming_calls()
end

-- Goto symbol outgoing calls
M.goto_outgoing = function()
	vim.lsp.buf.outgoing_calls()
end

-- Goto symbol references
M.goto_references = function()
	vim.lsp.buf.references(nil, { on_list = lsputil.on_list })
end

-- Goto symbol type definition
M.goto_typedef = function()
	vim.lsp.buf.type_definition({ on_list = lsputil.on_list })
end

-- Jump to next arg in arglist
M.jump_argnext = function()
	vim.cmd('ArgNext')
end

-- Jump to previous arg in arglist
M.jump_argprev = function()
	vim.cmd('ArgPrev')
end

-- Jump to next buffer in buffer list
M.jump_bufnext = function()
	vim.cmd('bnext')
end

-- Jump to previous buffer in buffer list
M.jump_bufprev = function()
	vim.cmd('bprevious')
end

-- Jump to next git hunk or diff chunk
M.jump_chunknext = function()
	require('gitsigns').next_hunk()
end

-- Jump to prev git hunk or diff chunk
M.jump_chunkprev = function()
	require('gitsigns').prev_hunk()
end

-- Jump to the next diagnostic
M.jump_errornext = function()
	vim.diagnostic.goto_next()
end

-- Jump to the previous diagnostic
M.jump_errorprev = function()
	vim.diagnostic.goto_prev()
end

-- Jump to next file in file tree
M.jump_filenext = function()
	local api = require('nvim-tree.api')
	if not api.tree.is_visible() then
		api.tree.open()
	end
	api.node.navigate.sibling.next()
	local path = api.tree.get_node_under_cursor().absolute_path
	if path ~= nil then
		vim.cmd('edit ' .. path)
	end
end

-- Jump to previous file in file tree
M.jump_fileprev = function()
	local api = require('nvim-tree.api')
	if not api.tree.is_visible() then
		api.tree.open()
	end
	api.node.navigate.sibling.prev()
	local path = api.tree.get_node_under_cursor().absolute_path
	if path ~= nil then
		vim.cmd('edit ' .. path)
	end
end

-- Jump to next entry in location list
M.jump_locnext = function()
	vim.fn.lnext()
end

-- Jump to previous entry in location list
M.jump_locprev = function()
	vim.fn.lprev()
end

-- Jump to next quickfix entry
M.jump_qfnext = function()
	qfutil.next_entry()
end

-- Jump to previous quickfix entry
M.jump_qfprev = function()
	qfutil.prev_entry()
end

-- Jump to next tab
M.jump_tabnext = function()
	vim.cmd('tabnext')
end

-- Jump to previous tab
M.jump_tabprev = function()
	vim.cmd('tabprevious')
end

-- Jump to next terminal
M.jump_termnext = function()
	vim.cmd('FloatermNext')
end

-- Jump to previous terminal
M.jump_termprev = function()
	vim.cmd('FloatermPrev')
end

-- Replace qf with newer error list
M.qf_cnewer = function()
	vim.cmd('cnewer')
end

-- Replace qf with previous error list
M.qf_colder = function()
	vim.cmd('colder')
end

-- Filter quickfix list by pattern
M.qf_global = function()
	greputils.qf_filter({ invert = false })
end

-- Filter quickfix list by exclude pattern
M.qf_vglobal = function()
	greputils.qf_filter({ invert = false })
end

-- Run align
M.run_align = function()
	bufutil.set_visual(bufutil.get_visual())
	vim.cmd([['<,'>EasyAlign]])
end

-- Delete buffer
M.run_bd = function()
	bufutil.delete()
end

-- Start new debug session
M.debug_start = function()
	daputil.debug_start()
end

-- Restart current debug session
M.debug_restart = function()
	daputil.debug_restart()
end

-- Run last debug configuration
M.debug_last = function()
	daputil.debug_last()
end

-- Terminate current debug session
M.debug_terminate = function()
	daputil.debug_terminate()
end

-- Pause thread
M.debug_pause = function()
	daputil.debug_pause()
end

-- Continue thread
M.debug_continue = function()
	daputil.debug_continue()
end

-- Step into next function
M.debug_step_into = function()
	daputil.debug_step_into()
end

-- Step out of current function
M.debug_step_out = function()
	daputil.debug_step_out()
end

-- Step over to next line
M.debug_step_over = function()
	daputil.debug_step_over()
end

-- Focus debug repl console
M.debug_repl = function()
	daputil.debug_repl()
end

-- Toggle breakpoint on current line
M.debug_bp_toggle = function()
	daputil.debug_bp_toggle()
end

-- Toggle breakpoint on current line - apply condition
M.debug_bp_condition = function()
	daputil.debug_bp_condition()
end

-- Clear breakpoints
M.debug_bp_clear = function()
	daputil.debug_bp_clear()
end

-- List breakpoints in qf list
M.debug_bp_list = function()
	daputil.debug_bp_list()
end

-- Hover variable under cursor
M.debug_hover = function()
	daputil.debug_hover()
end

-- Preview variable under cursor
M.debug_preview = function()
	daputil.debug_preview()
end

-- Continues execution to the current cursor.
M.debug_to_cursor = function()
	daputil.to_cursor()
end

-- Open dap log
M.debug_open_log = function()
	daputil.open_log()
end

-- Run code action
M.run_code = function()
	vim.lsp.buf.code_action()
end

-- Create new unnamed buffer
M.run_enew = function()
	vim.cmd('enew')
end

-- Run formatter
M.run_format = function()
	if vim.fn.mode() == 'n' then
		vim.cmd([[Neoformat]])
	else
		bufutil.set_visual(bufutil.get_visual())
		vim.cmd([['<,'>Neoformat]])
	end
end

-- Run grep on buffer, directory, git root, or project root
M.run_grep = function()
	greputils.grep_pattern(nil)
end

-- xdg-open
M.run_gx = function()
	require('gx').search_for_url()
end

-- Open messages
M.messages = function()
	vim.cmd('Messages')
end

-- Open lsp info
M.lsp_info = function()
	lsputil.open_config()
end


-- Run make command
M.run_make = function()
	return bufutil.is_file() and vim.cmd([[make %]])
		or vim.notify('not implemented', vim.log.levels.WARN)
end

-- Maximize window
M.run_maximize = function()
	vim.cmd([[resize +999 | vertical resize +999]])
end

-- Generate documentation
M.run_neogen = function()
	vim.cmd('Neogen')
end

-- Replace symbol under cursor
M.run_replace = function()
	return lsputil.is_attached() and vim.lsp.buf.rename()
		or vim.notify('not implemented', vim.log.levels.WARN)
end

-- Source buffer contents (vim/lua)
M.run_source = function()
	if vim.fn.mode() == 'n' then
		vim.cmd([[source]])
	else
		bufutil.set_visual(bufutil.get_visual())
		vim.cmd([['<,'>source]])
	end
end

-- Spawn new terminal window in current dir
M.run_spawn = function()
	vim.fn.system('st >/dev/null 2>&1 & disown $!')
end

-- Run star search on buffer, directory, git root, or project root
M.run_star = function()
	local pattern = bufutil.is_visual()
			and table.concat(bufutil.get_visual().text, '')
		or tostring(vim.fn.expand('<cword>'))
	greputils.grep_pattern(pattern)
end

-- Open new tab
M.run_tabnew = function()
	vim.cmd('tabnew')
end

-- Create new zk entry
M.run_zknew = function()
	local title = vim.fn.input('Title: ')
	if title ~= nil and title ~= '' then
		require('zk.commands').get('ZkNew')({ title = title })
	end
end

-- Highlight symbol under cursor
M.show_highlight = function()
	lsputil.wrap(vim.lsp.buf.document_highlight)
end

-- Show hover information
M.show_hover = function()
	lsputil.wrap(vim.lsp.buf.hover)
end

-- Show function signature help
M.show_signature = function()
	lsputil.wrap(vim.lsp.buf.signature_help)
end

-- Visit file where last test was run
M.test_visit = function()
	vim.cmd('TestVisit')
end

-- Runs all tests in the current file
M.test_file = function()
	vim.cmd('TestFile')
end

-- Runs the test nearest to the cursor
M.test_nearest = function()
	vim.cmd('TestNearest')
end

-- Runs the last test run
M.test_previous = function()
	vim.cmd('TestLast')
end

-- Runs the whole test suite
M.test_suite = function()
	vim.cmd('TestSuite')
end

-- Toggle dap ui
M.toggle_dapui = function()
  daputil.toggle_ui()
end

-- Open lf file explorer
M.toggle_lf = function()
  P('lf')
	-- vim.cmd('Lf')
end

-- Toggle side tree
M.toggle_ntree = function()
	require('nvim-tree.api').tree.toggle({ focus = false })
end

-- Open oil
M.toggle_oil = function()
	vim.cmd([[Oil]])
end

-- Toggle global option
M.toggle_option = function()
	require('utils.pickers.options')()
end

-- Toggle symbols outline window
M.toggle_outline = function()
	return lsputil.is_attached() and vim.cmd('SymbolsOutline')
		or vim.notify('lsp not attached or not ready', vim.log.levels.WARN)
end

-- Toggle quickfix window
M.toggle_quickfix = function()
	bufutil.toggle('qf', function()
		vim.cmd('copen | wincmd p')
	end)
end

-- Toggle terminal window
M.toggle_term = function()
	vim.cmd('FloatermToggle')
end

-- Open new terminal
M.newterm = function()
	vim.cmd('FloatermNew')
end

-- Toggle zen mode
M.toggle_zen = function()
	vim.cmd('ZenMode')
end

-- Open keyword under cursor
-- This is required because of https://github.com/neovim/neovim/pull/24331
M.keywordprg = function()
	if not vim.o.keywordprg then
		return vim.notify('info: keywordprg not set', vim.log.levels.WARN)
	end
	local word = bufutil.is_visual()
			and table.concat(bufutil.get_visual().text, '')
		or vim.fn.expand('<cword>')
	vim.cmd(vim.o.keywordprg .. ' ' .. word)
end

return M
