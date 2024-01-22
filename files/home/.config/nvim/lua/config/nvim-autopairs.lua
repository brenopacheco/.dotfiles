require('nvim-autopairs').setup({})

-- insert ( ) after function completion and reset copilot completions
local on_complete = require('nvim-autopairs.completion.cmp').on_confirm_done()

require('cmp').event:on('confirm_done', function(evt)
	if evt.entry.completion_item then
		-- pdebug('on_complete', evt.entry.completion_item)
		on_complete(evt)
		vim.api.nvim_exec_autocmds('CompleteChanged', {})
	end
end)
