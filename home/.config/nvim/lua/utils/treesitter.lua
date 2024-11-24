local M = {}

--- Get capture groups at cursor position.
--- Works in insert and normal mode.
---
---@return string[] : capture group names
M.get_captures = function()
	---@type string
	local mode = vim.fn.mode()
	assert(mode == 'i' or mode == 'n', 'invalid mode')
	local pos = vim.api.nvim_win_get_cursor(0)
	local row = pos[1] - 1
	local col = pos[2] - (mode == 'i' and 1 or 0)
	local buf = vim.api.nvim_get_current_buf()
	local data = vim.inspect_pos(buf, row, col, {
		syntax = false,
		treesitter = true,
		extmarks = false,
		semantic_tokens = false,
	}).treesitter
	return vim.tbl_map(function(group) return group.capture end, data)
end

--- Checks if cursor is in a comment.
---
---@return boolean : true if cursor is in a comment
M.is_comment = function()
	local captures = M.get_captures()
	for _, capture in ipairs(captures) do
		local str = string.lower(capture)
		local match = string.match(str, 'comment')
		if match then return true end
	end
	return false
end

---Loads contents into an unnamed buffer, starts treesitter, traverse the tree
---and returns the query captures.
---
---@param content string[] : file contents
---@param ft string : file type
---@param query string : query
M.apply_query = function(content, ft, query)
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, content)
	local lang = vim.treesitter.language.get_lang(ft)
	assert(lang ~= nil, 'treesitter ' .. ft .. ' parser missing')
	local parser = vim.treesitter.get_parser(bufnr, lang)
	local parsed_query = vim.treesitter.query.parse(ft, query)
	local tree = parser:parse()[1]
	local root = tree:root()
	local first, _, last, _ = root:range()
	local captures = {}
	for _, match, _ in parsed_query:iter_matches(root, bufnr, first, last) do
		for id, node in pairs(match) do
			local name = parsed_query.captures[id]
			local value = vim.treesitter.get_node_text(node, bufnr)
			table.insert(captures, { name = name, value = value })
		end
	end
	pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
	return captures
end

return M
