local utils = require("utils")

require("oil").setup({
	keymaps = {
		["g?"] = "actions.show_help",
		["+"] = "actions.select",
		["-"] = "actions.parent",
		["<C-v>"] = "actions.select_vsplit",
		["e"] = "actions.select",
		["<C-s>"] = "actions.select_split",
		["<C-t>"] = "actions.select_tab",
		["<C-p>"] = "actions.preview",
		["q"] = "actions.close",
		["<C-r>"] = "actions.refresh",
		["zh"] = "actions.toggle_hidden",
	},
	default_file_explorer = true,
	skip_confirm_for_simple_edits = true,
	use_default_keymaps = false,
})
