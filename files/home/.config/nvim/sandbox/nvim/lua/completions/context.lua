local buffer = require('completions.buffer')
local snippet = require('completions.snippet')

---@class CompletionMatch
---@field word string
---@field kind string
---@field info? string
---@field menu? string

---@class CompetionSource
---@field name string
---@field items CompletionMatch[]

---@class CompletionSource
---@field public name string
---@field public items CompletionMatch[]
---@field protected ctx CompletionContext

---@class CompletionOpts
---@field max_items number
---@field debounce_time number
---@field sources CompletionSourcesOpts

---@class CompletionSourcesOpts
---@field buffer CompletionBufferSourceOpts
---@field snippet CompletionSnippetSourceOpts

---@class CompletionBufferSourceOpts
---@field debounce_time number
---@field min_length number
---@field all_buffers boolean

---@class CompletionSnippetSourceOpts
---@field min_length number

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
	local complete = opts and opts.complete
	if self.timer:is_active() then
		self.timer:stop()
	end
	self.timer:start(
		self.opts.debounce_time,
		0,
		vim.schedule_wrap(function()
			if self:should_update() then
				if complete then
					self:refresh_matches()
					self:refresh_keyword()
					self:complete()
				else
					self:refresh_keyword()
					self:refresh_matches()
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
	self.keyword = Context.get_keyword()
end

---@private
function Context.get_keyword()
	local col = vim.fn.col('.')
	local line = vim.api.nvim_get_current_line()
	local word = line:sub(1, col - 1):match('%w+$') or ''
	return word
end

---@private
function Context:refresh_matches()
	local items = {}
	vim.list_extend(items, self.sources.buffer.items)
	vim.list_extend(items, self.sources.snippet.items)
	items = self:items_filter(items)
	items = self:items_sort(items)
	items = self:items_limit(items)
	items = self:items_preselect(items)
	self.matches = items
end

---@private
function Context:complete()
	if self.enabled then
		-- pdebug(
		-- 	'completions',
		-- 	self.keyword,
		-- 	#self.matches,
		-- 	#self.sources.buffer.items
		-- )
		--- TODO: this doesnt work when we have a selection and something triggers
		---       an update
		vim.fn.complete(vim.fn.col('.') - #self.keyword, self.matches)
	end
end

---@private
---@param items CompletionMatch[]
---@return CompletionMatch[]
function Context:items_filter(items)
	---@param item CompletionMatch
	return vim.tbl_filter(function(item)
		if #self.keyword < self.opts.sources[item.kind].min_length then
			return false
		end
		return item.word:match('^' .. self.keyword)
	end, items)
end

---@private
---@param items CompletionMatch[]
---@return CompletionMatch[]
function Context:items_sort(items)
	return table.sort(items, function(a, b)
		return #a.word < #b.word
	end) or items
end

---@private
---@param items CompletionMatch[]
---@return CompletionMatch[]
function Context:items_limit(items)
	return vim.list_slice(items, 1, self.opts.max_items)
end

---If the puml is already opened and we have a selected match, we need to
---push it into the 1st position.
---@private
---@param items CompletionMatch[]
---@return CompletionMatch[]
function Context:items_preselect(items)
	local index = vim.fn.complete_info({ 'selected' }).selected
	local selected = self.matches[index + 1]
	if not selected then
		return items
	end
	if selected.word == self.get_keyword() then
		for i, item in ipairs(items) do
			if item.word == selected.word then
				table.remove(items, i)
				table.insert(items, 1, item)
				break
			end
		end
	end
	return items
end

---@private
function Context:setup_autocmds()
	self.evgroup = vim.api.nvim_create_augroup('completions', { clear = true })
	vim.api.nvim_create_autocmd('CursorMovedI', {
		desc = 'Updates matches and keyword',
		group = self.evgroup,
		callback = function()
			self:update({ complete = false })
		end,
	})
	vim.api.nvim_create_autocmd('CursorHoldI', {
		desc = 'Triggers completion',
		group = self.evgroup,
		callback = vim.schedule_wrap(function()
			self:complete()
		end),
	})
end

function Context:setup_sources()
	self.sources.buffer = buffer:new(self)
	self.sources.snippet = snippet:new(self)
end

function Context:toggle()
	self.enabled = not self.enabled
end

function Context:on_complete(selected)
	if selected.kind == 'buffer' then
		vim.api.nvim_feedkeys(' ', 'i', true)
	end
	if selected.kind == 'snippet' then
		require('luasnip').expand()
	end
end

---@param fallback string
function Context:accept(fallback)
	assert(fallback, 'fallback keybinding is required')
	local index = vim.fn.complete_info({ 'selected' }).selected
	if not self.enabled or index < 0 then
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
