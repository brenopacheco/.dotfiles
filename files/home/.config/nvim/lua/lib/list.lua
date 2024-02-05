---@class List
---@field [number] any
local M = {}

---@param elem any
function M:has(elem)
	return vim.iter(self):any(function(v) return v == elem end)
end

function M:iter() return ipairs(self) end

function M:get(idx) return self[idx] end

---@param elem any
function M:enqueue(elem) table.insert(self, elem) end

function M:dequeue() return table.remove(self, 1) end

function M:add(idx, ...) table.insert(self, idx, ...) end

function M:remove(idx) table.remove(self, idx) end

function M:head() return self[1] end

function M:tail() return self[#self] end

function M:empty() return #self == 0 end

function M:len() return #self end

function M:clear()
	for i = 1, #self do
		self[i] = nil
	end
end

local mt = {
	__index = M,
	__len = M.len,
	__tostring = function(self) return vim.inspect(self) end,
	__call = function(self, ...)
		assert(select('#', ...) == 0, 'use list() instead of list as iterator')
		return M.iter(self)
	end,
}

function M.new(...) return setmetatable({ ... }, mt) end

return M
