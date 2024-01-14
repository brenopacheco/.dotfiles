--[[
sources: 
  1. buffer : should update on TextChanged,TextChangedI,TextChangedP
  2. other listed and loaded buffers
  3. lsp
  4. treesitter
  5. snippets
--]]

local buffer_refresh_debounce_time = 500
local text_change_debounce_time = 300


local function debounce(delay, callback)
	local timer = vim.loop.new_timer()
	local wraped_callback = vim.schedule_wrap(function(...)
		local args = { ... }
		callback(unpack(args))
	end)
	return function(...)
		if timer:is_active() then
			timer:stop()
		end
		timer:start(delay, 0, wraped_callback)
	end
end

vim.o.completeopt = 'menuone,noinsert'

local completions = {
	keyword = '',
	---@type string[]
	matches = {},
	sources = {
		---@type string[]
		buffer = {},
	},
}

local group = vim.api.nvim_create_augroup('completion-module', { clear = true })

local get_keyword = function()
	local col = vim.fn.col('.')
	local line = vim.api.nvim_get_current_line()
	local word = line:sub(1, col - 1):match('%w+$')
	return word or ''
end

local get_matches = function()
	local matches = {}
	if #completions.keyword < 2 then
		return matches
	end
	for _, word in ipairs(completions.sources.buffer) do
		if word:match(completions.keyword) then
			table.insert(matches, word)
		end
	end
	return matches
end

local format_matches = function(matches)
	local items = {}
	for _, word in ipairs(matches) do
		table.insert(items, {
			word = word,
			info = 'some info',
			kind = '[W]',
			menu = 'extra?',
		})
	end
	return items
end

function completions:complete()
	pdebug(completions.keyword, tostring(#completions.matches))
	if vim.api.nvim_get_mode().mode == 'i' then
		vim.fn.complete(vim.fn.col('.') - #completions.keyword, format_matches(completions.matches))
	end
end

local on_text_changed = debounce(text_change_debounce_time, function()
	completions.keyword = get_keyword()
	completions.matches = get_matches()
	completions:complete()
end)

vim.api.nvim_create_autocmd({ 'TextChangedI', 'CursorMovedI' }, {
	nested = true,
	group = group,
	callback = on_text_changed,
})

vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
	nested = true,
	group = group,
	pattern = '*:i',
	callback = on_text_changed,
})

---@params bufnr integer
---@return string[]
local get_buffer_words = function(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local words = {}
	for _, line in ipairs(lines) do
		for match in line:gmatch('%w%w%w+') do
			words[match] = true
		end
	end
	return vim.tbl_keys(words)
end

local refresh_buffer_source = debounce(buffer_refresh_debounce_time, function()
	completions.sources.buffer = get_buffer_words(0)
	vim.api.nvim_exec_autocmds('User', { pattern = 'CompletionSourcesUpdated' })
end)

vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'TextChangedP' }, {
	nested = true,
	desc = 'Recalculates buffer source',
	group = group,
	callback = function(ev)
		return ev.buf == vim.api.nvim_get_current_buf() and refresh_buffer_source()
	end,
})

vim.api.nvim_create_autocmd({ 'User' }, {
	nested = true,
	pattern = 'CompletionSourcesUpdated',
	group = group,
	callback = vim.schedule_wrap(function()
		-- pdebug('sources updated - #buffers: ' .. #completions.sources.buffer)
	end),
})
