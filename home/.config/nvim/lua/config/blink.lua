local blink = require('blink.cmp')
local luasnip = require('luasnip')

blink.setup({
	enabled = function()
		local disabled = false
		local buftype = vim.api.nvim_get_option_value('buftype', { buf = 0 })
		disabled = disabled or (buftype == 'prompt')
		disabled = disabled or (vim.fn.reg_recording() ~= '')
		disabled = disabled or (vim.fn.reg_executing() ~= '')
		return not disabled
	end,
	cmdline = {
		enabled = false,
	},
	completion = {
		accept = { auto_brackets = { enabled = true } },
		ghost_text = { enabled = false },
	},
	snippets = { preset = 'luasnip' },
	signature = { enabled = true },
	sources = {
		-- default = { 'lsp', 'path', 'snippets', 'buffer' },
    -- default = function(ctx)
    --   local success, node = pcall(vim.treesitter.get_node)
    --   if vim.bo.filetype == 'lua' then
    --     return { 'lsp', 'path' }
    --   elseif success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
    --     return { 'buffer' }
    --   else
    --     return { 'lsp', 'path', 'snippets', 'buffer' }
    --   end
    -- end
		default = {'path'},
		providers = {
			path = {
				opts = {
					trailing_slash = true,
					label_trailing_slash = true,
					show_hidden_files_by_default = true,
				},
        -- ISSUE: https://github.com/Saghen/blink.cmp/blob/ef9d861952bfe29d096c993d4bd69576e09447fe/lua/blink/cmp/sources/path/lib.lua#L39
				fallbacks = {},
				score_offset = 3,
				should_show_items = true,
				enabled = true
			},
			buffer = {
				fallbacks = {},
				score_offset = -3,
			},
			snippets = {
				score_offset = 0,
				fallbacks = {},
				-- should_show_items = function(ctx)
				-- 	log(ctx)
				-- 	return true
				-- end
			},
			lsp = {
				score_offset = 3,
				fallbacks = {},
			},
		},
	},
	fuzzy = { implementation = 'prefer_rust' },
	keymap = {
		['<C-e>'] = { 'hide' },
		['<C-y>'] = { 'select_and_accept' },
		['<Tab>'] = { 'select_and_accept', 'fallback' },
		['<C-j>'] = { 'snippet_backward' },
		['<C-k>'] = { 'snippet_forward', 'show_documentation' },
		['<C-b>'] = { 'scroll_documentation_up' },
		['<C-f>'] = { 'scroll_documentation_down' },
		['<S-Tab>'] = {
			function()
				local ok, autopairs = pcall(require, 'nvim-autopairs')
				if ok then autopairs.disable() end
				require('copilot.suggestion').accept()
				if ok then autopairs.enable() end
			end,
		},
	},
})
