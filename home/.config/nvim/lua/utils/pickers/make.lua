--- Make target picker
--
-- Run any target from Makefile, Go, Rust, etc.

return function()
	local targets = require('utils.make').targets()
	if #targets == 0 then
		return vim.notify('No targets found', vim.log.levels.WARN)
	end
	local lens = { target = 0, kind = 0, id = 0 }
	for _, target in ipairs(targets) do
		lens.target = math.max(lens.target, #target.name)
		lens.kind = math.max(lens.kind, #target.kind)
		lens.id = math.max(lens.id, #target.id)
	end
	local width = lens.target + lens.kind + lens.id + 10
	vim.ui.select(targets, {
		prompt = 'Run:',
		width = width,
		format_item = function(item)
			---@type Target
			local target = item
			local offset = width - lens.kind - target.name:len() + 6
			local format = '󱓞  %-'
				.. tostring(lens.kind + 4)
				.. 's %-'
				.. tostring(target.name:len())
				.. 's %'
				.. tostring(offset)
				.. 's'
			return string.format(
				format,
				'[' .. target.kind .. ']',
				target.name,
				target.id
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
