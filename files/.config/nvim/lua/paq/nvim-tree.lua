require('nvim-tree').setup({
  -- hijack_directories = {enable = false, auto_open = false},
  update_focused_file = {enable = true, update_root = false},
  git = {enable = true, ignore = true, show_on_dirs = true},
  view = {
    mappings = {
      list = {
        {key = {'<CR>', 'e'}, action = 'edit'}
      }
    }
  }
})
