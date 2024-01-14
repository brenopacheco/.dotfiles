vim.g.fugitive_summary_format = '%cs || %<(20,trunc)%an || %s'

vim.api.nvim_create_autocmd({ 'Filetype' }, {
	desc = 'Goto top of gitcommit buffer',
	pattern = 'gitcommit',
	group = vim.api.nvim_create_augroup('fugitive-config', { clear = true }),
	callback = function()
		vim.cmd('normal! gg')
	end,
})
