local buffer = require('completions.buffer')

---@class CompletionMatch
---@field word string
---@field kind string
---@field info? string
---@field menu? string
---@field source string

---@class CompetionSource
---@field name string
---@field items CompletionSourceItem[]

---@class CompletionSourceItem
---@field value string
---@field source string

---@class CompletionSource
---@field public name string
---@field public items CompletionSourceItem[]
---@field protected ctx CompletionContext

---@class CompletionOpts
---@field max_items number
---@field debounce_time number
---@field sources { buffer: { debounce_time: number, min_length: number }}

---@class CompletionContext
---@field public  opts    CompletionOpts
---@field private matches CompletionMatch[]
---@field public  keyword string
---@field private sources { [string]: CompletionSource }
---@field public  evgroup integer
---@field private timer   uv_timer_t
---@field private enabled boolean
local Context = {}

---@param opts CompletionOpts
---@return CompletionContext
function Context:new(opts)
	---@type CompletionContext
	local obj = {
		opts = opts,
		matches = {},
		keyword = '',
		sources = {},
		evgroup = 0,
		timer = vim.loop.new_timer(),
		enabled = true,
	}
	setmetatable(obj, { __index = self })
	obj:setup_autocmds()
	obj:setup_sources()
	return obj
end

---@public
---@param opts { complete: boolean }
function Context:update(opts)
	if self.timer:is_active() then
		self.timer:stop()
	end
	self.timer:start(
		self.opts.debounce_time,
		0,
		vim.schedule_wrap(function()
			if self:should_update() then
				self:refresh_keyword()
				self:refresh_matches()
				if opts and opts.complete then
					self:complete()
				end
			end
		end)
	)
end

---@private
function Context:should_update()
	local mode = vim.api.nvim_get_mode().mode
	return mode == 'ic' or mode == 'i'
end

---@private
function Context:refresh_keyword()
	local col = vim.fn.col('.')
	local line = vim.api.nvim_get_current_line()
	local word = line:sub(1, col - 1):match('%w+$') or ''
	self.keyword = word
end

---@private
function Context:refresh_matches()
	local items = {}
	vim.list_extend(items, self.sources.buffer.items)
	items = self:items_filter(items)
	items = self:items_sort(items)
	items = self:items_limit(items)
	self.matches = self:format_items(items)
end

---@private
function Context:complete()
	if self.enabled then
		vim.fn.complete(vim.fn.col('.') - #self.keyword, self.matches)
	end
end

---@private
---@param items CompletionSourceItem[]
---@return CompletionSourceItem[]
function Context:items_filter(items)
	---@param item CompletionSourceItem
	return vim.tbl_filter(function(item)
		if
			item.source == 'buffer'
			and #self.keyword < self.opts.sources.buffer.min_length
		then
			return false
		end
		return item.value:match(self.keyword)
	end, items)
end

---@private
---@param items CompletionSourceItem[]
---@return CompletionSourceItem[]
function Context:items_sort(items)
	return table.sort(items, function(a, b)
		return #a.value < #b.value
	end) or items
end

---@private
---@param items CompletionSourceItem[]
---@return CompletionSourceItem[]
function Context:items_limit(items)
	return vim.list_slice(items, 1, self.opts.max_items)
end

---@private
---@param items CompletionSourceItem[]
---@return CompletionMatch[]
function Context:format_items(items)
	---@param item CompletionSourceItem
	return vim.tbl_map(function(item)
		---@type CompletionMatch
		return {
			word = item.value,
			info = '',
			kind = string.format('[%s]', item.source),
			menu = '',
			source = item.source,
		}
	end, items)
end

---@private
function Context:setup_autocmds()
	self.evgroup = vim.api.nvim_create_augroup('completions', { clear = true })
	vim.api.nvim_create_autocmd('CursorMovedI', {
		group = self.evgroup,
		callback = function()
			self:update({ complete = false })
		end,
	})
	vim.api.nvim_create_autocmd('CursorHoldI', {
		group = self.evgroup,
		callback = vim.schedule_wrap(function()
			self:complete()
		end),
	})
end

function Context:setup_sources()
	self.sources.buffer = buffer:new(self)
end

function Context:toggle()
	self.enabled = not self.enabled
end

function Context:on_complete(selected)
	if selected.source == 'buffer' then
		vim.api.nvim_feedkeys(' ', 'i', true)
	end
end

---@param fallback string
function Context:accept(fallback)
	assert(fallback, 'fallback keybinding is required')
	self.enabled = not self.enabled
	local index = vim.fn.complete_info({ 'selected' }).selected
	if index < 0 then
		local fallback_keys =
			vim.api.nvim_replace_termcodes(fallback, true, false, true)
		vim.api.nvim_feedkeys(fallback_keys, 'i', true)
		return
	end
	local selected = self.matches[index + 1]
	local accept_keys = vim.api.nvim_replace_termcodes('<c-y>', true, false, true)
	vim.api.nvim_feedkeys(accept_keys, 'i', true)
	vim.schedule(function()
		self:on_complete(selected)
	end)
end

return Context
