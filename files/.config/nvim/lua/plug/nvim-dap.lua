vim.g.dap_virtual_text = true

local dap = require('dap')

-- pacman -Syu lldb
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  }
}

dap.configurations.c = dap.configurations.cpp

vim.fn.sign_define('DapBreakpoint', {
    text = '●',
    texthl = '',
    linehl = '',
    numhl = ''
})

vim.cmd([[
nnoremap <leader>d  <cmd>call quickhelp#toggle("debug")<CR>
nnoremap <F1>       <cmd>lua  require"dap".step_out()<CR>
nnoremap <F2>       <cmd>lua  require"dap".step_into()<CR>
nnoremap <F3>       <cmd>lua  require"dap".step_over()<CR>
nnoremap <F4>       <cmd>call dap#play_pause()<CR>
nnoremap <F5>       <cmd>call dap#start_restart()<CR>
nnoremap <F6>       <cmd>lua  require"dap".toggle_breakpoint()<CR>
nnoremap <F7>       <cmd>lua  require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>
nnoremap <F8>       <cmd>lua  require'dap'.list_breakpoints()<CR>:copen<CR>
nnoremap <F9>       <cmd>lua  require"dap.ui.variables".scopes()<CR>
nnoremap <F10>      <cmd>lua  require"dap.ui.variables".visual_hover()<CR>
nnoremap <F10>      <cmd>lua  require"dap".repl.open()<CR>
nnoremap <F12>      <cmd>lua  require("dapui").toggle()<CR>
]])

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>", ">", "<" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      { id = "stacks", size = 0.20 },
      { id = "breakpoints", size = 0.20 },
      { id = "watches", size = 0.30 },
      { id = "scopes", size = 0.30 },
    },
    size = 50,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})
