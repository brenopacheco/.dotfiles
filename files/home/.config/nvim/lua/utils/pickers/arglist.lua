local function get_arglist()
	local arglist = vim.fn.argv()
	if type(arglist) ~= 'table' then return end
	if vim.tbl_isempty(arglist) then
		vim.notify('error: argument list is empty', vim.log.levels.WARN)
		return
	end
	local results = {}
	for argnr, path in ipairs(arglist) do
		table.insert(results, {
			index = argnr,
			path = path,
		})
	end
	return results
end

local function get_display(_opts)
	local entry_display = require('telescope.pickers.entry_display')
	local strings = require('plenary.strings')
	local utils = require('telescope.utils')
	local opts = _opts or {}
	local icon = { type = nil, hl = nil, width = 0 }
	icon.type, icon.hl = utils.get_devicons(opts.path, opts.disable_devicons)
	icon.width = strings.strdisplaywidth(icon.type)
	local displayer = entry_display.create({
		separator = ' ',
		items = {
			{ width = strings.strdisplaywidth(vim.fn.argc()) },
			{ width = 1 },
			{ width = icon.width },
			{ remaining = true },
		},
	})
	local argpath = utils.transform_path(opts, opts.path)
	return displayer({
		{ opts.index, 'TelescopeResultsNumber' },
		{ ' ' },
		{ icon.type, icon.hl },
		{ argpath },
	})
end

return function()
	local finders = require('telescope.finders')
	local pickers = require('telescope.pickers')
	local conf = require('telescope.config').values
	local Path = require('plenary.path')
	local results = get_arglist()
	if not results then return end
	local cwd = vim.fn.getcwd()
	pickers
		.new({}, {
			prompt_title = string.format('Global Argument List'),
			finder = finders.new_table({
				results = results,
				entry_maker = function(entry)
					return {
						value = entry,
						display = get_display,
						ordinal = entry.index .. ': ' .. Path:new(entry.path)
							:normalize(cwd),
						path = entry.path,
					}
				end,
			}),
			previewer = conf.grep_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end
