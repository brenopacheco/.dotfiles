local ok, blink = pcall(require, 'blink.cmp')
if not ok then return end

local config = {
  sources = {
    default = function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local line = vim.api.nvim_get_current_line()
      local word = line:sub(1, col):match('%S+$') or ''
      if word:match('^[/~]') or word:match('^%.%.?/') then return { 'path' } end
      return { 'lsp', 'snippets', 'path' }
    end,
  },
  snippets = { preset = 'default' },
  signature = { enabled = true },
  completion = {
    keyword = {
      range = 'prefix',
    },
    list = {
      selection = {
        preselect = true,
        auto_insert = true,
      },
    },
    menu = {
      auto_show = true,
      max_height = vim.o.pumheight,
    },
  },
  cmdline = {
    enabled = true,
    keymap = {
      preset = 'inherit',
    },
    completion = {
      menu = { auto_show = true },
    },
  },
  keymap = {
    preset = 'none',
    ['<right>'] = { 'accept', 'fallback' },
    ['<left>'] = { 'cancel', 'fallback' },
    ['<down>'] = { 'select_next', 'fallback' },
    ['<up>'] = { 'select_prev', 'fallback' },
    ['<c-j>'] = { 'snippet_forward' },
    ['<c-k>'] = { 'snippet_backward' },
  },
}

blink.setup(config)
