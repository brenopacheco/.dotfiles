---@class CompletionMatch
---@field word string
---@field kind string
---@field info? string
---@field menu? string

---@alias CompletionSourceItem string

---@class CompletionSource
---@field name string
---@field items CompletionSourceItem[]

---@class CompletionOpts
---@field max_items number
---@field debounce_time number

---@type CompletionOpts
local default_opts = {
	max_items = 5,
	debounce_time = 300,
}

---@class CompletionCache
---@field matches { [string]: CompletionMatch[] }
---@field sources { buffer: string[] }
---@field stale boolean

---@class CompletionContext
---@field opts CompletionOpts                                : maximum number of matches to show
---@field private cache CompletionCache                      : the cache of matches for a keyword
---@field private matches CompletionMatch[]                  : the list of sources that match a keyword
---@field private keyword string                             : the keyword to match
---@field private sources { buffer: CompletionSourceItem[] } : source items
---@field private tick integer                               : the keyword to match
local ctx = {
	opts = default_opts,
	cache = {
		matches = {
      -- ['keyword'] = {...}
    },
    sources = {
      buffer = {
        -- 'word1', 'word2', 'word3'
      },
    },
		stale = true,
	},
	matches = {},
	keyword = '',
	sources = {
		buffer = {},
	},
}

---@param opts? CompletionOpts
---@return CompletionContext
function ctx:new(opts)
	opts = vim.tbl_extend('force', default_opts, opts or {})
	return setmetatable({ opts = opts }, { __index = self })
end

function ctx:clear()
	self.cache = {
    matches = {},
    sources = {
      buffer = {},
    },
    stale = true,
  }
	self.keyword = ''
end

---@param source CompletionSource
---@param keyword string
---@return boolean true if the source was refreshed, false otherwise
function ctx:refresh_source(source, keyword)
  if vim.list_contains(self.cache.sources[source.name], keyword) then
    return false
  end
	self.sources[source.name] = source.items
  table.insert(self.cache.sources[source.name], keyword)
  self.cache.stale = true
	return true
end

function ctx:refresh_keyword()
	local col = vim.fn.col('.')
	local line = vim.api.nvim_get_current_line()
	local word = line:sub(1, col - 1):match('%w+$')
	if self.keyword == word then
		return false
	end
	self.keyword = word or ''
	return true
end

---@return boolean true if the matches were refreshed, false otherwise
---we can only use the cache if none of the sources have been changed.
function ctx:refresh_matches()
	if not self.cache.stale and self.cache.matches[self.keyword] then
		self.matches = self.cache[self.keyword]
		return false
	end
	local items = {}
	vim.list_extend(items, self.sources.buffer)
	items = self.filter_items(items, self)
	items = self.sort_items(items, self)
	items = self.cap_items(items, self)
	self.matches = self.format_items(items, self)
	self.cache.matches[self.keyword] = self.matches
  self.cache.stale = false
	return true
end

function ctx:complete()
	vim.fn.complete(vim.fn.col('.') - #self.keyword, self.matches)
end

---@private
---@param items CompletionSourceItem[]
---@param _ctx CompletionContext
---@return CompletionSourceItem[]
ctx.filter_items = function(items, _ctx)
	local keyword = _ctx.keyword
	if #keyword < 2 then
		return items
	end
	---@param item CompletionSourceItem
	return vim.tbl_filter(function(item)
		return item:match(keyword)
	end, items)
end

---@private
---@param items CompletionSourceItem[]
---@param _ CompletionContext
---@return CompletionSourceItem[]
ctx.sort_items = function(items, _)
	return table.sort(items) or items
end

---@private
---@param items CompletionSourceItem[]
---@param _ CompletionContext
---@return CompletionSourceItem[]
ctx.cap_items = function(items, _)
	return vim.list_slice(items, 1, ctx.opts.max_items)
end

---@private
---@param items CompletionSourceItem[]
---@param _ CompletionContext
---@return CompletionMatch[]
ctx.format_items = function(items, _)
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

return ctx
