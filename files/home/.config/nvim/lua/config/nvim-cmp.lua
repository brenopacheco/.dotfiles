local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })

cmp.setup({
	enabled = function()
		local disabled = false
		local buftype = vim.api.nvim_get_option_value('buftype', { buf = 0 })
		disabled = disabled or (buftype == 'prompt')
		disabled = disabled or (vim.fn.reg_recording() ~= '')
		disabled = disabled or (vim.fn.reg_executing() ~= '')
		return not disabled
	end,
	completion = {
		completeopt = 'menu,menuone,noinsert',
		autocomplete = {
			cmp.TriggerEvent.TextChanged,
			cmp.TriggerEvent.InsertEnter,
		},
	},
	preselect = cmp.PreselectMode.None,
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
				cmp.complete()
			end
		end, { 'i', 's' }),
		['<C-p>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item({
					behavior = cmp.SelectBehavior.Insert,
				})
			else
				cmp.complete()
			end
		end, { 'i', 's' }),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-e>'] = cmp.mapping.abort(),
		['<C-space>'] = cmp.mapping.abort(),
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = true })
			elseif
				vim.z.enabled('copilot.lua')
				and require('copilot.suggestion').is_visible()
			then
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
		{
			name = 'nvim_lsp',
			keyword_length = 1,
			group_index = 1,
			priority = 100,
			trigger_characters = { '.', '>', '-' },
		},
		{
			name = 'luasnip',
			keyword_length = 1,
			group_index = 1,
			priority = 250,
			trigger_characters = { '#' },
		},
		{
			name = 'path',
			keyword_length = 1,
			group_index = 1,
			priority = 300,
			trigger_characters = { '/', '.' },
			option = {
				trailing_slash = true,
				label_trailing_slash = true,
			},
		},
		{
			name = 'buffer',
			keyword_length = 3,
			group_index = 2,
			priority = 100,
			trigger_characters = {},
			option = {
				get_bufnrs = function()
					local bufs = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						bufs[vim.api.nvim_win_get_buf(win)] = true
					end
					return vim.tbl_keys(bufs)
				end,
			},
		},
	}),
	experimental = {
		ghost_text = {
			hl_group = 'CmpGhostText',
		},
	},
	sorting = {
		priority_weight = 2,
		comparators = {
			cmp.config.compare.score,
			cmp.config.compare.offset,
			cmp.config.compare.kind,
			cmp.config.compare.scopes,
			cmp.config.compare.locality,
			cmp.config.compare.exact,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	---@diagnostic disable-next-line: missing-fields
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
