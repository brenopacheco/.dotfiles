--- Root picker
--
-- Open a project root within a git repository.

local rootutil = require('utils.root')

local pattern_regex = '('
	.. vim.fn.join({
		'package.json',
		'.*.sln',
		'.*.csproj',
		'go.mod',
		'Makefile',
		'Cargo.toml',
	}, [[|]])
	.. ')'

return function()
	local root = rootutil.git_root()
	local result = vim
		.system({ 'fd', '-a', '-t', 'f', pattern_regex, root }, { text = true })
		:wait()
	assert(result.code == 0, 'fd command failed')

	local dirs = vim.fn.sort(vim.tbl_map(function(line)
		return tostring(vim.fs.dirname(line))
	end, vim.split(tostring(vim.fn.trim(result.stdout)), '\n')))

	assert(dirs ~= nil, 'c is nil')

	dirs = vim.fn.uniq(dirs)

	vim.ui.select(dirs, {
		prompt = 'Select root from ' .. root,
		format_item = function(item)
			return item == '.' and './'
				or './' .. string.sub(item, string.len(root) + 2)
		end,
	}, function(choice)
		if choice ~= nil then
			vim.cmd('e ' .. choice)
		end
	end)
end
