local buffer = require('completions.buffer')
local events = require('completions.events')

---@class CompletionMatch
---@field word string
---@field kind string
---@field info? string
---@field menu? string

---@class CompetionSource
---@field name string
---@field items CompletionSourceItem[]

---@alias CompletionSourceItem string

---@class CompletionSource
---@field public name string
---@field public items CompletionSourceItem[]
---@field protected ctx CompletionContext

---@class CompletionOpts
---@field max_items number
---@field debounce_time number
---@field sources { buffer: { debounce_time: number }}

---@class CompletionContextSources
---@field buffer CompletionSource

---@class CompletionContext
---@field public  opts    CompletionOpts            : maximum number of matches to show
---@field private matches CompletionMatch[]         : the list of sources that match a keyword
---@field private keyword string                    : the keyword to match
---@field private sources CompletionContextSources  : source items
---@field public  evgroup integer                   : event group id
---@field private timer   uv_timer_t                : timer to debounce updates
local ctx = {}

---@param opts CompletionOpts
---@return CompletionContext
function ctx:new(opts)
	---@type CompletionContext
	local obj = setmetatable({
		opts = opts,
		matches = {},
		keyword = '',
		sources = { buffer = {} },
		evgroup = 0,
		timer = vim.loop.new_timer(),
	}, { __index = self })
	obj.evgroup = events.init(obj)
	obj.sources.buffer = buffer:new(obj)
	return obj
end

---@public
function ctx:update()
	if self.timer:is_active() then
		self.timer:stop()
	end
	self.timer:start(
		self.opts.debounce_time,
		0,
		vim.schedule_wrap(function()
			self:refresh_keyword()
			self:refresh_matches()
			self:complete()
		end)
	)
end

---@private
function ctx:refresh_keyword()
	local col = vim.fn.col('.')
	local line = vim.api.nvim_get_current_line()
	local word = line:sub(1, col - 1):match('%w+$') or ''
	self.keyword = word
end

---@private
function ctx:refresh_matches()
	local items = {}
	vim.list_extend(items, self.sources.buffer.items)
	items = self:items_filter(items)
	items = self:items_sort(items)
	items = self:items_limit(items)
	self.matches = self:format_items(items)
end

---@private
function ctx:complete()
  local mode = vim.api.nvim_get_mode().mode
  pdebug('completing', self.keyword, #self.matches, mode)
	if mode:match('i') then
		vim.fn.complete(vim.fn.col('.') - #self.keyword, self.matches)
	end
end

---@private
---@param items CompletionSourceItem[]
---@return CompletionSourceItem[]
function ctx:items_filter(items)
	if #self.keyword < 2 then
		return {}
	end
	---@param item CompletionSourceItem
	return vim.tbl_filter(function(item)
		return item:match(self.keyword)
	end, items)
end

---@private
---@param items CompletionSourceItem[]
---@return CompletionSourceItem[]
function ctx:items_sort(items)
	return table.sort(items, function(a, b)
    return #a < #b
	end) or items
end

---@private
---@param items CompletionSourceItem[]
---@return CompletionSourceItem[]
function ctx:items_limit(items)
	return vim.list_slice(items, 1, self.opts.max_items)
end

---@private
---@param items CompletionSourceItem[]
---@return CompletionMatch[]
function ctx:format_items(items)
	---@param item CompletionSourceItem
	return vim.tbl_map(function(item)
		---@type CompletionMatch
		return {
			word = item,
			info = '',
			kind = '[W]',
			menu = '',
		}
	end, items)
end

---@public
function ctx:accept()
	---@type { mode: string, pum_visible: number, selected: number }|nil
	local info = vim.fn.complete_info({ 'mode', 'pum_visible', 'selected' })
	if info == nil or info.mode ~= 'eval' or not info.pum_visible then
		return
	end
	local accept_keys = vim.api.nvim_replace_termcodes('<c-y><space>', true, true, true)
	vim.api.nvim_feedkeys(accept_keys, 'i', true)
end

return ctx
