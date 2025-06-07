--- Select picker
--
-- Provides a generic telescope picker that uses the same api from vim.ui.select
--
-- TODO:
--	1. provide on_choice actions for files (e.g: 'tabe | edit <choice>')
--	2. change api to allow actions on multi = true
--	3. refactor
--	4. see oil open for dirs

if not vim.z.enabled('nvim-telescope/telescope.nvim') then
	return vim.notify(
		'[telescope-select]: telescope.nvim not installed',
		vim.log.levels.WARN
	)
end

--- Prompt select an item from a list of items
---
---@param items table Arbitrary items
---@param opts table Additional options
---     - prompt (string|nil)
---               Text of the prompt. Defaults to `Select one of:`
---     - format_item (fun(item: any): string|nil)
---               Function to format an individual item from `items`. Defaults to `tostring`.
---     - kind (string|nil)
---               Arbitrary hint string indicating the item shape.
---     - multi (boolean|nil)
---               If enabled, tab/stab can select/unselect multiple entries,
---               and on_choice is called with a table of selections.
---
---@param on_choice fun(item: any|nil, idx: integer|nil, action: string|nil)
---               Called once the user makes a choice.
---               `item` is the selected entry, or `nil` if cancelled.
---               `idx` is the 1-based index of the selected item, or `nil` if cancelled.
---               `action` describes how the item was chosen. One of:
---                   - "edit"     (default <CR>)
---                   - "tabe"     (<Tab>)
---                   - "split"    (<C-x>)
---                   - "vsplit"   (<C-v>)
---                   - "quickfix" (<C-q>)
---               May be `nil` if the selection was cancelled.
local function select(items, opts, on_choice)
	local finders = require('telescope.finders')
	local pickers = require('telescope.pickers')
	local conf = require('telescope.config').values
	local action_state = require('telescope.actions.state')
	local actions = require('telescope.actions')
	local themes = require('telescope.themes')
	local theme = themes.get_dropdown()
	assert(theme, 'telescope-select: theme not found')
	local ratio = (opts.cols or 75) / vim.o.columns
	if ratio > 1 then ratio = 0.9 end
	theme.layout_config.width = ratio
	pickers
		.new(theme, {
			prompt_title = opts and opts.prompt or 'Select:',
			finder = finders.new_table({
				results = items or {},
				entry_maker = function(item)
					local picker_width = math.floor((ratio * vim.o.columns))
					local text = opts
							and opts.format_item
							and opts.format_item(item, picker_width)
						or item
					return {
						value = item,
						display = text,
						ordinal = text,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(_, map)
				local function make_action(mode)
					return function(prompt_bufnr)
						local selection = action_state.get_selected_entry()
            if opts.multi then
              selection = { selection }
            end
						local picker = action_state.get_current_picker(prompt_bufnr)
						if #picker:get_multi_selection() > 0 then
							selection = picker:get_multi_selection()
						end
						actions.close(prompt_bufnr)
						if on_choice ~= nil then
							if selection == nil then
								vim.notify('No matching entry', vim.log.levels.WARN)
								return
							end
							on_choice(selection.value, selection.index, mode)
						end
					end
				end

				if opts.multi then
					map(
						'i',
						'<tab>',
						actions.toggle_selection + actions.move_selection_worse
					)
					map(
						'i',
						'<s-tab>',
						actions.toggle_selection + actions.move_selection_better
					)
					map('i', '<c-a>', actions.select_all)
					map('i', '<c-d>', actions.drop_all)
				else
					map('i', '<tab>', actions.move_selection_next)
					map('i', '<s-tab>', actions.move_selection_previous)
				end
				map('i', '<cr>', make_action('edit'))
				map('i', '<C-s>', make_action('split'))
				map('i', '<C-v>', make_action('vsplit'))
				map('i', '<C-t>', make_action('tabe'))
				map('i', '<c-q>', make_action('quickfix'))
				map('i', '<c-c>', actions.close)
				map('i', '<esc>', actions.close)
				map('i', 'jk', actions.close)
				map('i', 'kj', actions.close)
				map('i', '<c-n>', actions.move_selection_next)
				map('i', '<c-p>', actions.move_selection_previous)
				map('i', '<c-f>', actions.preview_scrolling_up)
				map('i', '<c-b>', actions.preview_scrolling_down)

				return false
			end,
		})
		:find()
end

vim.ui.select = select
