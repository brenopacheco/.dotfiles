-- https://github.com/caojoshua/telescope.nvim/pull/1

local telescope = require("telescope")
local actions = require("telescope.actions")

local defaults = {}
defaults.layout_strategy = "flex"
defaults.layout_config = {
    height = 0.9,
    width = 0.8,
    horizontal = {
      preview_cutoff = 0,
      preview_width = 0.5
    },
    vertical = {
      preview_cutoff = 0,
      preview_height = 0.5
    },
    flex = {
      flip_columns = 120,
      flip_lines = 0
    }
}

defaults.mappings = {
  i = {
    ["<C-c>"] = actions.close,
    ["<ESC>"] = actions.close,
    ["jk"] = actions.close,
    ["kj"] = actions.close,
    ["<C-n>"] = actions.move_selection_next,
    ["<C-p>"] = actions.move_selection_previous,
    ["<C-f>"] = actions.preview_scrolling_up,
    ["<C-b>"] = actions.preview_scrolling_down,
    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
    ["<C-a>"] = actions.select_all,
    ["<C-d>"] = actions.drop_all,
    ["<Tab>"] = actions.add_selection + actions.move_selection_better,
    ["<S-Tab>"] = actions.remove_selection + actions.move_selection_worse,
    ["<C-s>"] = actions.select_horizontal,
    ["<C-v>"] = actions.select_vertical,
    ["<C-t>"] = actions.select_tab
  }
}

defaults.vimgrep_arguments = {
  'rg',
  '--color=never',
  '--no-heading',
  '--with-filename',
  '--line-number',
  '--column',
  '--smart-case'
}

extensions =  {
  fzy_native = {
    override_generic_sorter = false,
    override_file_sorter = true,
  }
}

telescope.setup({
  defaults = defaults;
  extensions = extensions
});

require('telescope').load_extension('fzy_native')

local M = {}

M.dotfiles = function()
  require("telescope.builtin").find_files({
    prompt_title = "< vimrc >",
    cwd = "~/.config/nvim"
  })
end

return M;
