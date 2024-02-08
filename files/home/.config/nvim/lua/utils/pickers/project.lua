local M = function()
	local roots = {
		'~/git',
		'~/desktop',
		'~/sketch',
		'~/tmp',
		'~/fc',
	}

	local ignore = { '.asdf' }

	local cmd = { 'fd', '-H', '-I', '-t', 'd', '^.git$', '-d', '2' }

	for _, pat in ipairs(ignore) do
		table.insert(cmd, '-E')
		table.insert(cmd, pat)
	end

	for _, root in ipairs(roots) do
		table.insert(cmd, vim.fn.expand(root))
	end

	local out = vim.system(cmd, { text = true }):wait()
	assert(out.code == 0, out.stderr)
	assert(out.stdout ~= '', 'No projects found.')

	local projects = vim
		.iter(vim.split(vim.trim(out.stdout), '\n'))
		:map(function(line)
			local path = string.gsub(line, '/.git/', '')
			local dir = vim.fn.fnamemodify(string.gsub(path, vim.env.HOME, '~'), ':h')
			local name = vim.fn.fnamemodify(path, ':t')
			return { path = path, dir = dir, name = name }
		end)
		:totable()

	vim.ui.select(projects, {
		prompt = 'Switch to project',
		format_item = function(project, cols)
			local padding = cols - string.len(project.name) - 9
			local pat = '  %s %' .. tostring(padding) .. 's'
			return string.format(pat, project.name, '[' .. project.dir .. ']')
		end,
	}, function(choice)
		-- TODO: if does not exist, prompt to create
		require('oil').open(choice.path)
	end)
end

return M
