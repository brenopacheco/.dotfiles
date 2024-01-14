require('globals')
require('options')
require('keymaps')
require('completions').setup()

-- vim.o.updatetime = 300

-- vim.api.nvim_create_autocmd('CursorHoldI', {
-- 	callback = function()
--     pdebug('CursorHoldI init')
-- 	end,
-- })

-- vim.api.nvim_create_autocmd('CursorMovedI', {
--   callback = function()
--     pdebug('CursorMovedI init')
--   end,
-- })
