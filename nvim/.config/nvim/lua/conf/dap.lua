local dap = require('dap')

dap.set_log_level('trace')

vim.fn.sign_define('DapBreakpoint', {text='⬛', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='⬤', texthl='', linehl='', numhl=''})

vim.g.dap_virtual_text = true
-- vim.g.dap_virtual_text = 'all frames' --experimental

dap.adapters.python = {
    type = 'executable';
    command = 'python';
    args = { '-m', 'debugpy.adapter' };
    console = 'integratedTerminal';
}

dap.configurations.python = {
    {
        type    = 'python';
        request = 'launch';
        name    = 'Launch file';
        program = function() return vim.api.nvim_eval("expand('%:p')") end;
        args    = function () return vim.api.nvim_eval("split(input('args: ', '', 'file'), ' ')") end;
    },
}

dap.adapters.cpp = {
    type = 'executable',
    attach = {
        pidProperty = "pid",
        pidSelect = "ask"
    },
    command = 'lldb-vscode', -- my binary was called 'lldb-vscode-11'
    env = {
        LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
    },
    name = "lldb"
}
