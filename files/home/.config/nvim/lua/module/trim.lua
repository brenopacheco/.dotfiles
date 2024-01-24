local function trim() vim.cmd([[%s/\s\+$//]]) end

vim.api.nvim_create_user_command('Trim', trim, { nargs = 0 })
