--- Yank Highlight
--
-- Adds a visual highlight when yanking text
--

-- setup
local group = vim.api.nvim_create_augroup('yank_highlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
	nested = true,
	desc = 'Highlight on yank',
	group = group,
	callback = function()
		vim.highlight.on_yank({ higroup = 'Visual', timeout = 300 })
	end,
})
