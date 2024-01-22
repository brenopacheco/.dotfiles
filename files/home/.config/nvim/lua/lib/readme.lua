--[[ generics notes
The issue with implementing data structures is that we do not have generics
properly implemented in Lua. So we cannot implement them in such a way as to
always infer the type. That's probably why the default implementation of ring
buffer returns `any`?
--]]
--[[ vim.iter 
  Iter:iter(tbl)      : tbl -> iterator
  Iter:totable()      : iterator -> table
  Iter:fold(init, f)  : reduce function
  Iter:join(delim)    : iter -> string
  Iter:last()         : iter -> value
  Iter:map(f)         : iter -> iter (needs enumerate for index)
  Iter:enumerate()    : adds index to iter
  Iter:filter(f)      : filters
  Iter:find(f)        : iter -> value
  Iter:rfind(f)       : iter -> value  starting from the end
  Iter:flatten(depth) : flatten fn
  Iter:each(f)        : iter -> nil calls f for each value
  Iter:nth(n)         : iter -> value
  Iter:nthback(n)     : iter -> value
  Iter:take(n)        : iter -> iter   take first n values
  Iter:any(f)         : iter -> bool
  Iter:all(f)         : iter -> bool
  Iter:slice(i,j)     : iter -> iter   slice from i to j
  Iter:rev()          : iter -> iter reverse
  Iter:skip(n)        : iter -> iter skip n values
  Iter:skipback(n)    : iter -> iter skip n values from the end
  Iter:next()         : iter -> value unshift
  Iter:nextback()     : iter -> value pops
  Iter:peek()         : iter -> value
  Iter:peekback()     : iter -> value
--]]

local M = {}

return M

--[[ OLD 
List functions ========================================================

---Takes an integer value and returns the item at that index, allowing for
---positive and negative integers. Zero and negative integers count back from the
---last item in the array.
---@generic T: any
---@param list T[]
---@param index integer
---@return T
M.list_at = function(list, index)
	vim.validate({
		list = { list, 'table' },
		index = { index, 'number' },
	})
	index = ((index - 1) % #list) + 1
	return list[index]
end

assert(M.list_at({ 1, 2, 3 }, 1) == 1, 'list_at(1) should be 1')
assert(M.list_at({ 1, 2, 3 }, 3) == 3, 'list_at(3) should be 3')
assert(M.list_at({ 1, 2, 3 }, 0) == 3, 'list_at(0) should be 3')
assert(M.list_at({ 1, 2, 3 }, -1) == 2, 'list_at(-1) should be 2')
assert(M.list_at({ 1, 2, 3 }, -5) == 1, 'list_at(-5) should be 1')

---Merge two or more arrays. Does not change the existing arrays, but instead
---returns a new array.
---@generic T: any
---@param list T[]
---@vararg T[]
---@return T[]
M.list_concat = function(list, ...)
	vim.validate({
		list = { list, 'table' },
	})
	local lists = { list, ... }
	local result = {}
	for _, l in ipairs(lists) do
		for _, v in ipairs(l) do
			table.insert(result, v)
		end
	end
	return result
end

assert(
	M.list_concat({ 1, 2 }, { 3, 4, 5 }),
	{ 1, 2, 3, 4, 5 },
	'list_concat({1,2}, {3,4,5}) should be {1,2,3,4,5}'
)
--]]
-- vi:tw=80:fdl=0
