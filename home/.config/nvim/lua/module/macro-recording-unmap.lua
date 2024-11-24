--- Removes q* keybindings during macro recording so we can exit it directly

local keymaps = {}

local group = vim.api.nvim_create_augroup('recording-unmap', { clear = true })

local toboolean = function(any)
  return any == 1
end

local function map(keymap)
  vim.keymap.set(keymap.mode, keymap.lhs, keymap.callback, {
    desc    = keymap.desc,
    expr    = toboolean(keymap.expr),
    remap   = not toboolean(keymap.noremap),
    nowait  = toboolean(keymap.nowait),
    script  = toboolean(keymap.script),
    silent  = toboolean(keymap.silent)
  })
end

local function unmap(keymap)
  vim.keymap.del(keymap.mode, keymap.lhs)
end

vim.api.nvim_create_autocmd({ 'RecordingEnter' }, {
  group = group,
  callback = vim.schedule_wrap(function()
    keymaps = vim.iter(vim.api.nvim_get_keymap("n")):filter(function(keymap) return keymap.lhs:match("^q") end):totable()
    vim.iter(keymaps):each(unmap)
  end),
})

vim.api.nvim_create_autocmd({ 'RecordingLeave' }, {
  group = group,
  callback = vim.schedule_wrap(function()
    vim.iter(keymaps):each(map)
  end),
})
