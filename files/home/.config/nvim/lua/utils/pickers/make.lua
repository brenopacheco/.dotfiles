--- Make target picker
--
-- Run any target from Makefile, Go, Rust, etc.

return function()
	local targets = require('utils.make').targets()
	if #targets == 0 then
		return vim.notify('No targets found', vim.log.levels.WARN)
	end
	local max_target_len = 0
	for _, target in ipairs(targets) do
		max_target_len = string.len(target.name) > max_target_len
				and string.len(target.name)
			or max_target_len
	end
	if #targets == 0 then
		return vim.notify('No targets found', vim.log.levels.WARN)
	end
	vim.ui.select(targets, {
		prompt = 'Run:',
		format_item = function(item)
			---@type Target
			local target = item
			local format = '󱓞 %-8s %-'
				.. tostring(max_target_len) + 4
				.. 's %'
				.. 59 - max_target_len
				.. 's'
			return string.format(
				format,
				'[' .. target.kind .. ']',
				target.name,
				vim.fn.fnamemodify(target.dir, ':t')
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
