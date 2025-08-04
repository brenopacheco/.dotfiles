local blink = require('blink.cmp')

-- /home/breno/.local/share/nvim/pack/site/opt/blink.cmp/doc/blink-cmp.txt:1178
blink.setup({
	keymap = { preset = 'default' },
	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
	},
	snippets = { preset = 'luasnip' },
})
