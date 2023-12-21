require('nvim-autopairs').setup({})
-- Insert `(` after select function or method item
require('cmp').event:on(
	'confirm_done',
	require('nvim-autopairs.completion.cmp').on_confirm_done()
)
