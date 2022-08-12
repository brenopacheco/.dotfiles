vim.cmd([[
let g:gutentags_file_list_command = 'rg --files'
let g:gutentags_cache_dir = g:tagsdir
let g:gutentags_ctags_extra_args = ['--excmd=number']
let g:gutentags_file_list_command = 'rg --files --hidden'
]])
