---@diagnostic disable: missing-fields
require('Comment').setup({
	ignore = '^$',
	pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
	mappings = {
		basic = true, -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
		extra = false, -- Extra mapping; `gco`, `gcO`, `gcA`
	},
})
