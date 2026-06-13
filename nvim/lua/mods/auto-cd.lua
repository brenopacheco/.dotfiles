--- auto-cd.lua
---
--- lcd-only autochdir. Never touches cd or tcd.
---
--- Resolution order (delegated to bufinfo.lua):
---   1. netrw       → b:netrw_curdir
---   2. oil://      → oil.get_current_dir()
---   3. fugitive:// → repo root (parent of .git)
---   4. term://     → cwd from URI
---   5. any URI     → path portion
---   6. plain path  → file's parent dir, or the dir itself
---   7. sticky      → vim.b.sticky_dir, cached on first enter
---   8. last lcd    → last successfully resolved lcd, initialised to getcwd(0)
---
--- autochdir is checked on each enter and forced off with a warning if re-enabled.
---
---   | Buffer kind           | Example bufname                                    | lcd                              |
---   |-----------------------|----------------------------------------------------|----------------------------------|
---   | Regular file          | /home/user/projects/app/src/main.lua               | /home/user/projects/app/src/     |
---   | netrw                 | /home/user/projects/                               | b:netrw_curdir via FileType      |
---   | Help buffer           | /usr/share/nvim/runtime/doc/api.txt                | /usr/share/nvim/runtime/doc/     |
---   | oil://                | oil:///home/user/projects/app/src/                 | oil.get_current_dir()            |
---   | fugitive://           | fugitive:///home/user/repo/.git//abc:src/main.lua  | repo root (parent of .git)       |
---   | term://               | term:///home/user/projects//1:bash                 | cwd from URI (if exists on disk) |
---   | Generic URI on disk   | gpg:///home/user/secrets/file.gpg                  | /home/user/secrets/              |
---   | Generic URI not found | gpg:///nonexistent/file.gpg                        | sticky                           |
---   | Quickfix / loclist    | ""                                                 | sticky                           |
---   | Unnamed / nofile      | ""                                                 | sticky                           |

local bi = require('mods.bufinfo')
local group = vim.api.nvim_create_augroup('my/auto-cd', { clear = true })

local last_lcd = vim.fn.getcwd(0)

local function on_enter(buf)
  if vim.o.autochdir then
    vim.o.autochdir = false
    vim.notify(
      'auto-cd: autochdir was re-enabled (probably by another plugin); forcing it off.'
        .. ' Set vim.o.autochdir = false in your config to suppress this warning.',
      vim.log.levels.WARN
    )
  end

  local info = bi.get(buf)
  local dir = info.dir and vim.uv.fs_stat(info.dir) and info.dir or nil

  if not dir and info.dir then
    vim.notify(
      'auto-cd: directory not found on disk: ' .. info.dir,
      vim.log.levels.WARN
    )
  end

  if not dir then dir = vim.b[buf].sticky_dir end

  if not dir then dir = last_lcd end

  if not dir then return end

  vim.b[buf].sticky_dir = vim.b[buf].sticky_dir or dir

  local ok, err = pcall(vim.cmd.lcd, { args = { dir } })
  if ok then
    last_lcd = dir
  else
    vim.notify(
      'auto-cd: lcd failed for ' .. dir .. ': ' .. tostring(err),
      vim.log.levels.WARN
    )
  end
end

local cb = function(ev) on_enter(ev.buf) end

vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  desc = 'Set lcd per buffer kind',
  callback = cb,
})

-- netrw suppresses BufEnter during directory navigation but always sets
-- ft=netrw after updating b:netrw_curdir, so FileType fires at the right
-- moment. Using pattern="netrw" avoids running the full pipeline on every
-- filetype-detection event.
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = 'netrw',
  desc = 'Set lcd for netrw buffers',
  callback = cb,
})

return {}
