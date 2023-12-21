--- Make target picker
--
-- Run any target from Makefile, Go, Rust, etc.

local trim_dir = function(path)
	local trim = 18
	local len = string.len(path)
	local _diff = len - trim
	if _diff < 0 then
		return path
	end
	local _dir = string.sub(path, _diff, len)
	return string.gsub(_dir, '^[^/]+/', '…/')
end

return function()
	local targets = require('utils.make').targets()
	local max_target_len = 0
	for _, target in ipairs(targets) do
		max_target_len = string.len(target.name) > max_target_len
				and string.len(target.name)
			or max_target_len
	end
	vim.ui.select(targets, {
		prompt = 'Run:',
		format_item = function(item)
			---@type Target
			local target = item
			local format = '✔ %-8s %-'
				.. tostring(max_target_len) + 4
				.. 's %-'
				.. 38 - max_target_len
				.. 's %22s'
			return string.format(
				format,
				'[' .. target.kind .. ']',
				target.name,
				target.desc,
				trim_dir(target.dir)
			)
		end,
	}, function(choice)
		if choice ~= nil then
			if vim.z.enabled('voldikss/vim-floaterm') then
				vim.cmd([[let g:floaterm_autoclose = 0]])
				vim.cmd('FloatermNew cd ' .. choice.dir .. '; ' .. choice.cmd)
			else
				vim.cmd('botright term cd ' .. choice.dir .. '; ' .. choice.cmd)
				vim.cmd('wincmd p')
			end
		end
	end)
end
