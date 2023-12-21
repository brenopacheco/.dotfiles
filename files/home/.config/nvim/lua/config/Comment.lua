require('Comment').setup({
	ignore = '^$',
	pre_hook = function()
		if vim.z.enabled('JoosepAlviste/nvim-ts-context-commentstring') then
			require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
		end
	end,
	mappings = {
		basic = true, -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
		extra = false, -- Extra mapping; `gco`, `gcO`, `gcA`
	},
})

-- TODO: manually create mappings (operator + visual)
