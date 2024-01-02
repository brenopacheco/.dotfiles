local M = {}

--  TODO: maybe we can configure this for multiple filetypes

local tsutil = require('utils.treesitter')

local mappings = {
	['eq'] = [[:=]],
  ['ife'] = [[if err != nil {<cr><cr>}<up><tab>]]
}

local wrap = function(lhs, rhs)
	return function()
		return tsutil.is_comment() and lhs or rhs
	end
end

M.setup = function()
	for lhs, rhs in pairs(mappings) do
		vim.keymap.set('ia', lhs, wrap(lhs, rhs), { buffer = 0, expr = true })
	end
end

return M
