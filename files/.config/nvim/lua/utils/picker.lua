local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local themes = require('telescope.themes')
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local io = require 'utils.io'
local fs = require 'utils.fs'

local M = {}

-- override default select used by applications
function M.select(items, opts, on_choice)
  opts = opts or {}
  opts.prompt = opts.prompt or 'Select:'
  opts.format_item = opts.format_item or function(item) return item end
  local entry_maker = function(entry)
    local item = opts.format_item(entry)
    return {value = entry, display = item, ordinal = item}
  end
  pickers.new(themes.get_dropdown({}), {
    prompt_title = opts.prompt,
    finder = finders.new_table({results = items, entry_maker = entry_maker}),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        on_choice(selection)
      end)
      return true
    end
  }):find()
end

function M.projects()
  local list = vim.fn.systemlist([[ ls ~/promote/src ]])
  local on_choice = function(choice)
    vim.cmd('e ~/promote/src/' .. choice.value)
  end
  return M.select(list, {prompt = 'Projects'}, on_choice)
end

function M.lua()
  local items = vim.fn.systemlist([[ fd '\.lua$' ~/.config/nvim ]])
  local on_choice = function(selection) vim.cmd('e ' .. selection.value) end
  local pwd_len = string.len(vim.fn.expand('~/.config/nvim')) + 2
  local format = function(item) return string.sub(item, pwd_len) end
  local opts = {prompt = 'Lua configurations:', format_item = format}
  return M.select(items, opts, on_choice)
end

function M.dotfiles()
  local items = vim.fn.systemlist([[ fd . ~/.dotfiles ]])
  local on_choice = function(selection) vim.cmd('e ' .. selection.value) end
  local pwd_len = string.len(vim.fn.expand('~/.dotfiles')) + 2
  local format = function(item) return string.sub(item, pwd_len) end
  local opts = {prompt = 'Dotfiles:', format_item = format}
  return M.select(items, opts, on_choice)
end

function M.npm()
  local dir, match = fs.root('^package%.json$')
  assert(dir ~= nil, "Directory is not an npm project")
  local path = dir .. '/' .. match
  io.readFile(path, function(data)
    local scripts = vim.json.decode(data).scripts
    local items = {}
    local max_len = 0
    for name, cmd in pairs(scripts) do
      max_len = string.len(name) > max_len and string.len(name) or max_len
      table.insert(items, {name = name, cmd = cmd})
    end
    local on_choice = function(selection)
      vim.cmd([[let g:floaterm_autoclose = 0]])
      local cmd = 'npm run ' .. selection.value.name
      -- vim.cmd('bo 10sp | terminal cd ' .. dir .. '; ' .. cmd)
      vim.cmd('FloatermNew --cwd=' .. dir .. ' ' .. cmd)
    end
    local opts = {
      prompt = 'Npm run',
      format_item = function(item)
        local format = "✔ %-s %-".. tostring(max_len - string.len(item.name)) .."s   %s"
        return string.format(format, item.name, "", item.cmd)
      end
    }
    M.select(items, opts, on_choice)
  end)
end

return M
