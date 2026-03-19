--- trim.lua
---
--- Cleans up whitespace and end-of-file formatting in the current buffer.
---
--- Commands:
---   :Trim    remove trailing whitespace and normalize end-of-file formatting
---
--- End-of-file normalization collapses multiple trailing blank lines into one,
--- ensuring exactly one trailing newline. If the buffer has no trailing newline
--- at all it is left as-is — none is added.
---
--- The cursor position, window view, and search register are preserved.
--- Note: keeppatterns does not protect @/ from the substitution — the explicit
--- save/restore of the search register in the command handler is doing real work.

local function do_trim()
  -- Whitespace must be stripped first so the EOF walk-back only ever
  -- encounters '' lines rather than whitespace-only ones.
  -- Note: keeppatterns prevents the pattern entering search history but
  -- does NOT protect @/ — the caller is responsible for saving/restoring it.
  vim.cmd([[silent keepjumps keeppatterns %s/\s\+$//e]])

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Walk back from the end to find the start of the trailing blank run.
  local first_blank = #lines + 1
  while first_blank > 1 and lines[first_blank - 1]:match('^%s*$') do
    first_blank = first_blank - 1
  end

  -- No trailing blank lines — the buffer has no trailing newline. Leave as-is.
  if first_blank > #lines then return end

  -- In Neovim's line array a final '' represents the trailing newline.
  -- If there is already exactly one, the file is clean — avoid a spurious write.
  if first_blank == #lines and lines[#lines] == '' then return end

  vim.api.nvim_buf_set_lines(0, first_blank - 1, #lines, false, { '' })
end

vim.api.nvim_create_user_command('Trim', function()
  local view = vim.fn.winsaveview()
  local search = vim.fn.getreg('/')

  do_trim()

  vim.fn.winrestview(view)
  vim.fn.setreg('/', search)
end, { desc = 'Remove trailing whitespace and normalize EOF' })

return {}
