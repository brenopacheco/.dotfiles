--- statusline.lua
---
--- A lightweight, event-driven statusline with no external dependencies.
---
--- Layout:
---
---   {filename} {flags}  ·  {diag} · {project} · {ruler}
---   └── left ──────────┘   └── right ─────────────────┘
---
--- Segments:
---
---   filename    The most meaningful path inferrable from the buffer name, normalised
---               to be relative to the buffer-local cwd (lcd) and collapsed to ~/...
---               when under the home directory. See "Filename resolution" below.
---
---   flags       Inline state markers shown immediately after the filename:
---                 [+]   buffer is modified
---                 [-]   buffer is not modifiable
---                 [RO]  buffer is read-only
---               All three are omitted when none apply.
---
---   diag        LSP diagnostic counts for the current buffer: E:{n} W:{n}
---               Counts of zero are omitted entirely; the segment disappears when
---               the buffer is clean. Hint and info severities are not shown.
---
---   project     Tail component of the git root directory (e.g. "myapp").
---               Resolves to the full directory outside a repository.
---
---   ruler       Cursor position as {line}:{col}. Rightmost element; anchored to the
---               far right for stable peripheral reading as it changes constantly.
---
--- Filename resolution:
---   A single helper normalises all buffer name variants before display:
---
---   Regular file    Relative to repo root (.git), e.g. lua/statusline.lua
---   oil://...       [oil] dir path, same normalisation
---                     e.g. [oil] lua
---   netrw           [netwr] dir path, same normalisation
---                     e.g. [netwr] lua
---   term://...      [term] cmd @ cwd-tail, extracted from term:///dir//PID:cmd
---                     e.g. [term] zsh @ nvim-modules
---   fugitive://...  [git] ref:path, extracted after the git object separator
---                     e.g. [git] HEAD:lua/statusline.lua
---   other://...     [scheme] path, same normalisation as regular files.
---                   Catches any URI not handled above: gpg://, pdf://, etc.
---                     e.g. [gpg] secrets/keys.yaml
---                     e.g. [pdf] docs/spec.pdf
---   help            [help] tail filename only, e.g. [help] oil.txt
---   quickfix        [qf] followed by the command used to populate it
---                     e.g. [qf] :grep foo **
---   unnamed         [No Name]
---
---   The bracket label signals that the buffer is not a direct edit of the file
---   on disk — either a transformed view (gpg, pdf), a virtual filesystem
---   (oil, fugitive, term), or a UI construct (help, qf).
---
--- Inactive windows:
---   All windows show the same segments. Contrast between active and inactive
---   splits is provided solely by the StatusLineNC highlight group.
---
--- Tabline:
---   When multiple tabs are open, the tabline displays each tab's active buffer
---   filename using the same resolution logic as the statusline's left segment.
---   The active tab uses the TabLineSel highlight; inactive tabs use TabLine.
---   The tabline is hidden automatically when only one tab is open
---   (showtabline=1).
---
-----------------------------------------------------------------------
-- Future work (not implemented, planned additions)                  --
------------------------------------------------------------------------

--- Planned segments:
---
---   copilot     A robot-head icon (󰚩) shown when GitHub Copilot is active for
---               the current buffer. Requires querying the copilot.lua or
---               copilot-vim status API. Hidden when Copilot is off or not
---               attached.
---
---   git-diff    Line change counts for the current buffer relative to HEAD:
---               +{added} ~{changed} -{removed}. Source from gitsigns.nvim's
---               b:gitsigns_status_dict if available. Omitted entirely on
---               buffers with no git hunks.
---
---   dap         A bug icon (󰃤) shown when nvim-dap has an active session,
---               followed by the session state: running · paused · stopped.
---               Reads from require('dap').session() and session:status().
---               Hidden when no DAP session is active.
---
---   filetype    A Nerd Font icon for the detected filetype, resolved via
---               nvim-web-devicons or mini.icons. Falls back to the raw
---               vim.bo.filetype string if no icon is available. Replaces the
---               bracket labels for regular files; bracket labels (e.g. [gpg])
---               are kept for special buffers where the icon would be misleading.
---
---   encoding    File encoding and line-ending format, e.g. "utf-8 LF".
---               Reads from vim.bo.fileencoding and vim.bo.fileformat. Omitted
---               when encoding is utf-8 and format is unix (the common case) to
---               avoid noise — shown only when the file deviates from the norm.

------------------------------------------------------------------------

local M = {}

local augroup = vim.api.nvim_create_augroup('my/statusline', { clear = true })
local EXPR = '%{%v:lua._G.statusline.render()%}'

-- Buftypes that get a reduced layout (filename only, no diag/project/ruler).
-- 'acwrite' is intentionally excluded: gpg/pdf buffers are active editing
-- targets and benefit from the full layout.
local SPECIAL_BUFTYPES =
  { terminal = true, quickfix = true, help = true, nofile = true }

------------------------------------------------------------------------
-- Highlights
------------------------------------------------------------------------

local function setup_highlights()
  vim.api.nvim_set_hl(0, 'StatusLineDiagError', { link = 'DiagnosticError' })
  vim.api.nvim_set_hl(0, 'StatusLineDiagWarn', { link = 'DiagnosticWarn' })
  vim.api.nvim_set_hl(0, 'StatusLineMuted', { link = 'Comment' })
end

------------------------------------------------------------------------
-- Filename resolution
------------------------------------------------------------------------

local function normalise_path(path)
  local root = vim.fs.root(path, '.git')
  if root and vim.startswith(path, root) then
    local rel = path:sub(#root + 2)
    return rel ~= '' and rel or vim.fn.fnamemodify(path, ':t')
  end
  return vim.fn.fnamemodify(path, ':~')
end

local function dir_hint(path)
  local root = path and vim.fs.root(path, '.git')
  if root and vim.startswith(path, root) then
    local rel = path:sub(#root + 2)
    return rel ~= '' and rel or '.'
  end
  return path and vim.fn.fnamemodify(path, ':~')
end

local bi = require('mods.bufinfo')

local function resolve_filename(bufnr)
  local info = bi.get(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)

  if info.kind == 'help' then return '[help] ' .. (info.label or '') end

  if info.kind == 'netrw' then
    return '[netwr] ' .. (info.dir and dir_hint(info.dir) or '')
  end

  if info.kind == 'quickfix' then
    local title = vim.fn.getqflist({ title = true }).title or ''
    return '[qf] ' .. title
  end

  if info.kind == 'unnamed' then return '[No Name]' end

  if info.scheme == 'oil' then
    return '[oil] ' .. (info.dir and dir_hint(info.dir) or '')
  end

  if info.scheme == 'term' then
    local cmd = name:match('//%d+:(.+)$')
    local hint = info.dir and dir_hint(info.dir)
    local s = '[term] ' .. (cmd or '')
    if hint and hint ~= '.' then s = s .. ' (' .. hint .. ')' end
    return s
  end

  if info.scheme == 'compile' then
    local cmd = name:match('//%d+:(.+)$')
    local hint = info.dir and dir_hint(info.dir)
    local s = '[compile] ' .. (cmd or '')
    if hint and hint ~= '.' then s = s .. ' (' .. hint .. ')' end
    return s
  end

  if info.kind == 'capture' then
    local cmd = name:match('//%d+:(.+)$')
    return '[capture] :' .. (cmd or '')
  end

  if info.scheme == 'fugitive' then
    local ref_path = name:match('%.git//(.+)$')
    if ref_path then return '[git] ' .. ref_path end
    return '[git] ' .. (info.dir or '')
  end

  if info.scheme then
    local p = info.path or info.dir
    return '[' .. info.scheme .. '] ' .. (p and normalise_path(p) or '')
  end

  return info.path and normalise_path(info.path) or '[No Name]'
end

------------------------------------------------------------------------
-- Segments
------------------------------------------------------------------------

local function render_flags(bufnr)
  local parts = {}
  if vim.bo[bufnr].modified then parts[#parts + 1] = '[+]' end
  if not vim.bo[bufnr].modifiable then parts[#parts + 1] = '[-]' end
  if vim.bo[bufnr].readonly then parts[#parts + 1] = '[RO]' end
  return table.concat(parts, '')
end

local function render_diag(bufnr)
  local e =
    #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
  local w =
    #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
  local parts = {}
  if e > 0 then parts[#parts + 1] = '%#StatusLineDiagError#E:' .. e .. '%*' end
  if w > 0 then parts[#parts + 1] = '%#StatusLineDiagWarn#W:' .. w .. '%*' end
  return table.concat(parts, ' ')
end

local function render_project()
  local root = vim.fs.root(vim.fn.getcwd(0), '.git')
  if not root then return '' end
  -- if not root then return vim.fn.fnamemodify(vim.fn.getcwd(0), ':~') end
  return vim.fn.fnamemodify(root, ':t')
end

------------------------------------------------------------------------
-- Render
------------------------------------------------------------------------

local SEP = ' %#StatusLineMuted#·%* '

_G.statusline = {}
_G.statusline.render = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local buftype = vim.bo[bufnr].buftype
  local fname = resolve_filename(bufnr)
  local special = SPECIAL_BUFTYPES[buftype] and true or false

  local flags = special and '' or render_flags(bufnr)
  local left = ' ' .. fname .. (flags ~= '' and ' ' .. flags or '')

  local diag = render_diag(bufnr)
  local project = render_project()
  local ruler = vim.fn.line('.') .. ':' .. vim.fn.col('.')

  local right_parts = {}
  if diag ~= '' then right_parts[#right_parts + 1] = diag end
  if project then
    right_parts[#right_parts + 1] = '%#StatusLineMuted#' .. project .. '%*'
  end
  right_parts[#right_parts + 1] = ruler

  return left .. '%=' .. table.concat(right_parts, SEP) .. ' '
end

------------------------------------------------------------------------
-- Tabline
-----------------------------------------------------------------------

_G.tabline = {}
_G.tabline.render = function()
  local parts = {}
  local curtab = vim.api.nvim_get_current_tabpage()
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local win = vim.api.nvim_tabpage_get_win(tab)
    local bufnr = vim.api.nvim_win_get_buf(win)
    local label = resolve_filename(bufnr)
    local hl = tab == curtab and '%#TabLineSel#' or '%#TabLine#'
    parts[#parts + 1] = hl .. ' ' .. label .. ' '
  end
  return table.concat(parts, '') .. '%#TabLineFill#%='
end

-----------------------------------------------------------------------
-- Setup
------------------------------------------------------------------------

local function assign(winid) vim.wo[winid].statusline = EXPR end

setup_highlights()

-- Set the global option as the foundation so any window that loses its
-- local override (via a plugin, ftplugin, or buffer transition) falls back
-- to this instead of Neovim's built-in default.
vim.o.statusline = EXPR
vim.o.tabline = '%{%v:lua._G.tabline.render()%}'

for _, winid in ipairs(vim.api.nvim_list_wins()) do
  assign(winid)
end

vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  callback = setup_highlights,
})

vim.api.nvim_create_autocmd('WinEnter', {
  group = augroup,
  callback = function() assign(vim.api.nvim_get_current_win()) end,
})

vim.api.nvim_create_autocmd({ 'TabEnter', 'BufEnter' }, {
  group = augroup,
  callback = function() vim.cmd('redrawstatus') end,
})
