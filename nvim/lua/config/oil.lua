local ok, oil = pcall(require, 'oil')
if not ok then return end

oil.setup({
  columns = { 'permissions', 'size', 'mtime', 'icon' },
  buf_options = {
    buflisted = true,
    bufhidden = 'hide',
  },
  keymaps = {
    ['g?'] = { 'actions.show_help', mode = 'n' },
    ['<CR>'] = 'actions.select',
    ['<Right>'] = 'actions.select',
    ['<BS>'] = { 'actions.parent', mode = 'n' },
    ['<Left>'] = { 'actions.parent', mode = 'n' },
    ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
    ['<C-t>'] = { 'actions.select', opts = { tab = true } },
    ['<C-p>'] = 'actions.preview',
    ['gx'] = 'actions.open_external',
    ['zh'] = { 'actions.toggle_hidden', mode = 'n' },
    ['zx'] = 'actions.refresh',
    ['.'] = 'actions.open_cmdline',
  },
  use_default_keymaps = false,
})
