--- readline-keys.lua
---
--- Readline-style line editing for insert mode and command-line mode.
---
--- Bindings provided (insert mode 'i' and command-line mode 'c'):
---   C-Right     forward word
---   C-Left      backward word
---   C-a         beginning of line
---   C-e         end of line
---   C-Delete    kill word forward
---   C-BS        kill word backward
---   C-k         kill to end of line
---   C-y         yank (paste) last kill
---
--- All "kill" commands store the killed text in the unnamed register.
--- C-y pastes from that register.
---
--- Requirements:
---   * Neovim >= 0.10 (uses vim.fn.setcmdline())
---   * Your terminal must send distinct escape sequences for <C-Right>,
---     <C-Left>, <C-Delete>, and <C-BS>. Many terminals (e.g. some default
---     tmux / macOS Terminal.app setups) do NOT send these by default and you
---     may need to configure them or pick different keys.
---
--- Notes / overridden defaults:
---   * Insert mode <C-k> normally starts a digraph; this overrides that.
---   * Insert mode <C-y> normally copies a char from the line above; this
---     overrides that.
---   * Command-line mode <C-a> normally inserts all matches from wildmenu;
---     this overrides that.
---   * Command-line mode <C-e> already means "end of line" by default; this
---     mapping is explicit.

----------------------------------------------------------------------
-- Word-boundary helpers (operate on 0-indexed character positions,
-- where `pos` means "cursor is just before char at 1-indexed pos+1")
----------------------------------------------------------------------

--- Forward word: skip non-word chars, then skip word chars.
---@param line string
---@param pos integer
---@return integer
local function next_word_pos(line, pos)
  local len = #line
  local i = pos
  while i < len and not line:sub(i + 1, i + 1):match('%w') do
    i = i + 1
  end
  while i < len and line:sub(i + 1, i + 1):match('%w') do
    i = i + 1
  end
  return i
end

--- Backward word: skip non-word chars backwards, then skip word chars.
---@param line string
---@param pos integer
---@return integer
local function prev_word_pos(line, pos)
  local i = pos
  while i > 0 and not line:sub(i, i):match('%w') do
    i = i - 1
  end
  while i > 0 and line:sub(i, i):match('%w') do
    i = i - 1
  end
  return i
end

----------------------------------------------------------------------
-- Insert mode implementations
----------------------------------------------------------------------

local function insert_forward_word()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_win_set_cursor(0, { row, next_word_pos(line, col) })
end

local function insert_backward_word()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_win_set_cursor(0, { row, prev_word_pos(line, col) })
end

local function insert_bol()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_win_set_cursor(0, { row, 0 })
end

local function insert_eol()
  local line = vim.api.nvim_get_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_win_set_cursor(0, { row, #line })
end

local function insert_kill_word_forward()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local newcol = next_word_pos(line, col)
  vim.fn.setreg('"', line:sub(col + 1, newcol))
  vim.api.nvim_set_current_line(line:sub(1, col) .. line:sub(newcol + 1))
  vim.api.nvim_win_set_cursor(0, { row, col })
end

local function insert_kill_word_backward()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local newcol = prev_word_pos(line, col)
  vim.fn.setreg('"', line:sub(newcol + 1, col))
  vim.api.nvim_set_current_line(line:sub(1, newcol) .. line:sub(col + 1))
  vim.api.nvim_win_set_cursor(0, { row, newcol })
end

local function insert_kill_to_eol()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.fn.setreg('"', line:sub(col + 1))
  vim.api.nvim_set_current_line(line:sub(1, col))
  vim.api.nvim_win_set_cursor(0, { row, col })
end

local function insert_yank()
  local text = vim.fn.getreg()
  if text == '' then return end
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local parts = vim.split(text, '\n', { plain = true })
  vim.api.nvim_set_current_line(line:sub(1, col) .. parts[1] .. line:sub(col + 1))
  for i = #parts, 2, -1 do
    vim.api.nvim_buf_set_lines(0, row, row, false, { parts[i] })
  end
  local last = parts[#parts]
  local end_row = row + #parts - 1
  local end_col = #parts == 1 and (col + #last) or #last
  vim.api.nvim_win_set_cursor(0, { end_row, end_col })
end

----------------------------------------------------------------------
-- Command-line mode implementations
-- (positions from getcmdpos() are 1-indexed; convert to 0-indexed
-- `pos` where `pos` chars precede the cursor, matching the helpers above)
----------------------------------------------------------------------

local function cmd_forward_word()
  local line = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos() - 1
  vim.fn.setcmdline(line, next_word_pos(line, pos) + 1)
end

local function cmd_backward_word()
  local line = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos() - 1
  vim.fn.setcmdline(line, prev_word_pos(line, pos) + 1)
end

local function cmd_bol()
  vim.fn.setcmdline(vim.fn.getcmdline(), 1)
end

local function cmd_eol()
  local line = vim.fn.getcmdline()
  vim.fn.setcmdline(line, #line + 1)
end

local function cmd_kill_word_forward()
  local line = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos() - 1
  local newpos = next_word_pos(line, pos)
  vim.fn.setreg('"', line:sub(pos + 1, newpos))
  vim.fn.setcmdline(line:sub(1, pos) .. line:sub(newpos + 1), pos + 1)
end

local function cmd_kill_word_backward()
  local line = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos() - 1
  local newpos = prev_word_pos(line, pos)
  vim.fn.setreg('"', line:sub(newpos + 1, pos))
  vim.fn.setcmdline(line:sub(1, newpos) .. line:sub(pos + 1), newpos + 1)
end

local function cmd_kill_to_eol()
  local line = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos() - 1
  vim.fn.setreg('"', line:sub(pos + 1))
  vim.fn.setcmdline(line:sub(1, pos), pos + 1)
end

local function cmd_yank()
  local text = vim.fn.getreg()
  if text == '' then return end
  local line = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos() - 1
  vim.fn.setcmdline(
    line:sub(1, pos) .. text .. line:sub(pos + 1),
    pos + 1 + #text
  )
end

----------------------------------------------------------------------
-- Keymaps
----------------------------------------------------------------------

local opts = { noremap = true, silent = true }

-- Insert mode
vim.keymap.set('i', '<Up>', '<Up>', { noremap = true })
vim.keymap.set('i', '<Down>', '<Down>', { noremap = true })
vim.keymap.set('i', '<C-Right>', insert_forward_word, opts)
vim.keymap.set('i', '<C-Left>', insert_backward_word, opts)
vim.keymap.set('i', '<C-a>', insert_bol, opts)
vim.keymap.set('i', '<C-e>', insert_eol, opts)
vim.keymap.set('i', '<C-Delete>', insert_kill_word_forward, opts)
vim.keymap.set('i', '<C-BS>', insert_kill_word_backward, opts)
vim.keymap.set('i', '<C-k>', insert_kill_to_eol, opts)
vim.keymap.set('i', '<C-y>', insert_yank, opts)

-- Command-line mode (no silent — cmdline must redraw after setcmdline)
vim.keymap.set('c', '<C-Right>', cmd_forward_word, { noremap = true })
vim.keymap.set('c', '<C-Left>', cmd_backward_word, { noremap = true })
vim.keymap.set('c', '<C-a>', cmd_bol, { noremap = true })
vim.keymap.set('c', '<C-e>', cmd_eol, { noremap = true })
vim.keymap.set('c', '<C-Delete>', cmd_kill_word_forward, { noremap = true })
vim.keymap.set('c', '<C-BS>', cmd_kill_word_backward, { noremap = true })
vim.keymap.set('c', '<C-k>', cmd_kill_to_eol, { noremap = true })
vim.keymap.set('c', '<C-y>', cmd_yank, { noremap = true })

return {}
