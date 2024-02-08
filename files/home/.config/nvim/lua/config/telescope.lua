local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local telescope = require('telescope')

local defaults = {}

-- defaults.layout_strategy = 'horizontal'
defaults.layout_strategy = 'vertical'

defaults.layout_config = {
	height = 0.9,
	width = 0.8,
	horizontal = {
		height = 0.9,
		preview_cutoff = 120,
		prompt_position = 'bottom',
		width = 0.8,
	},
	vertical = {
		mirror = false,
		height = 0.9,
		preview_cutoff = 40,
		prompt_position = 'bottom',
		width = 0.8,
	},
}

defaults.mappings = {
	i = {
		['<cr>'] = actions.select_default,
		['<c-c>'] = actions.close,
		['<esc>'] = actions.close,
		['jk'] = actions.close,
		['kj'] = actions.close,
		['<c-n>'] = actions.move_selection_next,
		['<c-p>'] = actions.move_selection_previous,
		['<c-f>'] = actions.preview_scrolling_up,
		['<c-b>'] = actions.preview_scrolling_down,
		['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
		['<c-a>'] = actions.select_all,
		['<c-d>'] = actions.drop_all,
		['<Tab>'] = actions.add_selection + actions.move_selection_worse,
		['<S-Tab>'] = actions.remove_selection + actions.move_selection_better,
		['<C-s>'] = actions.select_horizontal,
		['<C-v>'] = actions.select_vertical,
		['<C-t>'] = actions.select_tab,
	},
}

defaults.file_sorter = sorters.get_fzy_sorter
defaults.generic_sorter = sorters.get_fzy_sorter

defaults.vimgrep_arguments = {
	'rg',
	'--color=never',
	'--no-heading',
	'--with-filename',
	'--line-number',
	'--column',
	'--smart-case',
}

telescope.setup({ defaults = defaults })

vim.cmd([[hi! link TelescopeBorder Normal]])
