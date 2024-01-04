local M = {}

--  TODO: maybe we can configure this for multiple filetypes

local treeutil = require('utils.treesitter')

local mappings = {
	['eq'] = [[:=]],
	['ife'] = [[if err != nil {<cr><cr>}<up><tab>]],
	['fn'] = [[func() {}<left><cr>.<cr><up><tab><del>]],
}

local wrap = function(lhs, rhs)
	return function()
		return treeutil.is_comment() and lhs or rhs
	end
end

M.setup = function()
	for lhs, rhs in pairs(mappings) do
		vim.keymap.set('ia', lhs, wrap(lhs, rhs), { buffer = 0, expr = true })
	end
end

return M
