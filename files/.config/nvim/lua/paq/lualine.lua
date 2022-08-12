-- File: plugin/lualine.vim
-- Description: statusline with lsp/git integration

local dap = require('dap')

local function dap_status()
  local status = require('dap').status()
  if string.len(status) == 0 then
    return ''
  end
  return ' [' .. status .. ']'
end

dap_status()



-- TODO: fix this function
local function lsp_progress()
  local messages = vim.lsp.util.get_progress_messages()
  if #messages == 0 then return '' end
  local status = {}
  for _, msg in pairs(messages) do
    if msg.title ~= 'empty title' then
      table.insert(status, (msg.percentage or 0) .. '%% ' .. (msg.title or ''))
    end
  end
  if #status == 0 then return end
  local spinners = {
    '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'
  }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  return table.concat(status, ' | ') .. ' ' .. spinners[frame + 1]
end

local function lsp_status()
  if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return ''
  else
    return vim.bo.filetype == '' and '  noft' or ''
  end
end

local function dir()
  trim = 40
  local path = vim.fn.getcwd()
  local len = string.len(path)
  local diff = len - trim
  if diff < 0 then return path end
  local _dir = string.sub(path, diff, len)
  return string.gsub(_dir, '^[^/]+/', '…/')
end

local function foldlevel() return '[Z' .. vim.o.foldlevel .. ']' end

local gps = require('nvim-gps')

local config = {
  options = {
    theme = 'palenight',
    section_separators = '',
    component_separators = '',
    icons_enabled = true,
    globalstatus = true
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', dap_status},
    lualine_c = {
      foldlevel, 'filename', {gps.get_location, cond = gps.is_available}
    },
    lualine_x = {dir, {'diagnostics', sources = {'nvim_diagnostic'}}},
    lualine_y = {lsp_progress, lsp_status, 'filetype'},
    lualine_z = {'fileformat', 'encoding'}
  },
  extensions = {'fugitive', 'nvim-tree'}
}

require('lualine').setup(config)
