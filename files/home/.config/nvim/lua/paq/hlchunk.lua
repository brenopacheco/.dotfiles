require("hlchunk").setup({
	chunk = {
		enable = true,
		use_treesitter = true,
		-- style = { "#00FFFF" },
		style = { "#81A9FE" },
	},
	indent = { enable = false },
	line_num = {
		enable = true,
		style = { "#81A9FE" },
	},
	blank = { enable = false },
	context = { enable = false },
})
