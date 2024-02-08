--- Select picker
--
-- Provides a generic telescope picker that uses the same api from vim.ui.select
--
-- TODO: add support for multi select
-- TODO: add configuration option for extra keys (e.g C-v currently runs vsplit)

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
---     - format_item (function item -> text)
---               Function to format an
---               individual item from `items`. Defaults to `tostring`.
---     - kind (string|nil)
---               Arbitrary hint string indicating the item shape.
---               Plugins reimplementing `vim.ui.select` may wish to
---               use this to infer the structure or semantics of
---               `items`, or the context in which select() was called.
---@param on_choice function ((item|nil, idx|nil) -> ())
---               Called once the user made a choice.
---               `idx` is the 1-based index of `item` within `items`.
---               `nil` if the user aborted the dialog.
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
			attach_mappings = function(prompt_bufnr, map)
				map('i', '<tab>', actions.move_selection_next)
				map('i', '<s-tab>', actions.move_selection_previous)
				-- map('i', '<tab>', actions.select_default)

				if opts.on_next then
					local enhance = {
						post = function()
							local selection = action_state.get_selected_entry()
							if not selection then return end
							opts.on_next(selection)
						end,
					}
					actions.move_selection_next:enhance(enhance)
					actions.move_selection_previous:enhance(enhance)
				end

				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if on_choice ~= nil then
						if selection == nil then
							vim.notify('No matching entry', vim.log.levels.WARN)
							return
						end
						on_choice(selection.value, selection.index)
					end
				end)
				return true
			end,
		})
		:find()
end

vim.ui.select = select
