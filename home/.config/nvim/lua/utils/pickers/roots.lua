--- Root picker
--
-- Open a project root within a git repository.

local rootutil = require('utils.root')

return function()
	-- local root = rootutil.shortest_root()
	local root = vim.fn.expand('~/thm')
	local roots =
		rootutil.downward_roots({ dir = root, patterns = rootutil.root_patterns })
	roots = vim.tbl_filter(function(r) return r.path ~= root end, roots)

	if not root then
		return vim.notify('Not in a git repository', vim.log.levels.WARN)
	end

	if #roots == 0 then
		return vim.notify('No roots found', vim.log.levels.WARN)
	end

	---@type string[]
	local dirs = vim.tbl_map(function(r) return r.path end, roots)

	---@type string[]
	---@diagnostic disable-next-line: assign-type-mismatch
	dirs = vim.fn.uniq(dirs)

	vim.ui.select(dirs, {
		prompt = 'Select root from ' .. root,
		format_item = function(item)
			return item == '.' and './'
				or './' .. string.sub(item, string.len(root) + 2)
		end,
	}, function(choice)
		if choice ~= nil then vim.cmd('e ' .. choice) end
	end)
end
