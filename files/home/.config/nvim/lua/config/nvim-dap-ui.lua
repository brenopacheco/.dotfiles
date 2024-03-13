local dapui = require('dapui')

---@diagnostic disable-next-line: missing-fields
dapui.setup({
	controls = {
		element = 'repl',
		enabled = true,
		icons = {
			disconnect = ' ',
			pause = ' ',
			play = ' ',
			run_last = ' ',
			step_back = ' ',
			step_into = ' ',
			step_out = ' ',
			step_over = ' ',
			terminate = ' ',
		},
	},
	layouts = {
		{
			elements = {
				-- { id = 'breakpoints', size = 0.25 },
				{ id = 'stacks', size = 0.25 },
				{ id = 'scopes', size = 0.50 },
				{ id = 'watches', size = 0.25 },
			},
			position = 'right',
			size = 50,
		},
		{
			elements = {
				{ id = 'repl', size = 1 },
			},
			position = 'bottom',
			size = 11,
		},
	},
})
