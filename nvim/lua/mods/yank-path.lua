--- yank-path.lua
---
--- Copies various representations of the current file path to the clipboard.
---
--- Commands:
---   :YankPath           path relative to git root, or cwd (same as rel)
---   :YankPath abs       absolute path
---   :YankPath rel       path relative to git root (falls back to cwd)
---   :YankPath file      filename only
---   :YankPath dir       containing directory
---   :YankPath link      GitHub/GitLab permalink at current line
---
--- Line ranges are supported via ex-range syntax:
---   :.YankPath abs       current line
---   :1,10YankPath link   lines 1–10
---   :'<,'>YankPath link  visually selected range
---
--- Both the `+` and `*` registers are set for cross-platform clipboard
--- compatibility (on Linux they are typically the same).

local function yank(text)
  vim.fn.setreg('+', text)
  vim.fn.setreg('*', text)
  vim.notify('Yanked: ' .. text, vim.log.levels.INFO)
end

--- Returns (start_line, end_line) from the command opts.
--- Three states: (nil, nil) = no line decoration; (n, n) = single line; (s, e) = range.
---@return integer|nil, integer|nil
local function parse_range(opts)
  if opts.range > 0 then return opts.line1, opts.line2 end
  return nil, nil
end

---@return string|nil
local function current_file()
  local abs = vim.fn.expand('%:p')

  if abs == '' then
    vim.notify('Current buffer has no file name', vim.log.levels.INFO)
    return nil
  end

  -- Buffer names with a URI scheme (term://, oil://, fugitive://, etc.)
  -- are not real filesystem paths.
  if abs:match('^%a[%w-]*://') then
    vim.notify('Buffer has no backing file', vim.log.levels.INFO)
    return nil
  end

  return abs
end

----------------------------------------------------------------------
-- Formatters: all take (abs, start_line, end_line) → string|nil
----------------------------------------------------------------------

---@param path string
---@param s integer|nil
---@param e integer|nil
---@return string
local function with_ref(path, s, e)
  if not s then return path end
  if s == e then return path .. ':' .. s end
  return path .. ':' .. s .. '-' .. e
end

---@param abs string
---@param s integer|nil
---@param e integer|nil
---@return string
local function path_rel(abs, s, e)
  -- Relative to git root when inside a repo, cwd otherwise.
  local base = vim.fs.root(abs, '.git') or vim.fn.getcwd(0)
  local rel = vim.fs.relpath(base, abs)
  if not rel then
    vim.notify(
      'Could not make path relative; using absolute',
      vim.log.levels.WARN
    )
  end
  return with_ref(rel or abs, s, e)
end

---@param abs string
---@param s integer|nil
---@param e integer|nil
---@return string
local function path_file(abs, s, e) return with_ref(vim.fs.basename(abs), s, e) end

---@param abs string
---@param s integer|nil
---@param e integer|nil
---@return string
local function path_dir(abs, s, e) return with_ref(vim.fs.dirname(abs), s, e) end

----------------------------------------------------------------------
-- Permalink
----------------------------------------------------------------------

--- Extracts owner/repo from a git remote URL.
--- Handles SSH (git@...) and HTTPS (https://...) for GitHub and GitLab.
--- Multi-segment GitLab group paths (group/subgroup/repo) are not supported;
--- returns nil for these so the caller can notify the user.
---@param url string
---@return string|nil host, string|nil owner, string|nil repo
local function parse_remote(url)
  -- SSH: git@github.com:owner/repo.git
  local host, owner, repo = url:match('^git@([^:]+):([^/]+)/(.+)$')
  if host and owner and repo then
    repo = repo:gsub('%.git$', '')
    return host, owner, repo
  end

  -- HTTPS: https://github.com/owner/repo.git
  -- Only matches a single owner/repo segment — multi-segment GitLab group
  -- paths (e.g. group/subgroup/repo) will not match and return nil.
  host, owner, repo = url:match('^https?://([^/]+)/([^/]+)/([^/]+)$')
  if host and owner and repo then
    repo = repo:gsub('%.git$', '')
    return host, owner, repo
  end

  return nil, nil, nil
end

---@param abs string
---@param start_line integer|nil
---@param end_line integer|nil
---@return string|nil
local function permalink(abs, start_line, end_line)
  local root = vim.fs.root(abs, '.git')
  if not root then
    vim.notify('Not in a git repository', vim.log.levels.WARN)
    return nil
  end

  local remote_result =
    vim.system({ 'git', '-C', root, 'remote', 'get-url', 'origin' }):wait()
  if remote_result.code ~= 0 then
    vim.notify('No git remote "origin" found', vim.log.levels.WARN)
    return nil
  end
  local remote = vim.trim(remote_result.stdout)

  local host, owner, repo = parse_remote(remote)
  if not host or not owner or not repo then
    vim.notify('Could not parse remote URL: ' .. remote, vim.log.levels.ERROR)
    return nil
  end

  local sha_result =
    vim.system({ 'git', '-C', root, 'rev-parse', 'HEAD' }):wait()
  if sha_result.code ~= 0 then
    vim.notify('Could not resolve HEAD commit', vim.log.levels.WARN)
    return nil
  end
  local sha = vim.trim(sha_result.stdout)

  local rel = vim.fs.relpath(root, abs) or abs

  local fragment = ''
  if start_line then
    if start_line == end_line then
      fragment = '#L' .. start_line
    else
      fragment = '#L' .. start_line .. '-L' .. end_line
    end
  end

  if host:match('gitlab') then
    return ('https://%s/%s/%s/-/blob/%s/%s%s'):format(
      host,
      owner,
      repo,
      sha,
      rel,
      fragment
    )
  end

  return ('https://%s/%s/%s/blob/%s/%s%s'):format(
    host,
    owner,
    repo,
    sha,
    rel,
    fragment
  )
end

----------------------------------------------------------------------
-- Command
----------------------------------------------------------------------

local formats = {
  abs = with_ref,
  dir = path_dir,
  file = path_file,
  link = permalink,
  rel = path_rel,
}

-- Statically defined in sorted order for stable tab-completion and error messages.
local COMPLETE = { 'abs', 'dir', 'file', 'link', 'rel' }

local function yank_path(opts)
  local abs = current_file()
  if not abs then return end

  local kind = opts.fargs[1] or 'rel'
  local formatter = formats[kind]

  if not formatter then
    vim.notify(
      ('Unknown path kind: %s (expected: %s)'):format(
        kind,
        table.concat(COMPLETE, ', ')
      ),
      vim.log.levels.ERROR
    )
    return
  end

  local s, e = parse_range(opts)
  local result = formatter(abs, s, e)
  if result then yank(result) end
end

vim.api.nvim_create_user_command('YankPath', yank_path, {
  nargs = '?',
  range = true,
  complete = function(arglead)
    return vim.tbl_filter(
      function(k) return vim.startswith(k, arglead) end,
      COMPLETE
    )
  end,
})

return {}
