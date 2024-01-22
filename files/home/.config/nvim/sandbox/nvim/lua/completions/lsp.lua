---@class CompletionLspSource : CompletionSource
---@field name 'lsp'
local Source = {}

---@param ctx CompletionContext
function Source:new(ctx)
	local obj = setmetatable({}, { __index = self })
	obj.ctx = ctx
	obj.name = 'lsp'
	obj.items = {}
	obj:setup_autocmds()
	return obj
end

function Source:update() end

function Source:setup_autocmds() end

return Source
