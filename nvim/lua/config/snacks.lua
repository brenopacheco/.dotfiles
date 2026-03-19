local ok, snacks = pcall(require, 'snacks')
if not ok then return end

snacks.did_setup = false
require('snacks').setup({
  picker = {
    win = {
      input = {
        keys = {
          ['jk'] = { 'cancel', mode = { 'i', 'n' } },
          ['kj'] = { 'cancel', mode = { 'i', 'n' } },
        },
      },
    },
    layout = { preset = 'ivy', position = 'bottom' },
  },
})
