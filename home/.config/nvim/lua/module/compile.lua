--- Compile
--
-- Provides :C/Compile <cmd>  - works like M-x compile
--          :R/Recompile[!]
--
-- TODO: refactor this
--
assert(vim.z.mloaded('log'), 'log module is not loaded')

local history = {}

local MAX_CWD_LEN = 20

local strings_util = require('utils.strings')

local function short_path(cwd)
	local str = strings_util.truncate_path(cwd, MAX_CWD_LEN)
	local offset = string.sub(str, 1, 3) == '…' and 2 or 0
	return str, offset
end

local function find_compile_window()
	local wins = vim.api.nvim_tabpage_list_wins(0)
	for _, win_id in ipairs(wins) do
		local bufnr = vim.api.nvim_win_get_buf(win_id)
		local cmd = vim.fn.getbufvar(bufnr, 'compile')
		if cmd ~= '' then return win_id end
	end
	return nil
end

local function remove_history_duplicates()
	local cache = {}
	for i = #history, 1, -1 do
		local item = history[i]
		local key = item.cwd .. '//' .. item.cmd
		if cache[key] ~= nil then
			table.remove(history, i)
		else
			cache[key] = true
		end
	end
end

local function compile(cmd, cwd)
	if vim.fn.isdirectory(cwd) ~= 1 then
		return warn('Invalid directory: ' .. cwd)
	end
	local win_id = find_compile_window()
	if win_id ~= nil then
		vim.api.nvim_set_current_win(win_id)
		vim.cmd('te! ' .. cmd)
	else
		vim.cmd('cd! ' .. cwd)
		vim.cmd('bo te! ' .. cmd)
	end
	local bufnr = vim.fn.bufnr()
	vim.api.nvim_buf_set_var(bufnr, 'compile', cmd)
	local pid = vim.fn.getbufvar(vim.fn.bufnr(), 'terminal_job_pid')
	local short, offset = short_path(cwd)
	table.insert(history, {
		bufnr = bufnr,
		cwd = cwd,
		cmd = cmd,
		pid = pid,
		short = short,
		offset = offset,
	})
	vim.cmd('wincmd p')
	remove_history_duplicates()
end

local function recompile_cmd(tbl)
	if #history == 0 then
		return warn('Command history is empty - cannot recompile')
	end
	local index, cmd = tbl.args:match('^%[#(%d+)%].*%$%s*(.*)$')
	if #tbl.fargs == 0 then index = #history end
	local item = history[tonumber(index)]
	if not item then return warn('Invalid recompile argument') end
	compile(cmd or item.cmd, item.cwd)
end

local function itemize(max_len)
	return function(idx, item)
		return string.format(
			'%-4s %-' .. tostring(max_len + item.offset) .. 's $ %s',
			'[#' .. idx .. ']',
			item.short,
			item.cmd
		)
	end
end

local function recompile_complete_nr(A, L)
	local max_len = vim
		.iter(history)
		:map(function(item) return string.len(item.short) - item.offset end)
		:fold(0, math.max)
	local start = string.find(L, '%S%s') + 2
	local search = string.sub(L, start):gsub('^%s+', '')
	local completions = vim
		.iter(history)
		:enumerate()
		:map(itemize(max_len))
		:rev()
		:filter(function(str) return string.sub(str, 1, #search) == search end)
		:map(
			function(str)
				return #search > 0 and string.sub(str, #search - #A + 1) or str
			end
		)
		:take(4)
		:totable()
	return completions
end

for _, command in pairs({ 'C', 'Compile' }) do
	vim.api.nvim_create_user_command(
		command,
		function(tbl) compile(tbl.args, vim.fn.getcwd()) end,
		{ nargs = '+', complete = 'shellcmdline' }
	)
end

for _, command in pairs({ 'R', 'Recompile' }) do
	vim.api.nvim_create_user_command(
		command,
		recompile_cmd,
		{ nargs = '?', complete = recompile_complete_nr }
	)
end
