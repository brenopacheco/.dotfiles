local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local themes = require("telescope.themes")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

function get_projects()
    local cmd = [[ ls ~/promote/src ]]
    -- local cmd = [[ fd -t d -HI ".git$" ~/repos | sed 's/\/\.git$//' ]]
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
                vim.cmd('e ~/promote/src/' .. selection[1])
            end)
            return true
        end
    }):find()
end

return projects


-- local pickers = require "telescope.pickers"
-- local finders = require "telescope.finders"
-- local conf = require("telescope.config").values
-- -- our picker function: colors
-- local colors = function(opts)
--   opts = opts or {}
--   pickers.new(opts, {
--     prompt_title = "colors",
--     finder = finders.new_table {
--       results = { "red", "green", "blue" }
--     },
--     sorter = conf.generic_sorter(opts),
--   }):find()
-- end

-- colors()
