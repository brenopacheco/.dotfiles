local api = require('nvim-tree.api')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- stylua: ignore
local function on_attach(bufnr)
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	vim.keymap.set('n', '-',     api.tree.change_root_to_parent, opts('Up'))
	vim.keymap.set("n", "e",     api.node.open.edit,             opts("Edit"))
	vim.keymap.set('n', '+',     api.tree.change_root_to_node,   opts('Down'))

	vim.keymap.set('n', '<c-p>', api.node.open.preview,          opts('Open:  Preview'))
	vim.keymap.set('n', '<c-s>', api.node.open.horizontal,       opts('Open:  Horizontal Split'))
	vim.keymap.set('n', '<c-t>', api.node.open.tab,              opts('Open:  New Tab'))
	vim.keymap.set('n', '<c-v>', api.node.open.vertical,         opts('Open:  Vertical Split'))

	vim.keymap.set('n', 'g?',    api.tree.toggle_help,           opts('Help'))
	vim.keymap.set('n', 'gx',    api.node.run.system,            opts('Xdg Open'))
	vim.keymap.set("n", "q",     api.tree.close,                 opts("Close"))
	vim.keymap.set("n", "zh",    api.tree.toggle_custom_filter,  opts("Toggle Hidden"))
end

require('nvim-tree').setup({
	on_attach = on_attach,
	hijack_cursor = true,
	update_focused_file = {
		enable = true,
		update_root = false,
	},
	git = { enable = true, ignore = true, show_on_dirs = true },

	respect_buf_cwd = false,
	sync_root_with_cwd = false,
	reload_on_bufenter = false,
	hijack_directories = {
		enable = false,
	},
})

local group = vim.api.nvim_create_augroup('nvim_tree_reload', { clear = true })

local find_root = function()
	local result = vim
		.system({ 'git', 'rev-parse', '--show-toplevel' }, { text = true })
		:wait()
	if result.code == 0 then
		return vim.trim(result.stdout)
	end
	return vim.fn.getcwd()
end

vim.api.nvim_create_autocmd('BufEnter', {
	desc = 'Updates nvim-tree root',
	group = group,
	callback = function()
		local root = find_root()
		api.tree.change_root(root)
	end,
	nested = true,
})
