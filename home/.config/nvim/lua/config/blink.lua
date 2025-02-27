local blink = require('blink.cmp')

-- v0.13.0
-- /home/breno/.local/share/nvim/pack/site/opt/blink.cmp/doc/blink-cmp.txt:1178
blink.setup({
	keymap = { preset = 'default' },
	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
	},
	fuzzy = { implementation = 'prefer_rust' },
})
