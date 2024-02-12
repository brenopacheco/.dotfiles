local fzy = require('libfzy')

vim.opt.completeopt = 'menu,menuone,noselect'

local timer1 = vim.uv.new_timer()
local timer2 = vim.uv.new_timer()
local debounce_time1 = 50
local debounce_time2 = 300

local evgroup = vim.api.nvim_create_augroup('completion', { clear = true })

local buffer = {}
local lsp = {}
local snippet = {}
local path = {}

local items = {}
local cWORD = ''
local word = ''
local keyword = ''
local col = -1
local offset = 0
local mode = 'buffer'

local function debounced(timer, debounce_time, cb)
	return vim.schedule_wrap(function()
		if timer:is_active() then timer:stop() end
		timer:start(debounce_time, 0, vim.schedule_wrap(cb))
	end)
end

local function is_insert_mode() return vim.api.nvim_get_mode().mode:match('i') end

local function update_words()
	buffer = {}
	local seen = {}
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for _, line in ipairs(lines) do
		for _, str in ipairs(vim.split(line, ' ')) do
			if not seen[str] and str:match('%w%w%w+') then
				seen[str] = true
				table.insert(buffer, {
					word = str,
					abbr = str,
					kind = '[w]',
					user_data = { mode = 'buffer' },
				})
			end
		end
	end
end

-- "~/" "/" "./" will enter path mode
-- "#" "@" will enter snippet mode if any snippet is available
-- if lsp items are available, enters lsp mode
-- anything else enters buffer words mode
local function update_mode()
	for _, pat in ipairs({ '^/', '^%./', '^%~/' }) do
		if cWORD:match(pat) then
			mode = 'path'
			return
		end
	end
	if cWORD:match('[@#]%w*$') then
		mode = 'snippet'
		return
	end
	if keyword and lsp[keyword] and #lsp[keyword] > 0 then
		mode = 'lsp'
		return
	end
	mode = 'buffer'
end

local function update_input()
	if not is_insert_mode() then return end
	_, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local line_to_cursor = line:sub(1, col)
	cWORD = line_to_cursor:match('%S+$') or ''
	word = line_to_cursor:match('%w+$') or ''
	keyword = vim.fn.matchstr(line_to_cursor, '\\k*$')
end

local function complete()
	if is_insert_mode() and #items > 0 then
		log(col, offset, mode, word, #items, #buffer)
		vim.fn.complete(col - offset, items)
	end
end

local offset_map = {
	buffer = function() offset = #buffer end,
	path = function() offset = #cWORD end,
	lsp = function() offset = #buffer end,
	snippet = function() offset = #cWORD end,
}

local function update_offset() offset_map[mode]() end

local sort_items = function()
	table.sort(
		items,
		function(a, b) return a.user_data.score > b.user_data.score end
	)
end

local item_map = {
	buffer = function()
		if #word < 3 then
			items = {}
			return
		end
		items = vim
			.iter(buffer)
			:filter(
				function(item)
					return word ~= item.word and fzy.has_match(word, item.word, false)
				end
			)
			:map(function(item)
				item.user_data.score = fzy.score(word, item.word, false)
				return item
			end)
			:totable()
	end,
	path = function() end,
	lsp = function() end,
	snippet = function() end,
}

local function update_items()
	item_map[mode]()
	sort_items()
end

local feed = function(keys)
	local rkeys = vim.api.nvim_replace_termcodes(keys, true, true, true)
	vim.api.nvim_feedkeys(rkeys, 'i', true)
end

local accept_map = {
	buffer = function(item) feed('<c-y> ') end,
}

local function accept()
	local info = vim.fn.complete_info({ 'selected', 'items' })
	if not info then return end
	if info.selected == -1 then
		feed('<c-n>')
		vim.schedule(accept)
	end
	local item = items[info.selected + 1]
	if not item then return end
	accept_map[item.user_data.mode](item)
end

local trigger = debounced(timer2, debounce_time1, function()
	if vim.fn.complete_info({ 'selected' }).selected ~= -1 then return end
	update_input()
	update_mode()
	update_offset()
	update_items()
	complete()
end)

vim.api.nvim_create_autocmd({
	'CursorMovedI',
}, {
	group = evgroup,
	callback = trigger,
})

vim.api.nvim_create_autocmd({
	'TextChanged',
	'TextChangedI',
}, {
	group = evgroup,
	callback = debounced(timer1, debounce_time2, function()
		update_words()
		trigger()
	end),
})

vim.keymap.set({ 'i' }, '<tab>', function()
	if not vim.fn.pumvisible() then return '<tab>' end
	accept()
end, { expr = true })
