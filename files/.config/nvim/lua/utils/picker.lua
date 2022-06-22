-- local builtin = require('telescope.builtin')
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local themes = require('telescope.themes')
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local io = require 'utils.io'
local fs = require 'utils.fs'

local M = {}

function M.selector(prompt, entries, on_select, entry_maker)
  local theme = themes.get_dropdown({})
  pickers.new(theme, {
    prompt_title = prompt,
    finder = finders.new_table({results = entries, entry_maker = entry_maker}),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        on_select(selection)
      end)
      return true
    end
  }):find()
end

function M.projects()
  local list = vim.fn.systemlist([[ ls ~/promote/src ]])
  return M.selector('Projects', list, function(selection)
    vim.cmd('e ~/promote/src/' .. selection[1])
    -- vim.cmd([[lua require('telescope.builtin').git_files()]])
  end)
end

function M.lua()
  local list = vim.fn.systemlist([[ fd '\.lua$' ~/.config/nvim/lua ]])
  local on_select = function(selection) vim.cmd('e ' .. selection.value) end
  local entry_maker = function(entry)
    local len = string.len(vim.fn.expand('~/.config/nvim/lua')) + 2
    local name = string.sub(entry, len)
    return {value = entry, display = name, ordinal = name}
  end
  return M.selector('Projects', list, on_select, entry_maker)
end

function M.yarn_run()
  local dir, match = fs.root("^package%.json$")
  local path = dir .. '/' .. match
  io.readFile(path, function(data)
    local scripts = vim.json.decode(data).scripts
    local entries = {}
    for name, cmd in pairs(scripts) do
      table.insert(entries, {name = name, cmd = cmd})
    end
    P(entries)
    local on_select = function(selection)
      vim.cmd([[let g:floaterm_autoclose = 0]])
      local cmd = 'yarn run ' .. selection.value.name
      -- vim.cmd('bo 10sp | terminal ' .. cmd)
      vim.cmd('FloatermNew --cwd=' .. dir .. " " .. cmd)
    end

    local entry_maker = function(entry)
      local str = '[' .. entry.name .. '] ' .. entry.cmd
      return {value = entry, display = str, ordinal = str}
    end

    M.selector('Yarn run', entries, on_select, entry_maker)
  end)
end

return M
