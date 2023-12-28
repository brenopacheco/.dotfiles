local rootutils = require('utils.root')
local qfutil = require('utils.qf')

local M = {}

---@param opts { invert: boolean }
M.qf_filter = function(opts)
	local qf, empty = qfutil.qf()
	if empty then
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
				prompt = 'Grep /' .. input,
			},
			function(choice)
				local buffer = vim.fn.bufnr()
				if choice == 'git' then
					local root = rootutils.git_root()
					if root == nil then
						return vim.notify('No git root found', vim.log.levels.WARN)
					end
					vim.cmd("silent grep! '" .. input .. "' " .. rootutils.git_root())
				elseif choice == 'project' then
					local root = rootutils.project_roots()[1]
					if root == nil then
						return vim.notify('No project root found', vim.log.levels.WARN)
					end
					vim.cmd("silent grep! '" .. input .. "' " .. root.path)
				elseif choice == 'curdir' then
					vim.cmd("silent grep! '" .. input .. "' " .. vim.fn.getcwd())
				elseif choice == 'buffer' then
					vim.cmd('silent vimgrep /' .. input .. '/j %')
				elseif choice == 'buflist' then
					vim.cmd(
						'silent cexpr [] | bufdo vimgrepadd /'
							.. input
							.. '/j % | '
							.. buffer
							.. 'b'
					)
				elseif choice == 'arglist' then
					vim.cmd('silent vimgrep /' .. input .. '/j ## | ' .. buffer .. 'b')
				else
					return
				end
				local _, empty = qfutil.qf()
				if not empty then
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
