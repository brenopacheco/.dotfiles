require('indent_blankline').setup {
  char = '|',
  buftype_exclude = {'terminal'},
  filetype_exclude = {'help'},
  use_treesitter = true,
  show_current_context = true, -- With this option enabled, the plugin refreshes on |CursorMoved|,
}
