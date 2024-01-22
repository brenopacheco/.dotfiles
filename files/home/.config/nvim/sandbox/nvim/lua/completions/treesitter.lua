---@class CompletionTreesitterSource : CompletionSource
---@field name 'treesitter'
local Source = {}

---@param ctx CompletionContext
function Source:new(ctx)
	local obj = setmetatable({}, { __index = self })
	obj.ctx = ctx
	obj.name = 'treesitter'
	obj.items = {}
	obj:setup_autocmds()
	return obj
end

function Source:update() end

function Source:setup_autocmds() end

return Source
