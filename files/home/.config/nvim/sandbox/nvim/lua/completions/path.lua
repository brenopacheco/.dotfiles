---@diagnostic disable: param-type-mismatch

---@class CompletionPathSource : CompletionSource
---@field name 'path'
---@field dir string
local Source = {}

---@param ctx CompletionContext
function Source:new(ctx)
	local obj = setmetatable({}, { __index = self })
	obj.ctx = ctx
	obj.name = 'path'
	obj.items = {}
	obj.dir = ''
	obj:setup_autocmds()
	return obj
end

---@private
function Source:update()
	local col = vim.fn.col('.')
	local line = vim.api.nvim_get_current_line()
	local catch = line:sub(1, col - 1)
	local match = catch:match('[%~%.%/]+[%S]*')
	if match then
		local path = tostring(vim.fn.fnamemodify(match, ':h'))
		if path == '' or self.dir == path then
			return
		end
		self.dir = path
    --  TODO: fix here
		local files = vim.fn.readdir(path)
		if files then
			local items = {}
			for _, file in ipairs(files) do
				local item = {
					word = file,
					kind = 'path',
				}
				table.insert(items, item)
			end
      self.items = items
			self.ctx:update({ complete = true })
		end
	end
end

---@private
function Source:setup_autocmds()
	vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'TextChangedP' }, {
		desc = 'Updates path source',
		group = self.ctx.evgroup,
		callback = function()
      self:update()
		end,
	})
end

return Source
