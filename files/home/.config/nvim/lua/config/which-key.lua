local wk = require('which-key')
-- vim.o.timeout = true
-- vim.o.timeoutlen = 150
wk.setup({
	key_labels = {
		['<space>'] = '␣',
		['<Space>'] = '␣',
		['<SPACE>'] = '␣',
		['<cr>'] = '⏎',
		['<Cr>'] = '⏎',
		['<CR>'] = '⏎',
		['<tab>'] = '↹',
		['<Tab>'] = '↹',
		['<TAB>'] = '↹',
		['<bs>'] = '⌫',
		['<Bs>'] = '⌫',
		['<BS>'] = '⌫',
	},
	plugins = {
		marks = false,
		registers = false,
		presets = {
			operators = false,
			motions = false,
			text_objects = false,
			windows = false,
			nav = false,
			z = false,
			g = false,
		},
	},
	icons = {
		group = '', -- symbol prepended to a group
	},
	-- somewhy this bugs out fugitive `cc`
	-- triggers = { '<leader>', '<c-w>', 'g', 'z', ']', '[' },
	triggers = { },
	disable = {
		-- buftypes = { 'nofile', 'fugitive' },
		-- filetypes = { 'fugitive', 'telescope', 'nvim-cmp', 'vim' },
	},
})

wk.register({
	['<space>w'] = {
		s = 'split',
		v = 'vsplit',
		w = 'switch',
		q = 'quit',
		o = 'only',
		x = 'swap',
		['-'] = 'dec-height',
		['+'] = 'inc-height',
		['<'] = 'dec-width',
		['>'] = 'inc-width',
		['|'] = 'max-width',
		['_'] = 'max-height',
		['='] = 'equal-size',
		h = 'move-left',
		l = 'move-right',
		k = 'move-up',
		j = 'move-down',
	},
}, { mode = 'n' })
