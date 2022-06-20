local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local themes = require('telescope.themes')
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

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
  end)
end

function M.lua()
  local list = vim.fn.systemlist([[ fd '\.lua$' ~/.config/nvim/lua ]])
  return M.selector('Projects', list, function(selection)
    vim.cmd('e ' .. selection.value)
  end, function(entry)
    return {
      value = entry,
      display = vim.fs.basename(entry),
      ordinal = vim.fs.basename(entry),
    }
  end)
end

return M
