local ok, oil = pcall(require, 'oil')
if not ok then return end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

oil.setup({
  columns = { 'permissions', 'size', 'mtime', 'icon' },
  cleanup_delay_ms = false,
  silence_scp_warning = true,
  buf_options = {
    buflisted = true,
    bufhidden = 'hide',
  },
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ['g?'] = { 'actions.show_help', mode = 'n' },
    ['<CR>'] = 'actions.select',
    ['<BS>'] = { 'actions.parent', mode = 'n' },
    ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
    ['<C-v>'] = { 'actions.select', opts = { horizontal = true } }, -- does not respect splitright
    ['<C-t>'] = { 'actions.select', opts = { tab = true } },
    ['<C-p>'] = 'actions.preview',
    ['gx'] = 'actions.open_external',
    ['zh'] = { 'actions.toggle_hidden', mode = 'n' },
    ['<C-l>'] = 'actions.refresh',
    ['.'] = 'actions.open_cmdline',
  },
  use_default_keymaps = false,
})

vim.api.nvim_create_autocmd('BufReadCmd', {
  pattern = 'scp://*',
  group = vim.api.nvim_create_augroup('my/oil-hijack-scp', { clear = true }),
  nested = true, -- allows :edit below to trigger Oil's own autocmds
  callback = function(args)
    local oil_url = args.match:gsub('^scp://', 'oil-ssh://', 1)
    vim.schedule(function()
      vim.cmd.edit(oil_url)
      pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
    end)
  end,
})
