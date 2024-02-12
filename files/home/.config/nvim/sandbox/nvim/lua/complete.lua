local fzy = require('libfzy')
local ls = require('luasnip')

vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.shortmess:append('c')

local timer1 = vim.uv.new_timer()
local timer2 = vim.uv.new_timer()
local timer3 = vim.uv.new_timer()
local debounce_time1 = 50
local debounce_time2 = 200
local debounce_time3 = 50

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

local function get_cWORD_dir()
	if not cWORD:match('^[%.]?[%.%~]?/') then return end
	local dir = vim.fn.fnamemodify(cWORD, ':h')
	if not dir then return end
	if vim.fn.isdirectory(vim.fn.expand(dir)) == 0 then return end
	return dir
end

local function update_words()
	buffer = {}
	local seen = {}
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for _, line in ipairs(lines) do
		for _, str in ipairs(vim.split(line, ' ')) do
			if not seen[str] then
				for substr in str:gmatch('%w%w%w+') do
					seen[substr] = true
					table.insert(buffer, {
						word = substr,
						abbr = substr,
						kind = '[w]',
						user_data = { mode = 'buffer' },
					})
				end
			end
		end
	end
end

-- "~/" "/" "./" will enter path mode
-- "#" "@" will enter snippet mode if any snippet is available
-- if lsp items are available, enters lsp mode
-- anything else enters buffer words mode
local function update_mode()
	local dir = get_cWORD_dir()
	if dir then
		mode = 'path'
		return
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
		log(col, offset, mode, cWORD, #items, #buffer)
		vim.fn.complete(col - offset + 1, items)
	end
end

local offset_map = {
	buffer = function() offset = #word end,
	path = function() offset = #cWORD:match('[^/]*$') end,
	lsp = function() offset = #word end,
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
		items = {}
		if #word < 3 then return end
		for _, item in ipairs(buffer) do
			if word ~= item.word then
				item.user_data.score = fzy.score(word, item.word, false)
				table.insert(items, item)
			end
		end
	end,
	path = function()
		local dir = get_cWORD_dir()
		items = {}
		for _, item in ipairs(path['_current'] or {}) do
			if dir == item.user_data.dir then
				item.user_data.score = fzy.score(cWORD, item.user_data.path, false)
				table.insert(items, item)
			end
		end
	end,
	lsp = function() end,
	snippet = function()
		items = snippet[vim.bo.filetype] or {}
		for _, item in ipairs(items) do
			item.user_data.score = fzy.score(cWORD:sub(2, -1), item.word, false)
		end
	end,
}

local function update_items()
	item_map[mode]()
	sort_items()
end

local feed = function(keys)
	local rkeys = vim.api.nvim_replace_termcodes(keys, true, true, true)
	vim.api.nvim_feedkeys(rkeys, 'i', true)
end

local trigger = debounced(timer2, debounce_time1, function()
	if vim.fn.complete_info({ 'selected' }).selected ~= -1 then return end
	update_input()
	update_mode()
	update_offset()
	update_items()
	complete()
end)

local accept_map = {
	buffer = function() feed('<c-y> ') end,
	snippet = function()
		feed('<c-y>')
		vim.schedule(function()
			if ls.expandable() then ls.expand() end
		end)
	end,
	path = function(item)
		feed('<c-y>')
		if item.user_data.is_dir then
			feed('<c-y>')
		else
			feed('<c-y> ')
		end
	end,
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
	callback = debounced(timer1, debounce_time2, function() update_words() end),
})

local function update_snippets()
	local ft = vim.bo.filetype
	if snippet[ft] then return end
	snippet[ft] = {}
	local snippets = require('luasnip').available()
	for _, list in pairs(snippets) do
		for _, item in ipairs(list) do
			table.insert(snippet[ft], {
				word = item.trigger,
				abbr = item.name,
				info = item.description[1],
				menu = item.description[1],
				kind = '[s]',
				user_data = { mode = 'snippet' },
			})
		end
	end
end

vim.api.nvim_create_autocmd({
	'BufEnter',
}, {
	group = evgroup,
	callback = update_snippets,
})

vim.keymap.set({ 'i' }, '<tab>', function()
	if vim.fn.pumvisible() == 0 then return '<tab>' end
	accept()
end, { expr = true })

vim.keymap.set({ 'i' }, '<cr>', function()
	if not vim.fn.pumvisible() then return '<cr>' end
	return '<c-e><cr>'
end, { expr = true })

local function update_paths()
	local dir = get_cWORD_dir()
	if not dir then return end
	if path[dir] then
		path['_current'] = path[dir]
		return
	end
	local files = vim.fn.readdir(vim.fn.expand(dir))
	if not files then return end
	path['_current'] = {}
	for _, file in ipairs(files) do
		local filepath = dir .. '/' .. file
		local is_dir = vim.fn.isdirectory(vim.fn.expand(filepath)) == 1
		table.insert(path['_current'], {
			word = is_dir and file .. '/' or file,
			kind = '[p]',
			user_data = {
				mode = 'path',
				path = is_dir and filepath .. '/' or filepath,
				dir = dir,
				is_dir = is_dir,
			},
		})
	end
	path[dir] = path['_current']
end

vim.api.nvim_create_autocmd({
	'CursorMovedI',
}, {
	group = evgroup,
	callback = debounced(timer3, debounce_time3, function()
		update_paths()
		trigger()
	end),
})

-- TODO: lsp
