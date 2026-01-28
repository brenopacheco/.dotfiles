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
---     - format_item (fun(item: any, width: integer|nil, get_filtered_entries: fun(): table): string|nil)
---               Function to format an individual item from `items`. Defaults to `tostring`.
---               Parameters:
---                 - item: The item to format
---                 - width: The picker width in columns
---                 - get_filtered_entries: Function that returns the currently filtered list of items
---                   (after user's filter input). Note: During entry_maker initialization, this may
---                   return all items or an empty list. Once the picker is active and filtering,
---                   it will return the actual filtered entries.
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

	-- Store picker reference in closure to access filtered entries
	local picker_ref = nil

	-- Function to get filtered entries from the picker
	-- Returns the list of currently filtered items (after user's filter input)
	-- Note: This will return an empty list when called from entry_maker during initialization,
	-- but will have the filtered entries once the picker is active and user filters
	local function get_filtered_entries()
		if not picker_ref then
			-- Picker not yet initialized, return empty or all items
			return items or {}
		end
		local manager = picker_ref.manager
		if not manager then return items or {} end

		-- Try to get filtered entries from the manager
		-- Note: The exact API may vary by telescope version
		-- manager.results should contain the currently filtered/visible entries
		-- after the user types in the filter prompt
		local filtered = {}

		-- Access the manager's results
		-- Try different possible API methods depending on telescope version
		local entry_list = nil
		if manager.results then
			entry_list = manager.results
		elseif manager.get_results then
			entry_list = manager:get_results()
		end

		if entry_list then
			for _, entry in ipairs(entry_list) do
				-- Extract the value from the entry object
				if entry and entry.value then table.insert(filtered, entry.value) end
			end
		end

		return filtered
	end

	pickers
		.new(theme, {
			prompt_title = opts and opts.prompt or 'Select:',
			finder = finders.new_table({
				results = items or {},
				entry_maker = function(item)
					local picker_width = math.floor((ratio * vim.o.columns))
					local text = opts
							and opts.format_item
							and opts.format_item(item, picker_width, get_filtered_entries)
						or item
					return {
						value = item,
						display = text,
						ordinal = text,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				-- Store picker reference for access to filtered entries
				picker_ref = action_state.get_current_picker(prompt_bufnr)
				local function make_action(mode)
					return function(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						if opts.multi then selection = { selection } end
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
