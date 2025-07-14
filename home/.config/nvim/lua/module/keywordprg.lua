-- Keywordprg
--
-- Context-aware keywordprog
--
-- option 1: for every ft, `set keywordprg=:KeywordPrg`
-- option 2: remap K
--
-- TODO:
-- 1. contextually try to identify what we want to query
--    (word under cursor is indicative)
-- 2. generate options
-- 3. check against database
-- 4. add options to qf or ask the user
--
-- for go, using go doc is best
-- base on ~/.config/nvim/lua/utils/filetype/go.lua

local function make_exprs()
	local expr = vim.fn.expand('<cexpr>')
	local exprlen = string.len(expr)
	local pos, exprs = 1, {}
	local pass, MAX_PASSES = 0, 10
	while pos < exprlen do
		pass = pass + 1
		assert(pass < MAX_PASSES, 'failed splitting expr: ' .. expr)
		local keyword = vim.fn.matchstr(expr, [[\k\+]], pos - 1)
		if keyword == '' then break end
		local index = vim.fn.match(expr, [[\k\+]], pos - 1) + 1
		table.insert(exprs, expr:sub(index))
		pos = index + string.len(keyword)
	end
	return exprs
end

local function keywordprg()
	local keywords = make_exprs()
	log(keywords)
	warn('Not implemented')
end

vim.api.nvim_create_user_command('KeywordPrg', keywordprg, { nargs = '+' })
