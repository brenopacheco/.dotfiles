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
---
--- TODO: get the line number too, optionally?

local bi = require('mods.bufinfo')

local function git_root(path) return vim.fs.root(path, '.git') end

local function git_cmd(root, ...)
  local args = { 'git', '-C', root, ... }
  local output = vim.trim(vim.fn.system(args))
  if vim.v.shell_error ~= 0 then return nil end
  return output
end

local function resolve_effective_path()
  local info = bi.get(vim.api.nvim_get_current_buf())
  return info.path or info.dir
end

local function get_rel_path()
  local path = resolve_effective_path()
  if not path then return nil end
  local root = git_root(path)
  if root and vim.startswith(path, root) then
    local rel = path:sub(#root + 2)
    return rel ~= '' and rel or '.'
  end
  return vim.fn.fnamemodify(path, ':.')
end

local function get_abs_path()
  local path = resolve_effective_path()
  if not path then return nil end
  return vim.fn.fnamemodify(path, ':p')
end

local function get_file()
  local path = resolve_effective_path()
  if not path then return nil end
  return vim.fn.fnamemodify(path, ':t')
end

local function get_dir()
  local path = resolve_effective_path()
  if not path then return nil end
  local stat = vim.uv.fs_stat(path)
  if stat and stat.type == 'directory' then
    return vim.fn.fnamemodify(path, ':p'):gsub('/$', '')
  end
  return vim.fn.fnamemodify(path, ':h')
end

local function get_link(line1, line2)
  local path = resolve_effective_path()
  if not path then return nil end
  local root = git_root(path)
  if not root then return nil end

  local rel = path:sub(#root + 2)

  local remote = git_cmd(root, 'remote', 'get-url', 'origin')
  if not remote or remote == '' then return nil end

  local web_url

  -- git@host:path.git
  local host, repo_path = remote:match('^git@([^:]+):(.+)')
  if host then
    repo_path = repo_path:gsub('%.git$', '')
    web_url = 'https://' .. host .. '/' .. repo_path
  end

  -- https://host/path.git
  if not web_url then
    local proto, h, p = remote:match('^(https?)://([^/]+)/(.+)$')
    if proto then
      p = p:gsub('%.git$', '')
      web_url = proto .. '://' .. h .. '/' .. p
    end
  end

  -- ssh://git@host/path.git
  if not web_url then
    local h, p = remote:match('^ssh://git@([^/]+)/(.+)$')
    if h then
      p = p:gsub('%.git$', '')
      web_url = 'https://' .. h .. '/' .. p
    end
  end

  if not web_url then return nil end

  local ref = git_cmd(root, 'rev-parse', '--abbrev-ref', 'HEAD')
  if not ref or ref == '' or ref == 'HEAD' then
    ref = git_cmd(root, 'rev-parse', 'HEAD')
    if not ref then return nil end
  end

  local is_gitlab = web_url:find('gitlab%.com')

  local base = is_gitlab and web_url .. '/-/blob/' .. ref .. '/' .. rel
    or web_url .. '/blob/' .. ref .. '/' .. rel

  if line1 == line2 then return base .. '#L' .. line1 end
  return base .. '#L' .. line1 .. '-L' .. line2
end

local function yank_path(opts)
  local mode = opts.args ~= '' and opts.args or 'rel'
  local text

  if mode == 'abs' then
    text = get_abs_path()
  elseif mode == 'rel' then
    text = get_rel_path()
  elseif mode == 'file' then
    text = get_file()
  elseif mode == 'dir' then
    text = get_dir()
  elseif mode == 'link' then
    text = get_link(opts.line1, opts.line2)
  else
    vim.notify('YankPath: unknown mode: ' .. mode, vim.log.levels.WARN)
    return
  end

  if not text then
    if mode == 'link' then
      vim.notify(
        'YankPath: could not generate link (check git remote and repo)',
        vim.log.levels.WARN
      )
    else
      vim.notify('YankPath: buffer has no file path', vim.log.levels.WARN)
    end
    return
  end

  vim.fn.setreg('+', text)
  vim.fn.setreg('*', text)
  vim.notify('YankPath: copied ' .. text, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('YankPath', yank_path, {
  nargs = '?',
  range = true,
  complete = function() return { 'abs', 'rel', 'file', 'dir', 'link' } end,
  desc = 'Copy current file path to clipboard',
})

return {}
