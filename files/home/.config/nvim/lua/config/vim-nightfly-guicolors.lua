vim.o.termguicolors = true

vim.g.nightflyItalics = true
vim.g.nightflyCursorColor = true
vim.g.nightflyNormalFloat = true
vim.g.nightflyTerminalColors = false
vim.g.nightflyTransparent = false
vim.g.nightflyUndercurls = true
vim.g.nightflyUnderlineMatchParen = true
vim.g.nightflyVirtualTextColor = true
vim.g.nightflyWinSeparator = 2

local custom_highlight = vim.api.nvim_create_augroup('CustomHighlight', {})
vim.api.nvim_create_autocmd('ColorScheme', {
	pattern = 'nightfly',
	callback = function()
		vim.api.nvim_set_hl(0, 'Function', { fg = '#82aaff', bold = true })
	end,
	group = custom_highlight,
})

vim.cmd('colorscheme nightfly')
