vim.cmd([[
	autocmd BufEnter,WinEnter * silent! lcd %:p:h
]])
