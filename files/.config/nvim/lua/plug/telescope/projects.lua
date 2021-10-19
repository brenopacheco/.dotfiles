local pickers = require "telescope.pickers" -- pickers class
local finders = require "telescope.finders" -- finder class
local conf = require("telescope.config").values -- ser confs
local themes = require("telescope.themes")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

function get_projects()
    local cmd = [[fd -t f "^(.*\.sln|package\.json)$" ~/repos | sed 's#]] .. vim.env.HOME .. [[/repos/##' | sed 's#/[^/]\+$##g']]
    return vim.fn.systemlist(cmd)
end

local projects = function()
    local theme = themes.get_dropdown({})
    pickers.new(theme, {
        prompt_title = "Projects",
        finder = finders.new_table({results = get_projects()}),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.cmd('e ' .. vim.env.HOME .. '/repos/' .. selection[1])
            end)
            return true
        end
    }):find()
end

return projects
