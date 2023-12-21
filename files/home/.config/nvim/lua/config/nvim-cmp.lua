local cmp = require('cmp')
local defaults = require('cmp.config.default')()
local lspkind = require('lspkind')
local luasnip = require('luasnip')

vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })

local is_whitespace = function()
	-- returns true if the character under the cursor is whitespace.
	local col = vim.fn.col('.') - 1
	local line = vim.fn.getline('.')
	local char_under_cursor = string.sub(line, col, col)

	if col == 0 or string.match(char_under_cursor, '%s') then
		return true
	else
		return false
	end
end

local is_comment = function()
	-- uses treesitter to determine if cursor is currently in a comment.
	local context = require('cmp.config.context')
	return context.in_treesitter_capture('comment') == true
		or context.in_syntax_group('Comment')
end

cmp.setup({
	enabled = function()
		if is_comment() or is_whitespace() then
			return false
		else
			return true
		end
	end,
	completion = {
		completeopt = 'menu,menuone,noinsert',
		keyword_length = 1,
		-- keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
		autocomplete = {
			cmp.TriggerEvent.TextChanged,
			cmp.TriggerEvent.InsertEnter,
		},
	},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-n>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item({
					behavior = cmp.SelectBehavior.Insert,
				})
			else
				require('copilot.suggestion').next()
			end
		end, { 'i', 's' }),
		['<C-p>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item({
					behavior = cmp.SelectBehavior.Insert,
				})
			else
				require('copilot.suggestion').prev()
			end
		end, { 'i', 's' }),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.abort()
			else
				cmp.complete()
			end
		end, { 'i', 's' }),
		['<C-e>'] = cmp.mapping.abort(),
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = true })
			elseif require('copilot.suggestion').is_visible() then
				vim.schedule(require('copilot.suggestion').accept)
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<C-k>'] = cmp.mapping(function()
			luasnip.jump(1)
		end, { 'i', 's' }),
		['<C-j>'] = cmp.mapping(function()
			luasnip.jump(-1)
		end, { 'i', 's' }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'path' },
	}, {
		{ name = 'buffer' },
	}),
	experimental = {
		ghost_text = {
			hl_group = 'CmpGhostText',
		},
	},
	sorting = defaults.sorting,
	formatting = {
		format = lspkind.cmp_format({
			mode = 'symbol',
			maxwidth = 100,
			ellipsis_char = '...',
			symbol_map = { Copilot = '' },
		}),
	},
})

cmp.event:on('menu_opened', function()
	vim.b['copilot_suggestion_hidden'] = true
end)

cmp.event:on('menu_closed', function()
	vim.b['copilot_suggestion_hidden'] = false
end)
