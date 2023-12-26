--- Options picker
--
-- Toggle global option

---@class Option
---@field name string
---@field description string
---@field callback fun(): nil

---@return Option
local opt_scrolloff = function()
	return vim.o.scrolloff == 999
			and {
				name = 'scrolloff - min',
				description = 'disable cursor centering',
				callback = function()
					vim.o.scrolloff = 0
				end,
			}
		or {
			name = 'scrolloff - max',
			description = 'enable cursor centering',
			callback = function()
				vim.o.scrolloff = 999
			end,
		}
end

---@return Option
local opt_relnumber = function()
	return vim.o.relativenumber
			and {
				name = 'norelativenumber',
				description = 'disable relative line numbers',
				callback = function()
					vim.o.relativenumber = false
				end,
			}
		or {
			name = 'relativenumber',
			description = 'enable relative line numbers',
			callback = function()
				vim.o.relativenumber = true
			end,
		}
end

---@return Option[]
local options = function()
	return {
		opt_scrolloff(),
		opt_relnumber(),
	}
end

return function()
	vim.ui.select(options(), {
		prompt = 'Toggle global option:',
		format_item = function(item)
			return string.format('%-30s %-45s', item.name, item.description)
		end,
	}, function(choice)
		if choice ~= nil then
			choice.callback()
		end
	end)
end