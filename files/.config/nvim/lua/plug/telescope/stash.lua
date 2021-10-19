
-- -- git stash list | sed 's/:.*//' | fzf --preview 'git stash show -p {}'
-- local pickers = require "telescope.pickers" -- pickers class
-- local finders = require "telescope.finders" -- finder class
-- local previewers = require "telescope.previewers" -- finder class
-- local conf = require("telescope.config").values -- ser confs
-- local themes = require("telescope.themes")
-- local actions = require "telescope.actions"
-- local action_state = require "telescope.actions.state"

-- function get_projects()
--     local tmpfile = '/tmp/_projects';
--     if vim.fn.filereadable(tmpfile) then
--         vim.fn.writefile({'**/.cache/', '**/node_modules/', '.dotfiles'}, tmpfile)
--     else
--     end
--     local cmd = [[git stash list | sed 's/:.*//' | fzf --preview 'git stash show -p {}']]
--     return vim.fn.systemlist(cmd)
-- end

-- local stash = function()
--     local theme = themes.get_dropdown({})
--     pickers.new(theme, {
--         prompt_title = "Projects",
--         finder = finders.new_table({results = get_projects()}),
--         sorter = conf.generic_sorter({}),
--         previewer = previewers.git_stash_diff(),
--         attach_mappings = function(prompt_bufnr)
--             actions.select_default:replace(function()
--                 actions.close(prompt_bufnr)
--                 local selection = action_state.get_selected_entry()
--                 vim.cmd(':G stash apply ' .. selection)
--             end)
--             return true
--         end
--     }):find()
-- end

-- return stash
