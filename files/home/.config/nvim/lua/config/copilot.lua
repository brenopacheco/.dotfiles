require('copilot').setup({
	filetypes = {
		['*'] = true,
	},
	panel = {
		enabled = true,
		auto_refresh = true,
		keymap = {
			jump_prev = '{',
			jump_next = '}',
			accept = '<CR>',
			refresh = '<C-r>',
			open = '<S-Tab>',
		},
	},
	suggestion = {
		enabled = true,
		auto_trigger = true,
		accept = false,
	},
	server_opts_overrides = {
		settings = {
			advanced = {
				listCount = 3, -- #completions for panel
				inlineSuggestCount = 1, -- #completions for getCompletions
			},
		},
	},
})
