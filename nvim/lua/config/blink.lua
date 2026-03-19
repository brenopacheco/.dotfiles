local ok, blink = pcall(require, 'blink.cmp')
if not ok then return end

blink.setup({
  sources = {
    default = function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local line = vim.api.nvim_get_current_line()
      local word = line:sub(1, col):match('%S+$') or ''
      if word:match('^[/~]') or word:match('^%.%.?/') then return { 'path' } end
      return { 'lsp', 'buffer', 'snippets', 'path' }
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
    -- default keybindings
    ['<c-n>'] = { 'select_next', 'fallback' },
    ['<c-p>'] = { 'select_prev', 'fallback' },
    ['<c-e>'] = { 'cancel', 'fallback' },
    ['<c-y>'] = { 'accept', 'fallback' },
    -- ['<c-j>'] = { 'snippet_forward', 'fallback' },
    -- ['<c-k>'] = { 'snippet_backward', 'fallback' },
    ['<c-j>'] = { 'snippet_forward' },
    ['<c-k>'] = { 'snippet_backward' },

    ['<down>'] = { 'select_next', 'fallback' },
    ['<up>'] = { 'select_prev', 'fallback' },
    ['<right>'] = { 'accept', 'fallback' },
    ['<left>'] = { 'cancel', 'fallback' },

    -- not recognized by st
    -- ['<c-.>'] = { 'accept', 'fallback' },
    -- ['<c-,>'] = { 'cancel', 'fallback' },

    -- 1st try
    -- ['<Down>'] = { 'select_next', 'fallback' },
    -- ['<Up>'] = { 'select_prev', 'fallback' },
    -- ['<Right>'] = {
    --   function(cmp)
    --     if cmp.is_visible() then return cmp.accept() end
    --   end,
    --   function(cmp)
    --     if cmp.snippet_active() then return cmp.snippet_forward() end
    --   end,
    --   'fallback',
    -- },
    -- ['<Left>'] = {
    --   function(cmp)
    --     if cmp.is_visible() then cmp.cancel() end
    --   end,
    --   function(cmp)
    --     if cmp.snippet_active() then return cmp.snippet_backward() end
    --   end,
    --   'fallback',
    -- },
  },
})
