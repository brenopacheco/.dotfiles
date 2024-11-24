--- Sniputil
--
-- Provides Snipyank, Sniplist, and Snipopen commands

if not vim.z.enabled('L3MON4D3/LuaSnip') then
	return vim.notify('[sniputil]: LuaSnip not installed', vim.log.levels.WARN)
end

local open = function()
	local ft = tostring(string.len(vim.o.ft) > 0 and vim.o.ft or 'all')
	local file = vim.fn.stdpath('config')
		.. '/snippets'
		.. '/'
		.. ft
		.. '.snippets'
	local bufnr = vim.fn.bufnr(file)
	if bufnr ~= -1 then
		local winid = vim.fn.bufwinid(bufnr)
		if winid ~= -1 then
			vim.fn.win_gotoid(winid)
			vim.cmd([[norm G]])
			return bufnr
		end
	end
	vim.cmd([[vsp ]] .. file)
	bufnr = vim.fn.bufnr(file)
	return bufnr
end

vim.api.nvim_create_user_command(
	'Sniplist',
	function() require('luasnip.extras.snippet_list').open() end,
	{
		nargs = 0,
	}
)

vim.api.nvim_create_user_command('Snipyank', function(cmd)
	local line1 = cmd.line1
	local line2 = cmd.line2
	local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
	local text = vim.tbl_map(function(line) return '\t' .. line end, lines)
	local template = vim.list_extend({
		'',
		[[snippet name description]],
	}, text)
	local bufnr = open()
	---@diagnostic disable-next-line: param-type-mismatch
	vim.fn.appendbufline(bufnr, '$', template)
	vim.fn.setpos('.', { bufnr, '$', 1, 0 })
end, {
	nargs = 0,
	range = 2,
})

vim.api.nvim_create_user_command('Snipopen', open, {
	nargs = 0,
})
