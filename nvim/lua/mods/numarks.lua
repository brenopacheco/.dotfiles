--- nummarks.lua
---
--- Quick numeric access to letter marks A-I via keys 1-9.
---
--- Mappings:
---   m{1-9}   set mark A-I at the cursor position
---   '{1-9}   jump to mark A-I (linewise, first non-blank)
---   `{1-9}   jump to mark A-I (exact position)
---
--- Available in normal and visual mode for the jump mappings; mark-setting
--- is normal mode only.
---
--- Each action notifies with the mark letter and its line/column, making it
--- easy to confirm which mark was set or where a jump landed.

if vim.g.nummarks_notify == nil then vim.g.nummarks_notify = true end

local function mark_pos(mark)
  local pos = vim.api.nvim_buf_get_mark(0, mark)
  local filename = vim.fn.expand('%:t')
  return filename, pos[1]
end

local function notify(msg)
  if vim.g.nummarks_notify then vim.notify(msg) end
end

local function set_mark(mark)
  vim.cmd('mark ' .. mark)

  local file, line = mark_pos(mark)
  notify(string.format('Set mark %s at %s:%d', mark, file, line))
end

local function jump_mark(mark, quote)
  vim.cmd('normal! ' .. quote .. mark)

  local file, line = mark_pos(mark)
  notify(string.format('Jumped to mark %s at %s:%d', mark, file, line))
end

--- Convert number 1–9 into mark letter A–I
local function num_to_mark(i) return string.char(string.byte('A') + i - 1) end

for i = 1, 9 do
  local mark = num_to_mark(i)

  vim.keymap.set(
    'n',
    'm' .. i,
    function() set_mark(mark) end,
    { desc = 'Set mark ' .. mark }
  )

  for _, quote in ipairs({ "'", '`' }) do
    vim.keymap.set(
      { 'n', 'x' },
      quote .. i,
      function() jump_mark(mark, quote) end,
      { desc = 'Jump to mark ' .. mark }
    )
  end
end
