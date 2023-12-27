--- Arglistview
--
-- Creates a window with the current argument list.

local group, ns, buffer, win

local bufname = '__arglist__'

---@param path string
---@return string
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
		-- TODO: fix this - '…'
		return '...' .. tpath
	end
	return tpath
end

---@param max_width number
local function get_arglist(max_width)
	local idx = vim.fn.argidx() + 1
	local list = { ':Arglist:' }
	local max_len = 0
	local arglist = vim.fn.argv()
	if arglist == nil or type(arglist) ~= 'table' or #arglist == 0 then
		return {}, 0
	end
	for i, arg in ipairs(arglist) do
		local str = trim_path(arg, max_width - 3)
		local len = string.len(str)
		if arg == vim.fn.expand('%') then
			-- TODO: fix this - ›, », ❯
			str = str .. ' <'
			len = len + 2
			if i ~= idx then
				vim.cmd('argu ' .. i)
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
		table.insert(formatted_list, string.format('%' .. max_width .. 's', item))
	end
	return formatted_list
end

local function setup()
	pcall(vim.api.nvim_buf_delete, vim.fn.bufnr(bufname), { force = true })
	pcall(vim.api.nvim_del_augroup_by_name, group)
	ns = vim.api.nvim_create_namespace('arglist')
	buffer = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buffer, bufname)
	win = vim.api.nvim_open_win(buffer, false, {
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
end

local function update()
	if #vim.fn.win_findbuf(buffer) < 1 then
		setup()
	end
	local trim_width = 30
	local arglist, max_len = get_arglist(trim_width)
	local editor_width = vim.api.nvim_get_option_value('columns', {})
	local list = format_list(arglist, max_len)
	local cols = max_len + 1
	local opts = {
		relative = 'editor',
		row = 2,
		col = editor_width - cols,
		width = #arglist > 0 and cols or 1,
		height = #arglist > 0 and #arglist or 1,
		hide = #arglist == 0,
		focusable = false,
	}
	vim.api.nvim_win_set_config(win, opts)
	vim.api.nvim_buf_set_lines(buffer, 0, #arglist - 1, false, list)
	vim.highlight.range(buffer, ns, 'Cursor', { 0, 0 }, { 0, -1 })
	vim.highlight.range(buffer, ns, 'Title', { 1, 0 }, { cols, -1 })
end

group = vim.api.nvim_create_augroup('arglist_view', { clear = true })

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
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
})
