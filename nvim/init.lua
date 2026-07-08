if vim.g.vscode then return end

-- issues:
-- 1. mods/auto-open-qf does not work for things like helpgrep

require('options')
require('plugins')
require('keymaps')

require('mods/auto-cd')
-- require('mods/auto-open-qf')
require('mods/config-dev')
require('mods/readline-keys')
require('mods/foldtext')
require('mods/gpg')
require('mods/last-place')
require('mods/macro-guard')
require('mods/numarks')
require('mods/pdf')
require('mods/better-findfunc')
--require('mods/run')
--require('mods/statusline')
-- require('mods/trim')
require('mods/yank-highlight')
-- require('mods/yank-path')
--
-- require('config/blink')
require('config/conform')
-- require('config/nvim-treesitter')
require('config/oil')
-- require('config/snacks')
