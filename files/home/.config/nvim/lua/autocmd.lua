vim.cmd([[
  command! FollowSymLink execute "file " . resolve(expand("%")) | edit

  " NOTE: WHY is this defined?
	" autocmd BufEnter,WinEnter * silent! lcd %:p:h
	" autocmd BufEnter,WinEnter * silent! cd %:p:h

  " TODO: this does not work with Git. need to check if file existskand follow
  " augroup FollowSymLink
	" au! BufReadPost * echo "file " . resolve(expand("%")) | edit
  " augroup END
]])
