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
	pickers
		.new(themes.get_dropdown({}), {
			prompt_title = opts and opts.prompt or 'Select:',
			finder = finders.new_table({
				results = items or {},
				entry_maker = function(item)
					local text = opts and opts.format_item and opts.format_item(item) or item
					return {
						value = item,
						display = text,
						ordinal = text,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if on_choice ~= nil then
						on_choice(selection.value, selection.index)
					end
				end)
				return true
			end,
		})
		:find()
end

vim.ui.select = select
