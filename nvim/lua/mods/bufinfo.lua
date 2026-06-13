--- bufinfo.lua
---
--- Structured information about a buffer's relationship to the filesystem.
---
---   get(bufnr) → { kind, path, dir, scheme, label }
---
--- Fields:
---   kind    'file' | 'netrw' | 'oil' | 'fugitive' | 'terminal' |
---           'help' | 'quickfix' | 'nofile' | 'unnamed' |
---           'capture' | 'compile' | 'generic'
---   path    string|nil   best-effort filesystem path (may not exist)
---   dir     string|nil   best-effort directory (may not exist)
---   scheme  string|nil   URI scheme for display labeling ([scheme] prefix)
---   label   string|nil   tail component for display (fnamemodify :t)
---
--- `dir` is computed via vim.fs.dirname for file-like buffers and set
--- directly for directory-oriented buffers (netrw, oil, term).
---
---   Input                                             Kind        path                          dir
---   ────────────────────────────────────────────────  ─────────   ────────────────────────────  ────────────────────────────
---   /home/.../src/main.lua                            file        (same as input)               /home/.../src/
---   netrw buffer, b:netrw_curdir                      netrw       -                             b:netrw_curdir
---   oil:///home/.../src/                              oil         -                             /home/.../src/
---   fugitive:///repo/.git//HEAD:src/main.lua          fugitive    /repo/src/main.lua            /repo    (.git stripped)
---   fugitive:///repo/.git//HEAD:                      fugitive    -                             /repo    (.git stripped, no file)
---   term:///home/.../projects//1:bash                 terminal    -                             /home/.../projects/
---   /usr/.../doc/lua.txt (buf=help)                   help        (same as input)               /usr/.../doc/
---   '' (buf=quickfix)                                 quickfix    -                             -
---   '' (buf=nofile)                                   nofile      -                             -
---   ''                                                unnamed     -                             -
---   capture://~/...//12:echo hi (buf=nofile)          capture     -                             -
---   compile:///proj//5:make                           compile     -                             /proj
---   gpg:///home/.../secrets/file.yaml                 generic     /home/.../secrets/file.yaml   /home/.../secrets/

--- Returns the absolute, normalised path from a scheme://path[//...] URI.
--- Uses fnamemodify :p rather than expand() because expand returns "" for
--- non-existent absolute paths.
local function strip_scheme_path(name, scheme)
  local path = name:match('^' .. scheme .. '://(.-)//')
    or name:match('^' .. scheme .. '://(.*)')
  return path and vim.fn.fnamemodify(path, ':p') or nil
end

---@param bufnr integer
---@return { kind: string, path: string|nil, dir: string|nil, scheme: string|nil, label: string|nil }
local function get(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local buftype = vim.bo[bufnr].buftype
  local filetype = vim.bo[bufnr].filetype

  -- netrw
  if filetype == 'netrw' then
    local dir = vim.b[bufnr].netrw_curdir or name
    if dir == '' then dir = nil end
    if dir then dir = dir:gsub('/$', '') end
    return {
      kind = 'netrw',
      path = nil,
      dir = dir,
      scheme = nil,
      label = dir and vim.fn.fnamemodify(dir, ':t') or nil,
    }
  end

  -- oil://
  if name:match('^oil://') then
    local dir
    local ok, oil = pcall(require, 'oil')
    if ok then dir = oil.get_current_dir(bufnr) end
    if not dir or dir == '' then
      dir = name:gsub('^oil://', ''):gsub('/$', '')
      dir = vim.fn.fnamemodify(dir, ':p')
      if dir == '' then dir = nil end
    end
    if dir then dir = dir:gsub('/$', '') end
    return {
      kind = 'oil',
      path = nil,
      dir = dir,
      scheme = 'oil',
      label = dir and vim.fn.fnamemodify(dir, ':t') or nil,
    }
  end

  -- fugitive://
  if name:match('^fugitive://') then
    local git_dir = strip_scheme_path(name, 'fugitive')
    local repo_root
    local path
    if git_dir then
      repo_root = git_dir:match('^(.*)/%.git')
      if repo_root then
        path = name:match('%.git//[^:]+:(.+)$')
        if path then
          path = vim.fn.fnamemodify(repo_root, ':p'):gsub('/$', '')
            .. '/'
            .. path
        end
        repo_root = vim.fn.fnamemodify(repo_root, ':p'):gsub('/$', '')
      else
        repo_root = vim.fs.dirname(git_dir)
      end
    end
    return {
      kind = 'fugitive',
      path = path,
      dir = repo_root,
      scheme = 'fugitive',
      label = path and vim.fn.fnamemodify(path, ':t') or nil,
    }
  end

  -- term://
  if name:match('^term://') then
    local cwd = strip_scheme_path(name, 'term')
    if cwd then cwd = cwd:gsub('/$', '') end
    return {
      kind = 'terminal',
      path = nil,
      dir = cwd,
      scheme = 'term',
      label = cwd and vim.fn.fnamemodify(cwd, ':t') or nil,
    }
  end

  -- help
  if buftype == 'help' then
    local dir = name ~= '' and vim.fs.dirname(name) or nil
    return {
      kind = 'help',
      path = name ~= '' and name or nil,
      dir = dir,
      scheme = nil,
      label = name ~= '' and vim.fn.fnamemodify(name, ':t') or nil,
    }
  end

  -- quickfix
  if buftype == 'quickfix' then return { kind = 'quickfix' } end

  -- nofile (scratch buffers, etc.)
  if buftype == 'nofile' then
    if name:match('^capture://') then
      return { kind = 'capture', scheme = 'capture' }
    end
    return { kind = 'nofile' }
  end

  -- unnamed (no buffer name)
  if name == '' then return { kind = 'unnamed' } end

  -- compile:// (internal terminal buffer, before generic URI)
  if name:match('^compile://') then
    local dir = name:match('^compile://(.-)//')
    if dir then dir = vim.fn.fnamemodify(dir, ':p'):gsub('/$', '') end
    if dir and dir == '' then dir = nil end
    return { kind = 'compile', dir = dir, scheme = 'compile' }
  end

  -- Generic URI (gpg://, pdf://, custom://, etc.)
  if name:match('^%a[%w-]*://') then
    local scheme = name:match('^(%a[%w-]*)://')
    local path = strip_scheme_path(name, scheme)
    local dir = path and vim.fs.dirname(path) or nil
    return {
      kind = 'generic',
      path = path,
      dir = dir,
      scheme = scheme,
      label = path and vim.fn.fnamemodify(path, ':t') or nil,
    }
  end

  -- Plain filesystem path
  local dir = name ~= '' and vim.fs.dirname(name) or nil
  return {
    kind = 'file',
    path = name ~= '' and name or nil,
    dir = dir,
    scheme = nil,
    label = name ~= '' and vim.fn.fnamemodify(name, ':t') or nil,
  }
end

return { get = get }
