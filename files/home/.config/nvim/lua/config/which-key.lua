local wk = require('which-key')
vim.o.timeout = true
vim.o.timeoutlen = 250
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
	-- triggers_blacklist = {
	-- 	n = { 'c' },
	-- },
	-- triggers = { '<leader>', '<c-w>', 'g', 'z', ']', '[' },
	disable = {
		buftypes = { 'nofile', 'fugitive' },
		filetypes = { 'fugitive' },
	},
})

wk.register(vim.z.keyboard.prefixes, { prefix = '<leader>', mode = 'n' })

wk.register({
	ga = 'align',
	gb = 'comment-block',
	gc = 'comment-line',
	gf = 'goto-file',
	gF = 'goto-file:line',
	gG = 'goto-bottom',
	gg = 'goto-top',
	gq = 'fmt-width',
	gt = 'tabnext',
	gu = 'lowercase',
	gU = 'uppercase',
	gv = 'visual-reselect',
	gx = 'xdg-open',
}, { mode = 'n' })

wk.register({
	ga = 'align',
	gb = 'comment-block',
	gc = 'comment-line',
	gq = 'fmt-width',
	gu = 'lowercase',
	gU = 'uppercase',
	gx = 'xdg-open',
}, { mode = 'x' })

wk.register({
	zo = 'open-fold',
	zO = 'open-folds',
	zc = 'close-fold',
	zC = 'close-folds',
	za = 'toggle-fold',
	zA = 'toggle-folds',
	zM = 'foldlevel=0',
	zR = 'foldelevel=max',
	zm = 'foldlevel+1',
	zr = 'foldlevel-1',
	zx = 'update-folds',
	zi = 'toggle-folding',
}, { mode = 'n' })

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
