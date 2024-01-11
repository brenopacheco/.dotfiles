_G.foldtext = function()
	local commentstring = vim.opt.commentstring:get()
  commentstring = (commentstring:match('(^%S+)*') or '')
	local line = tostring(vim.fn.getline(vim.v.foldstart))
	line = line:gsub(commentstring, '')
  line = line:gsub('^[%-{[(/%s=]*', '')
	local dash = string.sub(vim.v.folddashes, 1, 1)
	line = string.format('+%s %s', string.rep(dash, vim.v.foldlevel + 1), line)
	line = line:gsub('[%-{[(/%s=]*$', '')
	local tw = vim.opt.textwidth:get()
	if line:len() > tw then
		line = line:sub(1, tw - 11) .. '...'
	end
	local suffix = string.format(' %s-%s#', vim.v.foldstart, vim.v.foldend)
	local trailing = string.rep('—', tw - line:len() - suffix:len() - 1)
	line = string.format('%s %s%s', line, trailing, suffix)
	return line
end

vim.opt.fillchars = 'fold: '
vim.opt.foldtext = 'v:lua.foldtext()'
