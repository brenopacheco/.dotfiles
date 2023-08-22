local oil = require("oil")

oil.setup({
	keymaps = {
		["g?"] = "actions.show_help",
		["+"] = "actions.select",
		["-"] = "actions.parent",
		["<C-v>"] = "actions.select_vsplit",
		["<CR>"] = "actions.select",
		["<C-s>"] = "actions.select_split",
		["<C-t>"] = "actions.select_tab",
		["<C-p>"] = "actions.preview",
		["q"] = "actions.close",
		["<C-r>"] = "actions.refresh",
		["zh"] = "actions.toggle_hidden",
		["gf"] = function()
			local entry = oil.get_cursor_entry()
			local fname = entry.name
			vim.cmd("silent !xdg-open " .. fname .. " & disown")
		end,
		["e"] = "actions.select",
	},
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
		swapfile = false,
	},
	default_file_explorer = true,
	skip_confirm_for_simple_edits = true,
	use_default_keymaps = false,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	desc = "Autochdir in oil",
	pattern = { "oil://*" },
	group = vim.api.nvim_create_augroup("oil-custom", { clear = true }),
	callback = function()
		vim.cmd("cd " .. oil.get_current_dir())
	end,
})
