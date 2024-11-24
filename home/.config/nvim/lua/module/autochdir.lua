--- Autochdir
--
-- Replaces autochdir behavior

local blacklist = {
	'^fugitive://',
	'^term://',
	'/tmp/nvim%.' .. vim.env.USER .. '/',
}

local group = vim.api.nvim_create_augroup('autochdir', { clear = true })
local history = {}

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
	desc = 'Automatically change local and global directory',
	group = group,
	pattern = { '*' },
	callback = function(ev)
		vim.opt.autochdir = false
		if ev.file == '' then
			if vim.b['directory'] == nil then
				vim.b['directory'] = vim.fn.getcwd()
			else
				vim.cmd([[silent! lcd ]] .. vim.b.directory)
				vim.cmd([[silent! cd  ]] .. vim.b.directory)
				vim.cmd([[silent! tc  ]] .. vim.b.directory)
			end
			return
		end
		for _, pat in ipairs(blacklist) do
			if string.match(ev.file, pat) then return end
		end
		vim.cmd([[silent! lcd %:p:h]])
		vim.cmd([[silent! cd %:p:h]])
		vim.cmd([[silent! tc %:p:h]])
		table.insert(history, vim.fn.getcwd())
	end,
	nested = true,
})
