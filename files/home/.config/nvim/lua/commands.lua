vim.cmd([[
  command! Trim lua u.trim()
  command! W w
  command! Q q
  command! Messages Bufferize messages
	command! Bclean bufdo bd
]])
