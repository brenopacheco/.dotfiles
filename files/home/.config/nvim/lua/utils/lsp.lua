local M = {}

---@return boolean, table | nil
M.is_attached = function()
	local clients = vim.lsp.get_clients()
	for _, client in pairs(clients) do
		if client.server_capabilities.hoverProvider then
			return true, client
		end
	end
	return false, nil
end

---@param bufnr number | nil
---@return string[]
M.clients = function(bufnr)
	bufnr = bufnr or vim.fn.bufnr()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local names = {}
	for _, client in pairs(clients) do
		table.insert(names, client.name)
	end
	return names
end

-- Handle the result of functions such as goto_definition.
-- Removes duplicate entries and opens the quickfix list multiple results.
-- *lsp-on-list-handler*
---@param opts {items: table[], title: string, context: table|nil}
M.on_list = function(opts)
	local seen = {}
	local result = {}
	for _, entry in ipairs(opts.items) do
		local key = entry.filename .. ':' .. entry.lnum
		if not seen[key] then
			table.insert(result, entry)
			seen[key] = true
		else
		end
	end
	if #result == 0 then
		return vim.notify('No results found', vim.log.levels.WARN)
	end
	if #result > 1 then
		vim.fn.setqflist({}, ' ', { title = opts.title, items = result })
		vim.api.nvim_command('copen | cfirst')
	else
		vim.lsp.util.jump_to_location(
			opts.items[1].user_data,
			vim.o.fileencoding,
			nil
		)
	end
end

-- Wrap a function call in a check for an attached client.
M.wrap = function(fn, ...)
	local args = { ... }
	if not M.is_attached() then
		return vim.notify('No client attached', vim.log.levels.WARN)
	end
	return fn(unpack(args))
end

return M
