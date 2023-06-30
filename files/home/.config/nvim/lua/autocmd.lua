vim.cmd([[
  " NOTE: WHY is this defined?
	" autocmd BufEnter,WinEnter * silent! lcd %:p:h
	" autocmd BufEnter,WinEnter * silent! cd %:p:h

  " TODO: this does not work with Git. need to check if file exists and follow
  " augroup FollowSymLink
	" au! BufReadPost * echo "file " . resolve(expand("%")) | edit
  " augroup END
]])
