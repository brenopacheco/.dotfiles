local pre_hook = nil
if vim.z.enabled('nvim-ts-context-commentstring') then
	pre_hook =
		require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
end

-- ts_context_commentstring does not pick up correctly the commentstring for c
local disabled = {
	c = true,
}

---@diagnostic disable: missing-fields
require('Comment').setup({
	ignore = '^$',
	---@diagnostic disable: return-type-mismatch
	pre_hook = function(ctx)
		local ft = vim.bo.filetype
		if disabled[ft] ~= nil and disabled[ft] or pre_hook == nil then
			return nil
		end

		return pre_hook(ctx)
	end,

	mappings = {
		basic = true, -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
		extra = false, -- Extra mapping; `gco`, `gcO`, `gcA`
	},
})
