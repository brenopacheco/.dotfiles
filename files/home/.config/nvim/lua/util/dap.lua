local dap = require('dap')
local M = {}

--- Terminate debugger if running, or start debugger if not running.
M.toggle_debug = function()
  if string.len(dap.status()) == 0 then dap.continue() end
  require('dap').terminate()
end

--- Open dap.log file
M.open_log = function()
  local path = vim.fn.stdpath('cache') .. '/dap.log'
  vim.cmd('vsp ' .. path)
end

-- dap.adapters.<name> = function(callback, config) ... callback(adapter) ... end
-- dap.configurations.<language> = {...}


dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = {os.getenv("HOME") .. "/.cache/nvim/dap/vscode-chrome-debug/out/src/chromeDebug.js"} -- TODO adjust
}

dap.configurations.javascriptreact = { -- change this to javascript if needed
    {
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}"
    }
}

dap.configurations.typescriptreact = { -- change to typescript if needed
    {
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}"
    }
}


return M
