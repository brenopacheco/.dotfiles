require("hlchunk").setup({
	chunk = {
		enable = true,
		use_treesitter = true,
		style = { "#81A9FE" },
		exclude_filetypes = { fugitive = true, noft = true, oil = true, floaterm = true },
	},
	indent = { enable = false },
	line_num = {
		enable = true,
		style = { "#81A9FE" },
	},
	blank = { enable = false },
	context = { enable = false },
})
