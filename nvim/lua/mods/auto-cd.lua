--- auto-cd.lua
---
--- lcd-only autochdir. Never touches cd or tcd.
---
--- Resolvers are tried in order; the first to return a non-nil directory wins:
---   1. netrw       → b:netrw_curdir
---   2. oil://      → oil.get_current_dir()
---   3. fugitive:// → repo root (parent of .git)
---   4. term://     → cwd from URI (if it exists on disk)
---   5. any URI     → path portion (if it exists on disk)
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

local group = vim.api.nvim_create_augroup('my/auto-cd', { clear = true })

-- Seed with the window-local cwd at load time so the last-lcd fallback is
-- always populated even before the first BufEnter fires.
local last_lcd = vim.fn.getcwd(0)

---@param path string
---@return string|nil
local function fs_dir(path)
  local stat = vim.uv.fs_stat(path)
  if not stat then return nil end
  return stat.type == 'directory' and path or vim.fs.dirname(path)
end

-- Extract the path component from scheme://path[//rest] URIs.
local function strip_scheme_path(name, scheme)
  local path = name:match('^' .. scheme .. '://(.-)//')
  path = path or name:match('^' .. scheme .. '://(.*)')
  return vim.fn.expand(path)
end

-- Resolver table: { pattern|nil, fn(name, buf) -> string|nil }
-- The dispatcher matches `pattern` against the buffer name before calling fn.
-- nil pattern means the resolver is always called.
-- Priority: first non-nil return wins.
local resolvers = {
  -- netrw: b:netrw_curdir is authoritative (buffer name may be fake in tree mode).
  {
    nil,
    function(_, buf)
      if vim.bo[buf].filetype ~= 'netrw' then return end
      local curdir = vim.b[buf].netrw_curdir
      if not curdir or curdir == '' then return end
      return fs_dir(curdir)
    end,
  },

  -- oil://: use oil.get_current_dir() to support remote backends.
  {
    '^oil://',
    function(_, buf)
      local ok, oil = pcall(require, 'oil')
      if not ok then return end
      local dir = oil.get_current_dir(buf)
      if not dir or dir == '' then return end
      return fs_dir(dir)
    end,
  },

  -- fugitive://: strip /.git//... to get the repo root.
  {
    '^fugitive://',
    function(name, _)
      local git_dir = strip_scheme_path(name, 'fugitive')
      if not git_dir or git_dir == '' then return end
      local repo_root = git_dir:match('^(.*)/%.git')
      if repo_root and repo_root ~= '' then return fs_dir(repo_root) end
      -- Non-standard GIT_DIR (e.g. a worktree gitdir file rather than a .git
      -- directory): use the parent as a best-effort repo root.
      return fs_dir(vim.fs.dirname(git_dir))
    end,
  },

  -- term://: extract cwd before the //id:cmd portion.
  {
    '^term://',
    function(name, _)
      local cwd = strip_scheme_path(name, 'term')
      if not cwd or cwd == '' then return end
      return fs_dir(cwd)
    end,
  },

  -- Any remaining URI: extract path after scheme://. Reached only for schemes
  -- not already matched above (oil://, fugitive://, term://).
  {
    '^%a[%w-]*://',
    function(name, _) return fs_dir(name:match('^%a[%w-]*://(.*)')) end,
  },

  -- Plain filesystem path (regular files, directories, help, …).
  -- fs_dir returns nil for empty names and non-existent paths.
  { nil, function(name, _) return fs_dir(name) end },

  -- Sticky: dir cached on first enter; nil if buffer not yet visited.
  { nil, function(_, buf) return vim.b[buf].sticky_dir end },

  -- Final fallback: last successfully resolved lcd (seeded to getcwd(0)).
  { nil, function() return last_lcd end },
}

local function on_enter(buf)
  if vim.o.autochdir then
    vim.o.autochdir = false
    vim.notify(
      'auto-cd: autochdir was re-enabled (probably by another plugin); forcing it off.'
        .. ' Set vim.o.autochdir = false in your config to suppress this warning.',
      vim.log.levels.WARN
    )
  end

  local name = vim.api.nvim_buf_get_name(buf)

  local dir
  for _, entry in ipairs(resolvers) do
    local pat, fn = entry[1], entry[2]
    if not pat or name:match(pat) then
      dir = fn(name, buf)
      if dir then break end
    end
  end

  if not dir then return end

  -- Cache on first enter only so the sticky resolver can short-circuit
  -- subsequent enters without re-running the pipeline.
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

-- BufEnter covers most buffers.
vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  desc = 'Set lcd per buffer kind',
  callback = cb,
})

-- FileType netrw only: netrw suppresses BufEnter during directory navigation
-- but always sets ft=netrw after updating b:netrw_curdir, so FileType fires
-- at the right moment. Using pattern="netrw" avoids running the full resolver
-- pipeline on every filetype-detection event.
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = 'netrw',
  desc = 'Set lcd for netrw buffers',
  callback = cb,
})

return {}
