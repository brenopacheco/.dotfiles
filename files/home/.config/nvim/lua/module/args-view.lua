--- Arglistview
--
-- Creates a window with the current argument list.
-- Provides the :ArgNext, :ArgPrev, :ArgClear, :ArgDelete, :ArgAdd commands.

local group, ns, bufnr, winnr, autocmd

local bufname = '__arglist__'

---@param path string
---@return string, number : trimmed path, length of trimmed path
local function trim_path(path, len)
	local match
	local tpath = tostring(path)
	while true do
		if string.len(tpath) <= len or string.find(tpath, '^/?[^/]+$') then
			break
		end
		tpath, match = string.gsub(tpath, '^/[^/]+', '')
		if match == 0 then
			break
		end
	end
	if string.len(path) > string.len(tpath) then
		return '…' .. tpath, string.len(tpath) + 1
	end
	return tpath, string.len(tpath)
end

---@param list string[]
local function resolve_paths(list)
	return vim.tbl_map(function(item)
		return tostring(vim.fn.fnamemodify(item, ':p'))
	end, list)
end

---@param max_width number
local function get_arglist(max_width)
	local idx = vim.fn.argidx() + 1
	local list = { ':Arglist:' }
	local max_len = 9
	local arglist = vim.fn.argv()
	if arglist == nil or type(arglist) ~= 'table' or #arglist == 0 then
		return {}, 0
	end
	for i, arg in ipairs(resolve_paths(arglist)) do
		local str, len = trim_path(arg, max_width - 3)
		if arg == vim.fn.expand('%:p') then
			str = str .. ' ❰'
			len = len + 2
			if i ~= idx then
				vim.cmd('silent! argu ' .. i)
			end
		end
		if len > max_len then
			max_len = len
		end
		table.insert(list, str)
	end
	return list, max_len
end

---@param list string[]
local function format_list(list, max_width)
	local formatted_list = {}
	for _, item in ipairs(list) do
		local path_special = string.match(item, '…')
		local sel_special = string.match(item, '❰')
		local width = max_width
		if path_special then
			width = width + 2
		end
		if sel_special then
			width = width + 2
		end
		table.insert(formatted_list, string.format('%' .. width .. 's', item))
	end
	return formatted_list
end

---@param update fun():nil
local function setup(update)
	pcall(vim.api.nvim_buf_delete, vim.fn.bufnr(bufname), { force = true })
	pcall(vim.api.nvim_del_augroup_by_name, group)
	ns = vim.api.nvim_create_namespace('arglist')
	bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(bufnr, bufname)
	winnr = vim.api.nvim_open_win(bufnr, false, {
		relative = 'editor',
		row = 0,
		col = 0,
		width = 1,
		height = 1,
		focusable = false,
		zindex = 500,
		border = 'none',
		style = 'minimal',
		hide = true,
	})
	autocmd = vim.api.nvim_create_autocmd({ 'WinClosed' }, {
		desc = 'Reset arg list window on close',
		group = group,
		pattern = { tostring(winnr) },
		callback = function()
			pcall(vim.api.nvim_del_autocmd, autocmd)
			if #vim.fn.argv() ~= 0 then
				vim.schedule(update)
			end
		end,
		nested = true,
	})
end

local function update()
	if not vim.list_contains(vim.api.nvim_tabpage_list_wins(0), winnr) then
		setup(update)
	end
	local trim_width = 30
	local arglist, max_len = get_arglist(trim_width)
	local editor_width = vim.api.nvim_get_option_value('columns', {})
	local list = format_list(arglist, max_len)
	local cols = max_len + 2
	local opts = {
		relative = 'editor',
		row = 2,
		col = editor_width - cols,
		width = #arglist > 0 and cols or 1,
		height = #arglist > 0 and #arglist or 1,
		hide = #arglist == 0,
		focusable = false,
	}
	vim.api.nvim_win_set_config(winnr, opts)
	vim.api.nvim_buf_set_lines(bufnr, 0, #arglist - 1, false, list)
	vim.highlight.range(bufnr, ns, 'Cursor', { 0, 0 }, { 0, -1 })
	vim.highlight.range(bufnr, ns, 'Title', { 1, 0 }, { cols, -1 })
end

group = vim.api.nvim_create_augroup('arglist_view', { clear = true })

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
	nested = true,
	desc = 'Show arg list in floating window',
	group = group,
	callback = function()
		if #vim.fn.argv() ~= 0 then
			update()
		end
	end,
})

vim.api.nvim_create_autocmd('User', {
	desc = 'Update arg list shown in floating window',
	pattern = 'ArgsChanged',
	group = group,
	callback = update,
	nested = true,
})

local notify = function(msg)
	vim.api.nvim_exec_autocmds('User', { pattern = 'ArgsChanged' })
	vim.notify(msg, vim.log.levels.INFO)
end

local err = function(msg)
	vim.notify(msg, vim.log.levels.WARN)
end

-- Add buffer to arglist
local args_add = function()
	if tostring(vim.fn.bufname()) == '' then
		return err('error: the buffer is not associated with a file')
	end
	vim.cmd('$argadd')
	vim.cmd('argdedupe')
  vim.cmd('silent! argu ' .. vim.fn.argc())
	notify('info: "' .. vim.fn.expand('%') .. '" added to arglist')
end

local args_clear = function()
	vim.cmd('argdelete *')
	notify('info: arglist cleared')
end

local args_delete = function()
	local args = vim.fn.argv() or {}
	if type(args) ~= 'table' then
		return err('error: arglist is empty')
	end
	if not vim.list_contains(args, tostring(vim.fn.bufname())) then
		return err('error: buffer is not in arglist')
	end
	vim.cmd('argdelete %')
	notify('info: "' .. vim.fn.expand('%') .. '" removed from arglist')
end

local args_next = function()
	if vim.fn.argc() == 0 then
		return err('error: arglist is empty')
	end
	local idx = vim.fn.argidx() + 1 >= vim.fn.argc() and '1'
		or tostring(vim.fn.argidx() + 2)
	vim.cmd('silent! argu ' .. idx)
	notify('info: "' .. vim.fn.expand('%') .. '"')
end

local args_prev = function()
	if vim.fn.argc() == 0 then
		return err('error: arglist is empty')
	end
	local idx = vim.fn.argidx() == 0 and tostring(vim.fn.argc())
		or tostring(vim.fn.argidx())
	vim.cmd('silent! argu ' .. idx)
	notify('info: "' .. vim.fn.expand('%') .. '"')
end

vim.api.nvim_create_user_command('ArgNext', args_next, { nargs = 0 })
vim.api.nvim_create_user_command('ArgPrev', args_prev, { nargs = 0 })
vim.api.nvim_create_user_command('ArgClear', args_clear, { nargs = 0 })
vim.api.nvim_create_user_command('ArgDelete', args_delete, { nargs = 0 })
vim.api.nvim_create_user_command('ArgAdd', args_add, { nargs = 0 })
