vim.cmd([[
	autocmd BufEnter,WinEnter * silent! lcd %:p:h
	autocmd BufEnter,WinEnter * silent! cd %:p:h
]])
