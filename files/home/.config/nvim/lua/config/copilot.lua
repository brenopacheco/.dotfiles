local opts = {
	filetypes = {
		['*'] = true,
	},
	panel = { enabled = false },
	suggestion = {
		enabled = true,
		auto_trigger = true,
		accept = false,
	},
	server_opts_overrides = {
		settings = {
			advanced = {
				listCount = 0, -- #completions for panel
				inlineSuggestCount = 1, -- #completions for getCompletions
			},
		},
	},
}

if vim.z.enabled('zbirenbaum/copilot-cmp') then
	opts.suggestion = { enabled = false , auto_trigger = false }
	opts.panel = { enabled = false }
end

require('copilot').setup(opts)
