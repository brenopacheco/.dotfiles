--- Autochdir
--
-- Replaces autochdir behavior

local blacklist = {
	'^fugitive://',
	-- '^term://',
	'/tmp/nvim%.'
		.. vim.env.USER
		.. '/',
}

local group = vim.api.nvim_create_augroup('autochdir', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
	desc = 'Automatically change local and global directory',
	group = group,
	pattern = { '*' },
	callback = function(ev)
		vim.opt.autochdir = false
		for _, pat in ipairs(blacklist) do
			if string.match(ev.file, pat) then return end
		end

		if vim.b['directory'] == nil then
			local dir = ev.file == '' and vim.fn.getcwd() or vim.fn.expand('%:p:h')
			vim.b['directory'] = dir
		end

		vim.cmd([[silent! lcd ]] .. vim.b.directory)
		vim.cmd([[silent! cd  ]] .. vim.b.directory)
		vim.cmd([[silent! tc  ]] .. vim.b.directory)
	end,
	nested = true,
})
