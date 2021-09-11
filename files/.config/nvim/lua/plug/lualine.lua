-- File: plugin/lualine.vim
-- Description: statusline with lsp/git integration
--
-- TODO: fix this function
local function lsp_progress()
  local messages = vim.lsp.util.get_progress_messages()
  if #messages == 0 then
    return
  end
  local status = {}
  for _, msg in pairs(messages) do
    if msg.title ~= "empty title" then
      table.insert(status, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
    end
  end
  if #status == 0 then return end
  local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  return table.concat(status, " | ") .. " " .. spinners[frame + 1]
  -- return table.concat(status, " | ")
end

local function lsp_status()
  if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return ''
  else
    return vim.bo.filetype == '' and '  noft' or ''
  end
end

local gps = require("nvim-gps")

local config = {
  options = {
    theme = 'nightfly',
    section_separators = '',
    component_separators = '',
    icons_enabled = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename', { gps.get_location, condition = gps.is_available } },
    lualine_x = { lsp_progress, { 'diagnostics', sources = { 'nvim_lsp' } } },
    lualine_y = { lsp_status, 'filetype'  },
    lualine_z = { 'fileformat', 'encoding' },
  },
  extensions = { 'fugitive', 'nvim-tree' },
}

require('lualine').setup(config)
