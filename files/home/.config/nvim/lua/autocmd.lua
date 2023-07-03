vim.cmd([[
  command! FollowSymLink execute "file " . resolve(expand("%")) | edit

  " NOTE: WHY is this defined?
	autocmd BufEnter,WinEnter * silent! lcd %:p:h
	autocmd BufEnter,WinEnter * silent! cd %:p:h

  " TODO: this does not work with Git. need to check if file existskand follow
  " augroup FollowSymLink
	" au! BufReadPost * echo "file " . resolve(expand("%")) | edit
  " augroup END
]])


local group = vim.api.nvim_create_augroup('user_cmds', {clear = true})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = group,
  callback = function()
    vim.highlight.on_yank({higroup = 'Visual', timeout = 300})
  end,
})
