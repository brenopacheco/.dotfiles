--- readline-keys.lua
---
--- Readline-style line editing for insert mode and command-line mode.
---
--- Bindings provided (insert mode 'i' and command-line mode 'c'):
---   C-Right / A-Right  forward word  (equivalent to normal-mode 'e')
---   C-Left  / A-Left   backward word (equivalent to normal-mode 'b')
---   C-a                beginning of line
---   C-e                end of line
---   C-Delete           kill word forward
---   C-BS               kill word backward
---   C-k                kill to end of line
---   C-y                yank (paste) last kill
---   C-up               backward paragraph (insert mode)
---   C-down             forward paragraph (insert mode)
---   A-a                backward sentence (insert mode)
---   A-e                forward sentence (insert mode)
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
---
--- Issues:
---   * Cancelling completion via <C-e> does not work anymore. This can be
---     fixed by patching insert_eol cmd_eol to check for pumvisible and
---     wildmenumode.

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
  vim.api.nvim_set_current_line(
    line:sub(1, col) .. parts[1] .. line:sub(col + 1)
  )
  for i = #parts, 2, -1 do
    vim.api.nvim_buf_set_lines(0, row, row, false, { parts[i] })
  end
  local last = parts[#parts]
  local end_row = row + #parts - 1
  local end_col = #parts == 1 and (col + #last) or #last
  vim.api.nvim_win_set_cursor(0, { end_row, end_col })
end

local function is_empty_line(r)
  if r < 1 then return true end
  local l = vim.api.nvim_buf_get_lines(0, r - 1, r, false)[1] or ''
  return l:match('^%s*$') ~= nil
end

local function insert_backward_paragraph()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local total = vim.api.nvim_buf_line_count(0)
  local r = row - 1
  while r >= 1 and not is_empty_line(r) do
    r = r - 1
  end
  local para_start = r + 1
  if para_start == row then
    r = row - 1
    while r >= 1 and is_empty_line(r) do
      r = r - 1
    end
    if r < 1 then
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      return
    end
    while r >= 1 and not is_empty_line(r) do
      r = r - 1
    end
    para_start = r + 1
  end
  vim.api.nvim_win_set_cursor(0, { para_start, 0 })
end

local function insert_forward_paragraph()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local total = vim.api.nvim_buf_line_count(0)
  local r = row
  while r <= total and not is_empty_line(r) do
    r = r + 1
  end
  local para_end = r - 1
  if para_end == row then
    r = row + 1
    while r <= total and is_empty_line(r) do
      r = r + 1
    end
    if r > total then
      local line = vim.api.nvim_buf_get_lines(0, para_end - 1, para_end, false)[1]
        or ''
      vim.api.nvim_win_set_cursor(0, { para_end, #line })
      return
    end
    while r <= total and not is_empty_line(r) do
      r = r + 1
    end
    para_end = r - 1
  end
  local line = vim.api.nvim_buf_get_lines(0, para_end - 1, para_end, false)[1]
    or ''
  vim.api.nvim_win_set_cursor(0, { para_end, #line })
end

local function insert_forward_sentence()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local total = vim.api.nvim_buf_line_count(0)
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ''
  local off = line:find('[.!?][ \t]', col + 1)
  if off then
    vim.api.nvim_win_set_cursor(0, { row, off + 1 })
    return
  end
  if line:sub(-1):match('[.!?]') then
    vim.api.nvim_win_set_cursor(0, { row, #line })
    return
  end
  for r = row + 1, total do
    local l = vim.api.nvim_buf_get_lines(0, r - 1, r, false)[1] or ''
    local o = l:find('[.!?][ \t]')
    if o then
      vim.api.nvim_win_set_cursor(0, { r, o + 1 })
      return
    end
    if #l == 0 then
      vim.api.nvim_win_set_cursor(0, { r, 0 })
      return
    end
    if l:sub(-1):match('[.!?]') then
      vim.api.nvim_win_set_cursor(0, { r, #l })
      return
    end
  end
end

local function insert_backward_sentence()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ''
  local last = nil
  local pos = 1
  while pos < col do
    local s, e = line:find('[.!?][ \t]', pos)
    if not s or e >= col then break end
    last = e + 1
    pos = e + 1
  end
  if last then
    vim.api.nvim_win_set_cursor(0, { row, last })
    return
  end
  for r = row - 1, 1, -1 do
    local l = vim.api.nvim_buf_get_lines(0, r - 1, r, false)[1] or ''
    if #l == 0 then
      vim.api.nvim_win_set_cursor(0, { r, 0 })
      return
    end
    local e2 = nil
    local p = 1
    while p <= #l do
      local ss, ee = l:find('[.!?][ \t]', p)
      if not ss then break end
      e2 = ee
      p = ee + 1
    end
    if e2 then
      vim.api.nvim_win_set_cursor(0, { r, e2 + 1 })
      return
    end
    if l:sub(-1):match('[.!?]') then
      vim.api.nvim_win_set_cursor(0, { r, #l })
      return
    end
  end
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

local function cmd_bol() vim.fn.setcmdline(vim.fn.getcmdline(), 1) end

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

local function cmd_history_prev()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<Up>', true, false, true),
    'n',
    true
  )
end

local function cmd_history_next()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<Down>', true, false, true),
    'n',
    true
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
vim.keymap.set('i', '<A-Right>', insert_forward_word, opts)
vim.keymap.set('i', '<A-Left>', insert_backward_word, opts)
vim.keymap.set('i', '<C-Up>', insert_backward_paragraph, opts)
vim.keymap.set('i', '<C-Down>', insert_forward_paragraph, opts)
vim.keymap.set('i', '<A-a>', insert_backward_sentence, opts)
vim.keymap.set('i', '<A-e>', insert_forward_sentence, opts)
vim.keymap.set('i', '<C-a>', insert_bol, opts)
vim.keymap.set('i', '<C-e>', insert_eol, opts)
vim.keymap.set('i', '<C-Delete>', insert_kill_word_forward, opts)
vim.keymap.set('i', '<C-BS>', insert_kill_word_backward, opts)
vim.keymap.set('i', '<C-k>', insert_kill_to_eol, opts)
vim.keymap.set('i', '<C-y>', insert_yank, opts)

-- Command-line mode (no silent — cmdline must redraw after setcmdline)
vim.keymap.set('c', '<C-Right>', cmd_forward_word, { noremap = true })
vim.keymap.set('c', '<C-Left>', cmd_backward_word, { noremap = true })
vim.keymap.set('c', '<A-Right>', cmd_forward_word, { noremap = true })
vim.keymap.set('c', '<A-Left>', cmd_backward_word, { noremap = true })
vim.keymap.set('c', '<C-Up>', cmd_history_prev, { noremap = true })
vim.keymap.set('c', '<C-Down>', cmd_history_next, { noremap = true })
vim.keymap.set('c', '<C-a>', cmd_bol, { noremap = true })
vim.keymap.set('c', '<C-e>', cmd_eol, { noremap = true })
vim.keymap.set('c', '<C-Delete>', cmd_kill_word_forward, { noremap = true })
vim.keymap.set('c', '<C-BS>', cmd_kill_word_backward, { noremap = true })
vim.keymap.set('c', '<C-k>', cmd_kill_to_eol, { noremap = true })
vim.keymap.set('c', '<C-y>', cmd_yank, { noremap = true })

return {}
