local M = {}

M.adapters = {
	mix_task = {
		type = 'executable',
		command = '/usr/bin/elixir-ls-debug',
		args = {},
	},
}

M.configurations = {
	elixir = {
		{
			type = 'mix_task',
			name = 'mix test',
			task = 'test',
			taskArgs = { '--trace' },
			request = 'launch',
			startApps = true, -- for Phoenix projects
			projectDir = '${workspaceFolder}',
			requireFiles = {
				'test/**/test_helper.exs',
				'test/**/*_test.exs',
			},
		},
	},
}

return M
