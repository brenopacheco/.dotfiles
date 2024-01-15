---@class Snippet
---@field description {[1]: string}
---@field name string
---@field regTrig  boolean
---@field trigger  string
---@field wordTrig boolean

---@class CompletionSnippetSource : CompletionSource
---@field name 'snippet'
local Source = {}

---@param ctx CompletionContext
function Source:new(ctx)
	local obj = setmetatable({}, { __index = self })
	obj.ctx = ctx
	obj.name = 'snippet'
	obj.items = {}
	obj:setup_autocmds()
	obj.ctx:subscribe({
		ev = 'completion_done',
		fn = function(match)
			if match.kind == 'snippet' then
				require('luasnip').expand()
			end
		end,
	})
	obj:update()
	return obj
end

---@type Snippet
local example = {
	description = { '> __create template autocmd__' },
	name = 'autocmd',
	regTrig = false,
	trigger = 'autocmd',
	wordTrig = true,
}

function Source:update()
	---@type { [string]: Snippet[] }
	local snippets = require('luasnip').available()
	---@type CompletionMatch[]
	local items = {}
	for _, list in pairs(snippets) do
		for _, snippet in ipairs(list) do
			---@type CompletionMatch
			local item = {
				word = snippet.name,
				kind = 'snippet',
				info = snippet.description[1],
				-- menu = ... preview?
			}
			table.insert(items, item)
		end
	end
	self.items = items
	self.ctx:update({ complete = true })
end

function Source:setup_autocmds()
	vim.api.nvim_create_autocmd({ 'FileType' }, {
		desc = 'Updates snippet source',
		group = self.ctx.evgroup,
		callback = function()
			self:update()
		end,
	})
end

return Source
