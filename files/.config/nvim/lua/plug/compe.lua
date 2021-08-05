vim.o.completeopt = "menuone,noselect"

require('compe').setup({
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  resolve_timeout = 800,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = {
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  },
  source = {
    emoji = false,
    vsnip = false,
    ultisnips = false,
    calc = false,
    path =       { priority = 100, dup = false },
    luasnip =    { priority = 90,  dup = true },
    treesitter = { priority = 80,  dup = true },
    nvim_lsp =   { priority = 70,  dup = false },
    nvim_lua =   { priority = 70,  dup = false },
    buffer =     { priority = 50,  dup = false }
  }
})

vim.cmd([[autocmd User CompeConfirmDone silent! lua vim.lsp.buf.signature_help()]])
