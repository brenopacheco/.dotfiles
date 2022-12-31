require('nvim-tree').setup({
  -- hijack_netrw = true,
  -- open_on_setup = false,
  -- open_on_setup_file = false,
  -- ignore_buffer_on_setup = false,
  -- ignore_ft_on_setup = {},
  -- ignore_buf_on_tab_change = {},
  -- auto_reload_on_write = true,
  -- create_in_closed_folder = false,
  -- open_on_tab = false,
  -- focus_empty_on_setup = false,
  -- sort_by = 'name',
  hijack_unnamed_buffer_when_opening = false,
  -- hijack_cursor = true,
  -- root_dirs = {},
  -- prefer_startup_root = false,
  sync_root_with_cwd = false,
  -- reload_on_bufenter = false,
  -- respect_buf_cwd = false,
  hijack_directories = {enable = false, auto_open = false},
  update_focused_file = {enable = true, update_root = false},
  -- system_open = {},
  -- diagnostics = {enable = true, debounce_delay = 300, show_on_dirs = true},
  git = {enable = true, ignore = true, show_on_dirs = true},
  -- filesystem_watchers = {enable = true, debounce_delay = 300},
  -- on_attach = function() print('attached') end,
  -- select_prompts = true,
  -- view = {
  --   adaptive_size = true,
  --   centralize_selection = false,
  --   hide_root_folder = false,
  --   side = 'right',
  --   preserve_window_proportions = true,
  --   number = true,
  --   relativenumber = true,
  --   signcolumn = 'yes',
  --   mappings = {custom_only = false, list = {}},
  --   float = {enable = false}
  -- }

  actions = {
    use_system_clipboard = true,
    change_dir = {enable = false, global = true, restrict_above_cwd = false}
  },

  view = {
    mappings = {
      list = {
        {key = {'<CR>', 'e'}, action = 'edit'}
        --     {key = '<C-e>', action = 'edit_in_place'},
        --     {key = 'O', action = 'edit_no_picker'},
        --     {key = {'<C-]>', '<2-RightMouse>'}, action = 'cd'},
        --     {key = '<C-v>', action = 'vsplit'}, {key = '<C-x>', action = 'split'},
        --     {key = '<C-t>', action = 'tabnew'},
        --     {key = '<', action = 'prev_sibling'},
        --     {key = '>', action = 'next_sibling'},
        --     {key = 'P', action = 'parent_node'},
        --     {key = '<BS>', action = 'close_node'},
        --     {key = '<Tab>', action = 'preview'},
        --     {key = 'K', action = 'first_sibling'},
        --     {key = 'J', action = 'last_sibling'},
        --     {key = 'I', action = 'toggle_git_ignored'},
        --     {key = 'H', action = 'toggle_dotfiles'},
        --     {key = 'U', action = 'toggle_custom'},
        --     {key = 'R', action = 'refresh'}, {key = 'a', action = 'create'},
        --     {key = 'd', action = 'remove'}, {key = 'D', action = 'trash'},
        --     {key = 'r', action = 'rename'},
        --     {key = '<C-r>', action = 'full_rename'}, {key = 'x', action = 'cut'},
        --     {key = 'c', action = 'copy'}, {key = 'p', action = 'paste'},
        --     {key = 'y', action = 'copy_name'}, {key = 'Y', action = 'copy_path'},
        --     {key = 'gy', action = 'copy_absolute_path'},
        --     {key = '[e', action = 'prev_diag_item'},
        --     {key = '[c', action = 'prev_git_item'},
        --     {key = ']e', action = 'next_diag_item'},
        --     {key = ']c', action = 'next_git_item'},
        --     {key = '-', action = 'dir_up'}, {key = 's', action = 'system_open'},
        --     {key = 'f', action = 'live_filter'},
        --     {key = 'F', action = 'clear_live_filter'},
        --     {key = 'q', action = 'close'}, {key = 'W', action = 'collapse_all'},
        --     {key = 'E', action = 'expand_all'},
        --     {key = 'S', action = 'search_node'},
        --     {key = '.', action = 'run_file_command'},
        --     {key = '<C-k>', action = 'toggle_file_info'},
        --     {key = 'g?', action = 'toggle_help'},
        --     {key = 'm', action = 'toggle_mark'},
        --     {key = 'bmv', action = 'bulk_move'}
      }
    }
  }
})

-- *nvim-tree.renderer*
-- UI rendering setup

--     *nvim-tree.renderer.add_trailing*
--     Appends a trailing slash to folder names.
--       Type: `boolean`, Default: `false`

--     *nvim-tree.renderer.group_empty*
--     Compact folders that only contain a single folder into one node in the file tree.
--       Type: `boolean`, Default: `false`

--     *nvim-tree.renderer.full_name*
--     Display node whose name length is wider than the width of nvim-tree window in floating window.
--       Type: `boolean`, Default: `false`

--     *nvim-tree.renderer.highlight_git*
--     Enable file highlight for git attributes using `NvimTreeGit*` highlight groups.
--     This can be used with or without the icons.
--       Type: `boolean`, Default: `false`

--     *nvim-tree.renderer.highlight_opened_files*
--     Highlight icons and/or names for opened files.
--     Value can be `"none"`, `"icon"`, `"name"` or `"all"`.
--       Type: `string`, Default: `"none"`

--     *nvim-tree.renderer.root_folder_modifier*
--     In what format to show root folder. See `:help filename-modifiers` for
--     available options.
--       Type: `string`, Default: `":~"`

--     *nvim-tree.renderer.indent_width*
--     Number of spaces for an each tree nesting level. Minimum 1.
--       Type: `number`, Default: `2`

--     *nvim-tree.renderer.indent_markers*
--     Configuration options for tree indent markers.

--         *nvim-tree.renderer.indent_markers.enable*
--         Display indent markers when folders are open
--           Type: `boolean`, Default: `false`

--         *nvim-tree.renderer.indent_markers.inline_arrows*
--         Display folder arrows in the same column as indent marker
--         when using |renderer.icons.show.folder_arrow|
--           Type: `boolean`, Default: `true`

--         *nvim-tree.renderer.indent_markers.icons*
--         Icons shown before the file/directory. Length 1.
--           Type: `table`, Default: `{ corner = "└", edge = "│", item = "│", bottom = "─", none = " ", }`

--     *nvim-tree.renderer.icons*
--     Configuration options for icons.

--         *nvim-tree.renderer.icons.webdev_colors*
--         Use the webdev icon colors, otherwise `NvimTreeFileIcon`.
--           Type: `boolean`, Default: `true`

--         *nvim-tree.renderer.icons.git_placement*
--         Place where the git icons will be rendered.
--         Can be `"after"` or `"before"` filename (after the file/folders icons)
--         or `"signcolumn"` (requires |nvim-tree.view.signcolumn| enabled).
--         Note that the diagnostic signs will take precedence over the git signs.
--           Type: `string`, Default: `before`

--         *nvim-tree.renderer.icons.padding*
--         Inserted between icon and filename.
--         Use with caution, it could break rendering if you set an empty string depending on your font.
--           Type: `string`, Default: `" "`

--         *nvim-tree.renderer.icons.symlink_arrow*
--         Used as a separator between symlinks' source and target.
--           Type: `string`, Default: `" ➛ "`

--         *nvim-tree.renderer.icons.show*
--         Configuration options for showing icon types.

--             *nvim-tree.renderer.icons.show.file*
--             Show an icon before the file name. `nvim-web-devicons` will be used if available.
--               Type: `boolean`, Default: `true`

--             *nvim-tree.renderer.icons.show.folder*
--             Show an icon before the folder name.
--               Type: `boolean`, Default: `true`

--             *nvim-tree.renderer.icons.show.folder_arrow*
--             Show a small arrow before the folder node. Arrow will be a part of the
--             node when using |renderer.indent_markers|.
--               Type: `boolean`, Default: `true`

--             *nvim-tree.renderer.icons.show.git*
--             Show a git status icon, see |renderer.icons.git_placement|
--             Requires |git.enable| `= true`
--               Type: `boolean`, Default: `true`

--         *nvim-tree.renderer.icons.glyphs*
--         Configuration options for icon glyphs.

--             *nvim-tree.renderer.icons.glyphs.default*
--             Glyph for files. Will be overridden by `nvim-web-devicons` if available.
--               Type: `string`, Default: `""`

--             *nvim-tree.renderer.icons.glyphs.symlink*
--             Glyph for symlinks to files.
--               Type: `string`, Default: `""`

--             *nvim-tree.renderer.icons.glyphs.folder*
--             Glyphs for directories.
--               Type: `table`, Default:
--                 `{`
--                   `arrow_closed = "",`
--                   `arrow_open = "",`
--                   `default = "",`
--                   `open = "",`
--                   `empty = "",`
--                   `empty_open = "",`
--                   `symlink = "",`
--                   `symlink_open = "",`
--                 `}`

--             *nvim-tree.renderer.icons.glyphs.git*
--             Glyphs for git status.
--               Type: `table`, Default:
--                 `{`
--                   `unstaged = "✗",`
--                   `staged = "✓",`
--                   `unmerged = "",`
--                   `renamed = "➜",`
--                   `untracked = "★",`
--                   `deleted = "",`
--                   `ignored = "◌",`
--                 `}`

--     *nvim-tree.renderer.special_files*
--     A list of filenames that gets highlighted with `NvimTreeSpecialFile`.
--       Type: `table`, Default: `{ "Cargo.toml", "Makefile", "README.md", "readme.md", }`

--     *nvim-tree.renderer.symlink_destination*
--     Whether to show the destination of the symlink.
--       Type: `boolean`, Default: `true`

-- *nvim-tree.filters*
-- Filtering options.

--     *nvim-tree.filters.dotfiles*
--     Do not show dotfiles: files starting with a `.`
--     Toggle via the `toggle_dotfiles` action, default mapping `H`.
--       Type: `boolean`, Default: `false`

--     *nvim-tree.filters.custom*
--     Custom list of vim regex for file/directory names that will not be shown.
--     Backslashes must be escaped e.g. "^\\.git". See |string-match|.
--     Toggle via the `toggle_custom` action, default mapping `U`.
--       Type: {string}, Default: `{}`

--     *nvim-tree.filters.exclude*
--     List of directories or files to exclude from filtering: always show them.
--     Overrides `git.ignore`, `filters.dotfiles` and `filters.custom`.
--       Type: {string}, Default: `{}`

-- *nvim-tree.trash*
-- Configuration options for trashing.

--     *nvim-tree.trash.cmd*
--     The command used to trash items (must be installed on your system).
--     The default is shipped with glib2 which is a common linux package.
--       Type: `string`, Default: `"gio trash"`

--     *nvim-tree.trash.require_confirm*
--     Show a prompt before trashing takes place.
--       Type: `boolean`, Default: `true`

-- *nvim-tree.actions*
-- Configuration for various actions.

--     *nvim-tree.actions.change_dir*
--     vim |current-directory| behaviour.

--         *nvim-tree.actions.change_dir.enable*
--         Change the working directory when changing directories in the tree.
--           Type: `boolean`, Default: `true`

--         *nvim-tree.actions.change_dir.global*
--         Use `:cd` instead of `:lcd` when changing directories.
--         Consider that this might cause issues with the |nvim-tree.sync_root_with_cwd| option.
--           Type: `boolean`, Default: `false`

--         *nvim-tree.actions.change_dir.restrict_above_cwd*
--         Restrict changing to a directory above the global current working directory.
--           Type: `boolean`, Default: `false`

--     *nvim-tree.actions.expand_all*
--     Configuration for expand_all behaviour.

--         *nvim-tree.actions.expand_all.max_folder_discovery*
--         Limit the number of folders being explored when expanding every folders.
--         Avoids hanging neovim when running this action on very large folders.
--           Type: `number`, Default: `300`

--         *nvim-tree.actions.expand_all.exclude*
--         A list of directories that should not be expanded automatically.
--         E.g `{ ".git", "target", "build" }` etc.
--           Type: `table`, Default: `{}`

--     *nvim-tree.actions.file_popup*
--     Configuration for file_popup behaviour.

--         *nvim-tree.actions.file_popup.open_win_config*
--         Floating window config for file_popup. See |nvim_open_win| for more details.
--         You shouldn't define `"width"` and `"height"` values here. They will be
--         overridden to fit the file_popup content.
--           Type: `table`, Default:
--             `{`
--               `col = 1,`
--               `row = 1,`
--               `relative = "cursor",`
--               `border = "shadow",`
--               `style = "minimal",`
--             `}`

--     *nvim-tree.actions.open_file*
--     Configuration options for opening a file from nvim-tree.

--         *nvim-tree.actions.open_file.quit_on_open*
--         Closes the explorer when opening a file.
--         It will also disable preventing a buffer overriding the tree.
--           Type: `boolean`, Default: `false`

--         *nvim-tree.actions.open_file.resize_window*  (previously `view.auto_resize`)
--         Resizes the tree when opening a file.
--           Type: `boolean`, Default: `true`

--         *nvim-tree.actions.open_file.window_picker*
--         Window picker configuration.

--             *nvim-tree.actions.open_file.window_picker.enable*
--             Enable the feature. If the feature is not enabled, files will open in window
--             from which you last opened the tree.
--               Type: `boolean`, Default: `true`

--             *nvim-tree.actions.open_file.window_picker.chars*
--             A string of chars used as identifiers by the window picker.
--               Type: `string`, Default: `"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"`

--             *nvim-tree.actions.open_file.window_picker.exclude*
--             Table of buffer option names mapped to a list of option values that indicates
--             to the picker that the buffer's window should not be selectable.
--               Type: `table`
--               Default:
--                 `{`
--                   `filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame", },`
--                   `buftype  = { "nofile", "terminal", "help", }`
--                 `}`

--     *nvim-tree.actions.remove_file.close_window*
--     Close any window displaying a file when removing the file from the tree.
--       Type: `boolean`, Default: `true`

--     *nvim-tree.actions.use_system_clipboard*
--     A boolean value that toggle the use of system clipboard when copy/paste
--     function are invoked. When enabled, copied text will be stored in registers
--     '+' (system), otherwise, it will be stored in '1' and '"'.
--       Type: `boolean`, Default: `true`

-- *nvim-tree.live_filter*
-- Configurations for the live_filtering feature.
-- The live filter allows you to filter the tree nodes dynamically, based on
-- regex matching (see |vim.regex|).
-- This feature is bound to the `f` key by default.
-- The filter can be cleared with the `F` key by default.

--     *nvim-tree.live_filter.prefix*
--     Prefix of the filter displayed in the buffer.
--       Type: `string`, Default: `"[FILTER]: "`

--     *nvim-tree.live_filter.always_show_folders*
--     Whether to filter folders or not.
--       Type: `boolean`, Default: `true`

-- *nvim-tree.log*
-- Configuration for diagnostic logging.

--     *nvim-tree.log.enable*
--     Enable logging to a file `$XDG_CACHE_HOME/nvim/nvim-tree.log`
--       Type: `boolean`, Default: `false`

--     *nvim-tree.log.truncate*
--     Remove existing log file at startup.
--       Type: `boolean`, Default: `false`

--     *nvim-tree.log.types*
--     Specify which information to log.

--         *nvim-tree.log.types.all*
--         Everything.
--           Type: `boolean`, Default: `false`

--         *nvim-tree.log.types.profile*
--         Timing of some operations.
--           Type: `boolean`, Default: `false`

--         *nvim-tree.log.types.config*
--         Options and mappings, at startup.
--           Type: `boolean`, Default: `false`

--         *nvim-tree.log.types.copy_paste*
--         File copy and paste actions.
--           Type: `boolean`, Default: `false`

--         *nvim-tree.log.types.dev*
--         Used for local development only. Not useful for users.
--           Type: `boolean`, Default: `false`

--         *nvim-tree.log.types.diagnostics*
--         LSP and COC processing, verbose.
--           Type: `boolean`, Default: `false`

--         *nvim-tree.log.types.git*
--         Git processing, verbose.
--           Type: `boolean`, Default: `false`

--         *nvim-tree.log.types.watcher*
--         |nvim-tree.filesystem_watchers| processing, verbose.
--           Type: `boolean`, Default: `false`
