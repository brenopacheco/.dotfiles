local M = {}

--- Check if any appropriate lsp client is attached to the current buffer.
--- Ignore clients that do not provide hover/definition capabilities.
---
---@return boolean, table | nil : is_attached, client
M.is_attached = function()
	local blacklist = {
		['null-ls'] = true,
		['efm'] = true,
		['eslint'] = true,
		['copilot'] = true,
	}
	local clients = vim.lsp.get_clients({ bufnr = vim.fn.bufnr() })
	for _, client in pairs(clients) do
		local can_hover = not blacklist[client.name]
		if can_hover then
			return true, client
		end
	end
	return false, nil
end

---@param bufnr number | nil
---@return string[], lsp.Client[] : names, configs
M.clients = function(bufnr)
	bufnr = bufnr or vim.fn.bufnr()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local names = {}
	local configs = {}
	for _, client in pairs(clients) do
		table.insert(names, client.name)
		table.insert(configs, client.config)
	end
	return names, configs
end

---@param bufnr number | nil
M.open_config = function(bufnr)
	bufnr = bufnr or vim.fn.bufnr()
	local _, configs = M.clients(bufnr)
	vim.ui.select(configs, {
		prompt = 'Open lsp configuration for:',
		format_item = function(item)
			return item.name
		end,
	}, function(choice)
		if choice ~= nil then
			vim.print(choice)
			local text = vim.split(vim.inspect(choice), '\n')
			bufnr = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, text)
			vim.cmd('vsplit')
			local winnr = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_buf(winnr, bufnr)
		end
	end)
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
			false
		)
    vim.notify('This is the only result')
	end
end

-- Wrap a function call in a check for an attached client.
M.wrap = function(fn, ...)
	local args = { ... }
	if not M.is_attached() then
		return vim.notify('[lsp]: no client attached', vim.log.levels.WARN)
	end
	return fn(unpack(args))
end

return M
