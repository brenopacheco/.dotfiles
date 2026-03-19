--- macro-guard.lua

--- Temporarily removes `q`-prefixed keymaps during macro recording so that
--- `q<register>` is always available to start and stop recording.

local group = vim.api.nvim_create_augroup('my/macro-guard', { clear = true })

local saved_maps = {}

vim.api.nvim_create_autocmd('RecordingEnter', {
  group = group,
  desc = 'Remove q* keymaps during macro recording',
  callback = function()
    saved_maps = {}
    for _, mode in ipairs({ 'n', 'x' }) do
      local all_maps = vim.api.nvim_get_keymap(mode)
      for _, map in ipairs(vim.api.nvim_buf_get_keymap(0, mode)) do
        table.insert(all_maps, map)
      end
      for _, map in ipairs(all_maps) do
        if map.lhs:match('^q') then
          table.insert(saved_maps, map)
          vim.keymap.del(
            mode,
            map.lhs,
            { buffer = map.buffer ~= 0 and map.buffer or nil }
          )
        end
      end
    end
  end,
})

vim.api.nvim_create_autocmd('RecordingLeave', {
  group = group,
  desc = 'Restore q* keymaps after macro recording',
  callback = function()
    for _, map in ipairs(saved_maps) do
      -- Lua-defined keymaps carry a `callback`; vimscript-defined ones carry `rhs`.
      -- Prefer `callback` when present so the original function reference is preserved.
      local rhs = map.callback or map.rhs
      vim.keymap.set(map.mode or 'n', map.lhs, rhs, {
        desc = map.desc,
        expr = map.expr == 1,
        remap = map.noremap ~= 1,
        nowait = map.nowait == 1,
        script = map.script == 1,
        silent = map.silent == 1,
        buffer = map.buffer ~= 0 and map.buffer or nil,
      })
    end
    saved_maps = {}
  end,
})

return {}
