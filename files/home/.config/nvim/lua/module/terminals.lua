-- term_next, term_prev, term_toggle, term_new

local cur_terminal_buf = -1

local function _list_terminal_bufs()
	return vim
		.iter(vim.api.nvim_list_bufs())
		:filter(
			function(buf)
				return vim.api.nvim_get_option_value('buftype', { buf = buf })
						== 'terminal'
					and vim.fn.bufname(buf):match('term://')
			end
		)
		:totable()
end

local function term_next()
	-- TODO:
end

local function term_prev()
	-- TODO:
end

local function term_new()
	vim.cmd('botright term')
	cur_terminal_buf = vim.api.nvim_get_current_buf()
	vim.cmd('wincmd p')
end

local function term_toggle()
	if vim.fn.bufexists(cur_terminal_buf) == 1 then
	-- TODO: here we open the terminal buf
	else
		term_new()
		vim.cmd('wincmd p')
	end
end

vim.api.nvim_create_user_command('TermNext', term_next, { nargs = 0 })
vim.api.nvim_create_user_command('TermPrev', term_next, { nargs = 0 })
vim.api.nvim_create_user_command('TermToggle', term_next, { nargs = 0 })
vim.api.nvim_create_user_command('TermNew', term_next, { nargs = 0 })
