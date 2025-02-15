local bufutil = require('utils.buf')
local daputil = require('utils.dap')
local greputils = require('utils.grep')
local lsputil = require('utils.lsp')
local qfutil = require('utils.qf')
local rootutil = require('utils.root')

local M = {}

-- Add buffer to arglist
M.args_add = function() vim.cmd('argadd | argdedupe | args') end

-- Clear arglist
M.args_clear = function() vim.cmd('argd * | args') end

-- Remove buffer from arglist
M.args_delete = function() vim.cmd('argd % | args') end

M.args_next = function() vim.cmd('next') end

M.args_prev = function() vim.cmd('prev') end

-- Open buffer diagnostics in quickfix
M.errors_buffer = function() qfutil.errors({ workspace = false }) end

-- Open workspace diagnostics in quickfix
M.errors_workspace = function() qfutil.errors({ workspace = true }) end

-- Find buffer in buffer list
M.find_buffers = function() require('telescope.builtin').buffers({}) end

-- Find files in current directory
M.find_curdir = function()
	require('telescope.builtin').find_files({
		cwd = vim.fn.getcwd(),
		hidden = true,
	})
end

-- Find files in git directory
M.find_rfiles = function()
	local root = rootutil.git_root()
	vim.notify("info: searching '" .. root .. "'", vim.log.levels.INFO)
	require('telescope.builtin').find_files({
		cwd = root,
		hidden = true,
	})
end

-- Find git files modified or staged
M.find_gitstatus = function() require('telescope.builtin').git_status({}) end

-- Find helptags
M.find_helptag = function() require('telescope.builtin').help_tags({}) end

-- Find files in nvim configuration directory
M.find_config = function() require('utils.pickers.configs')() end

-- Run project target from Makefile, Go, Rust, etc.
M.find_make = function() require('utils.pickers.make')() end

-- Find file in current project (nearest project file directory)
M.find_pfiles = function()
	local roots = rootutil.project_roots()
	if #roots == 0 then
		roots = { { path = rootutil.git_root() } }
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
M.find_quickfix = function() require('telescope.builtin').quickfix({}) end

-- Find recent files
M.find_recent = function() require('telescope.builtin').oldfiles({}) end

-- Finds roots in current git project
M.find_roots = function() require('utils.pickers.roots')() end

-- Find files in git directory using ripgrep
M.find_grep = function()
	require('telescope.builtin').live_grep({
		cwd = rootutil.git_root(),
		additional_args = { '--hidden' },
	})
end

-- -- Find files in git directory using ripgrep
-- M.find_grep = function()
-- 	require('telescope.builtin').live_grep({
-- 		default_text = vim.fn.expand('<cword>'),
-- 		cwd = rootutil.git_root(),
-- 		additional_args = { '--hidden' },
-- 	})
-- end

-- Find files in git directory using pattern under cursor
M.find_star = function()
	require('telescope.builtin').grep_string({
		cwd = rootutil.git_root(),
		additional_args = { '--hidden' },
	})
end

-- Find zk notes
M.find_zk = function() vim.cmd([[ZkNotes { sort = { 'modified' } }]]) end

-- Find marks
M.find_mark = function() require('telescope.builtin').marks({}) end

-- Find registers
M.find_registers = function() require('telescope.builtin').registers({}) end

-- Find symbol in buffer
M.find_doc_symbol = function()
	require('telescope.builtin').lsp_document_symbols({})
end

-- Find symbol in buffer
M.find_ws_symbol = function()
	require('telescope.builtin').lsp_workspace_symbols({})
end

-- Git show blame lines
M.git_blame = function() vim.cmd([[Git blame]]) end

-- Git open fugitive window
M.git_fugitive = function() bufutil.toggle('fugitive', { cb = vim.cmd.G }) end

M.git_twiggy = function() bufutil.toggle('twiggy', { cb = vim.cmd.Twiggy }) end

-- Open permalink to current line in browser and copy to clipboard
M.git_link = function()
	require('gitlinker').get_buf_range_url(
		'n',
		{ action_callback = require('gitlinker.actions').open_in_browser }
	)
end

-- Git open log
M.git_log = function() vim.cmd([[G log]]) end

-- Git preview hunk under cursor
M.git_preview = function() require('gitsigns').preview_hunk() end

-- Reset git hunk under cursor
M.git_reset = function() require('gitsigns').reset_hunk() end

-- Stage git hunk under cursor
M.git_stage = function() require('gitsigns').stage_hunk() end

-- Unstage git hunk under cursor
M.git_unstage = function() require('gitsigns').undo_stage_hunk() end

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
M.goto_incoming = function() vim.lsp.buf.incoming_calls() end

-- Goto symbol outgoing calls
M.goto_outgoing = function() vim.lsp.buf.outgoing_calls() end

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
	return vim.z.enabled('args-view') and vim.cmd('ArgNext') or vim.cmd('next')
end

-- Jump to previous arg in arglist
M.jump_argprev = function()
	return vim.z.enabled('args-view') and vim.cmd('ArgPrev') or vim.cmd('prev')
end

-- Jump to next buffer in buffer list
M.jump_bufnext = function() vim.cmd('bnext') end

-- Jump to previous buffer in buffer list
M.jump_bufprev = function() vim.cmd('bprevious') end

-- Jump to next git hunk or diff chunk
M.jump_chunknext = function() require('gitsigns').next_hunk() end

-- Jump to prev git hunk or diff chunk
M.jump_chunkprev = function() require('gitsigns').prev_hunk() end

-- Jump to the next diagnostic
M.jump_errornext = function() vim.diagnostic.goto_next() end

-- Jump to the previous diagnostic
M.jump_errorprev = function() vim.diagnostic.goto_prev() end

-- Jump to next file in file tree
M.jump_filenext = function()
	local api = require('nvim-tree.api')
	if not api.tree.is_visible() then api.tree.open() end
	api.node.navigate.sibling.next()
	local path = api.tree.get_node_under_cursor().absolute_path
	if path ~= nil then vim.cmd('edit ' .. path) end
end

-- Jump to previous file in file tree
M.jump_fileprev = function()
	local api = require('nvim-tree.api')
	if not api.tree.is_visible() then api.tree.open() end
	api.node.navigate.sibling.prev()
	local path = api.tree.get_node_under_cursor().absolute_path
	if path ~= nil then vim.cmd('edit ' .. path) end
end

-- Jump to next entry in location list
M.jump_locnext = function()
	-- TODO: wrap around
	vim.cmd.lnext()
end

-- Jump to previous entry in location list
M.jump_locprev = function() vim.cmd.lprevious() end

-- Jump to next quickfix entry
M.jump_qfnext = function() qfutil.next_entry() end

-- Jump to previous quickfix entry
M.jump_qfprev = function() qfutil.prev_entry() end

-- Jump to next tab
M.jump_tabnext = function() vim.cmd('tabnext') end

-- Jump to previous tab
M.jump_tabprev = function() vim.cmd('tabprevious') end

-- Jump to next terminal
M.jump_termnext = function() vim.cmd('FloatermNext') end

-- Jump to previous terminal
M.jump_termprev = function() vim.cmd('FloatermPrev') end

-- Replace qf with newer error list
M.qf_cnewer = function() vim.cmd('cnewer') end

-- Replace qf with previous error list
M.qf_colder = function() vim.cmd('colder') end

-- Filter quickfix list by pattern
M.qf_global = function() greputils.qf_filter({ invert = false }) end

-- Filter quickfix list by exclude pattern
M.qf_vglobal = function() greputils.qf_filter({ invert = true }) end

-- Run align
M.run_align = function()
	bufutil.set_visual(bufutil.get_visual())
	vim.cmd([['<,'>EasyAlign]])
end

-- Delete buffer
M.run_bd = function() bufutil.delete() end

M.switch_project = require('utils.pickers.project')

-- stylua: ignore start
M.toggle_dapui       = daputil.toggle_ui
M.debug_start        = daputil.debug_start
M.debug_restart      = daputil.debug_restart
M.debug_terminate    = daputil.debug_terminate
M.debug_pause        = daputil.debug_pause
M.debug_step_into    = daputil.debug_step_into
M.debug_step_out     = daputil.debug_step_out
M.debug_step_over    = daputil.debug_step_over
M.debug_bp_toggle    = daputil.debug_bp_toggle
M.debug_bp_condition = daputil.debug_bp_condition
M.debug_bp_clear     = daputil.debug_bp_clear
M.debug_bp_list      = daputil.debug_bp_list
M.debug_hover        = daputil.debug_hover
M.debug_preview      = daputil.debug_preview
M.debug_to_cursor    = daputil.debug_to_cursor
M.debug_open_log     = daputil.debug_open_log
M.debug_toggle_repl  = daputil.debug_toggle_repl
-- stylua: ignore end

-- Run code action
M.run_code = function() vim.lsp.buf.code_action() end

-- Create new unnamed buffer
M.run_enew = function() vim.cmd('enew') end

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
M.run_grep = function() greputils.grep_pattern(nil) end

-- xdg-open
M.run_gx = function() vim.cmd('Browse') end

-- Open messages
M.messages = function() vim.cmd('Messages') end

-- Open lsp info
M.lsp_info = function() lsputil.open_config() end

-- Run make command
M.run_make = function()
	return bufutil.is_file() and vim.cmd([[make %]])
		or vim.notify('not implemented', vim.log.levels.WARN)
end

-- Maximize window
M.run_maximize = function() vim.cmd([[resize +999 | vertical resize +999]]) end

-- Generate documentation
M.run_neogen = function() vim.cmd('Neogen') end

-- Replace symbol under cursor
M.run_rename = function()
	return lsputil.is_attached() and vim.lsp.buf.rename()
		or vim.notify('not implemented', vim.log.levels.WARN)
end

-- Replace symbol under cursor (remember <c-w> to delete word)
M.run_replace = function()
	local text = tostring(vim.fn.expand('<cword>'))
	if vim.fn.mode() == 'v' then
		text = table.concat(bufutil.get_visual().text, '\\n')
		text = string.gsub(text, '\r', '\\r')
		text = string.gsub(text, '\t', '\\t')
	end
	local repl = string.gsub(text, '\\n', '\\r')
	local cmd = '<esc>:%s/'
		.. text
		.. '/'
		.. repl
		.. '/g<left><left><bs>'
		.. string.sub(text, -1, -1)
	cmd = vim.api.nvim_replace_termcodes(cmd, true, true, true)
	vim.api.nvim_feedkeys(cmd, 'n', true)
end

-- Source vim buffer contents
M.run_source = function() vim.cmd.source('%') end

-- Spawn new terminal window in current dir
M.run_spawn = function() vim.fn.system('st >/dev/null 2>&1 & disown $!') end

-- Run star search on buffer, directory, git root, or project root
M.run_star = function()
	local pattern = bufutil.is_visual()
			and table.concat(bufutil.get_visual().text, '')
		or tostring(vim.fn.expand('<cword>'))
	greputils.grep_pattern(pattern)
end

-- Open new tab
M.run_tabnew = function() vim.cmd('tabnew') end

-- Create new zk entry
M.run_zknew = function()
	local title = vim.fn.input('Title: ')
	if title ~= nil and title ~= '' then
		require('zk.commands').get('ZkNew')({ title = title })
	end
end

-- Highlight symbol under cursor
M.show_highlight = function() lsputil.wrap(vim.lsp.buf.document_highlight) end

-- Show hover information
M.show_hover = function() lsputil.wrap(vim.lsp.buf.hover) end

-- Show function signature help
M.show_signature = function() lsputil.wrap(vim.lsp.buf.signature_help) end

-- Toggle side tree
M.toggle_ntree = function()
	require('nvim-tree.api').tree.toggle({ focus = false })
end

-- Open oil
M.toggle_oil = function() vim.cmd([[Oil]]) end

-- Toggle global option
M.toggle_option = function() require('utils.pickers.options')() end

-- Toggle symbols outline window
M.toggle_outline = function()
	return lsputil.is_attached()
			and bufutil.toggle('Outline', {
				focus = false,
				cb = function()
					vim.cmd('SymbolsOutlineOpen')
					local group = vim.api.nvim_create_augroup(
						'toggle-symbols-outline',
						{ clear = true }
					)
					local winid = vim.api.nvim_get_current_win()
					vim.api.nvim_create_autocmd({ 'BufEnter' }, {
						group = group,
						callback = vim.schedule_wrap(function()
							local ft = vim.bo.filetype
							if ft == 'Outline' then
								vim.api.nvim_del_augroup_by_id(group)
								vim.api.nvim_set_current_win(winid)
							end
						end),
					})
				end,
			})
		or vim.notify('lsp not attached or not ready', vim.log.levels.WARN)
end

-- Toggle quickfix window
M.toggle_quickfix = function() bufutil.toggle('qf', { cb = qfutil.open }) end

-- Toggle terminal window
M.toggle_term = function() vim.cmd('FloatermToggle') end

-- Open new terminal
M.newterm = function() vim.cmd('FloatermNew') end

-- Open keyword under cursor or selection. Tries to resolve cword and cWORD
-- as such:
--
-- vim.o.keywordprg
--     o.keywordprg
--       keywordprg
--
-- This is required because of https://github.com/neovim/neovim/pull/24331
M.keywordprg = function()
	if not vim.o.keywordprg then
		return vim.notify('info: keywordprg not set', vim.log.levels.WARN)
	end
	local cexprs = {}
	vim.list_extend(cexprs, bufutil.get_cexprs({ reverse = true }))
	vim.list_extend(cexprs, bufutil.get_cexprs({ reverse = false }))
	for _, pattern in ipairs(cexprs) do
		local status =
			pcall(vim.api.nvim_exec2, vim.o.keywordprg .. ' ' .. pattern, {})
		if status then return end
	end
	vim.notify(vim.o.keywordprg .. ' not found', vim.log.levels.WARN)
end

local function help(key) vim.cmd('WhichKey ' .. key) end

M.help_leader = function() help('<leader>') end
M.help_g = function() help('g') end
M.help_find = function() help('<leader>f') end
M.help_git = function() help('<leader>g') end
M.help_debug = function() help('<leader>d') end
M.help_quickfix = function() help('<leader>q') end
M.help_test = function() help('<leader>t') end
M.help_window = function() help('<leader>w') end
M.help_jumpn = function() help(']') end
M.help_jumpp = function() help('[') end

return M
