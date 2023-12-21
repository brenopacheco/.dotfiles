local rootutils = require('utils.root')

local M = {}

---@param opts { invert: boolean }
M.qf_filter = function(opts)
	local qf = vim.fn.getqflist()
	if qf == nil or #qf == 0 then
		return vim.notify('No quickfix list found', vim.log.levels.WARN)
	end
	local letter = opts.invert and 'v' or 'g'
	vim.ui.input({ prompt = '>Quickfix: ' .. letter .. '/' }, function(input)
		if input == nil or input == '' then
			return
		end
		local filtered = {}
		for _, item in ipairs(qf) do
			local fname = vim.fn.fnamemodify(vim.fn.bufname(item.bufnr), ':t')
			local text = fname .. ':' .. item.text
			local matches = string.match(text, input)
			if matches and not opts.invert then
				table.insert(filtered, item)
			elseif not matches and opts.invert then
				table.insert(filtered, item)
			end
		end
		vim.fn.setqflist(filtered)
		vim.cmd('copen | wincmd p')
	end)
end

---@param pattern string | nil
M.grep_pattern = function(pattern)
	local handler = function(input)
		if input == nil or input == '' then
			return
		end
		vim.ui.select(
			{ 'git', 'project', 'curdir', 'buffer', 'buflist', 'arglist' },
			{
				prompt = 'Where to apply grep pattern:',
			},
			function(choice)
				local buffer = vim.fn.bufnr()
				if choice == 'git' then
					vim.cmd("grep! '" .. pattern .. "' " .. rootutils.git_root())
				elseif choice == 'project' then
					vim.cmd("grep! '" .. pattern .. "' " .. rootutils.project_roots())
				elseif choice == 'curdir' then
					vim.cmd("grep! '" .. pattern .. "' " .. vim.fn.getcwd())
				elseif choice == 'buffer' then
					vim.cmd('vimgrep /' .. input .. '/j %')
				elseif choice == 'buflist' then
					vim.cmd(
						':cexpr [] | bufdo vimgrepadd /'
							.. pattern
							.. '/j % | '
							.. buffer
							.. 'b'
					)
				elseif choice == 'arglist' then
					vim.cmd('vimgrep /' .. pattern .. '/j ## | ' .. buffer .. 'b')
				else
					return
				end
				if vim.fn.getqflist({ bufnr = buffer }).total ~= 0 then
					vim.cmd('copen | wincmd p')
				end
			end
		)
	end
	if pattern == nil or pattern == '' then
		return vim.ui.input({ prompt = '>Grep /' }, handler)
	end
	handler(pattern)
end

return M
