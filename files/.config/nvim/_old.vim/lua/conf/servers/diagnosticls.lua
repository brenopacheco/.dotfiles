-- File: servers/diagnosticls.lua
-- Author: Breno Leonhardt Pacheco
-- Email: brenoleonhardt@gmail.com
-- Last Modified: February 22, 2021
-- Description:

local linters = {}
local formatters = {}

linters.eslint = {
    command = "eslint",
    rootPatterns = { ".git" },
    debounce = 100,
    args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json" },
    sourceName = "eslint",
    parseJson = {
        errorsRoot = "[0].messages",
        line = "line",
        column = "column",
        endLine = "endLine",
        endColumn = "endColumn",
        message = "${message} [${ruleId}]",
        security = "severity"
    },
    securities = {
        ["2"] = "error",
        ["1"] = "warning"
    }
}

linters.shellcheck = {
    command = "shellcheck",
    debounce = 100,
    args = { "--format", "json", "-" },
    sourceName = "shellcheck",
    parseJson = {
        line = "line",
        column = "column",
        endLine = "endLine",
        endColumn = "endColumn",
        message = "${message} [${code}]",
        security = "level"
    },
    securities = {
        error = "error",
        warning = "warning",
        info = "info",
        style = "hint"
    }
}

linters.vint = { -- needs version: 0.4a3. pip3 install --pre vim-vint
    command = "vint",
    debounce = 100,
    args = { "--enable-neovim", "-" },
    offsetLine = 0,
    offsetColumn = 0,
    sourceName = "vint",
    formatLines = 1,
    formatPattern = { "[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$", {
        line = 1,
        column = 2,
        message = 3
    } }
}

linters.luac = {
    command = "luac",
    isStderr = true,
    debounce = 100,
    args = { "-p", "-" },
    offsetLine = 0,
    offsetColumn = 0,
    sourceName = "luac",
    formatLines = 1,
    formatPattern = { "^luac:[^:]+:(\\d+):\\s*(.*)$" , {
        line = 1,
        message = 2
    } }
}

linters.markdownlint = {
    command = "markdownlint",
    isStderr = true,
    debounce = 100,
    args = { "--stdin" },
    offsetLine = 0,
    offsetColumn = 0,
    sourceName = "markdownlint",
    formatLines = 1,
    formatPattern = { "^.*?:\\s?(\\d+)(:(\\d+)?)?\\s(MD\\d{3}\\/[A-Za-z0-9-/]+)\\s(.*)$", {
        line = 1,
        column = 3,
        message = { 4 }
    } }
}

linters.stylelint = {
    command = "./node_modules/.bin/stylelint",
    rootPatterns = { ".git" },
    debounce = 100,
    args = { "--formatter", "json", "--stdin-filename", "%filepath" },
    sourceName = "stylelint",
    parseJson = {
        errorsRoot = "[0].warnings",
        line = "line",
        column = "column",
        message = "${text}",
        security = "severity"
    },
    securities = {
        error = "error",
        warning = "warning"
    }
}

linters.standard = {
    command = "./node_modules/.bin/standard",
    isStderr = false,
    isStdout = true,
    args = { "--stdin", "--verbose" },
    rootPatterns = { ".git" },
    debounce = 100,
    offsetLine = 0,
    offsetColumn = 0,
    sourceName = "standard",
    formatLines = 1,
    formatPattern = { "^\\s*<\\w+>:(\\d+):(\\d+):\\s+(.*)(\\r|\\n)*$", {
        line = 1,
        column = 2,
        message = 3
    } }
}

linters.tidy = {
    command = "tidy",
    args = { "-e", "-q" },
    rootPatterns = { ".git/" },
    isStderr = true,
    debounce = 100,
    offsetLine = 0,
    offsetColumn = 0,
    sourceName = "tidy",
    formatLines = 1,
    formatPattern = { "^.*?(\\d+).*?(\\d+)\\s+-\\s+([^:]+):\\s+(.*)(\\r|\\n)*$", {
        line = 1,
        column = 2,
        endLine = 1,
        endColumn = 2,
        message = { 4 },
        security = 3
    } },
    securities = {
        Error = "error",
        Warning = "warning"
    }
}

linters.pylint = {
    sourceName = "pylint",
    command = "pylint",
    args = { "--output-format", "text", "--score", "no", "--msg-template", "'{line}:{column}:{category}:{msg} ({msg_id}:{symbol})'", "%file" },
    formatPattern = { "^(\\d+?):(\\d+?):([a-z]+?):(.*)$", {
        line = 1,
        column = 2,
        security = 3,
        message = 4
    } },
    rootPatterns = { ".git", "pyproject.toml", "setup.py" },
    securities = {
        informational = "hint",
        refactor = "info",
        convention = "info",
        warning = "warning",
        error = "error",
        fatal = "error"
    },
    offsetColumn = 1,
    formatLines = 1
}

linters.cpplint = {
    command = "cpplint",
    args = { "%file" },
    debounce = 100,
    isStderr = true,
    isStdout = false,
    sourceName = "cpplint",
    offsetLine = 0,
    offsetColumn = 0,
    formatPattern = { "^[^:]+:(\\d+):(\\d+)?\\s+([^:]+?)\\s\\[(\\d)\\]$", {
        line = 1,
        column = 2,
        message = 3,
        security = 4
    } },
    securities = {
        ["1"] = "info",
        ["2"] = "warning",
        ["3"] = "warning",
        ["4"] = "error",
        ["5"] = "error"
    }
}

formatters.prettier = {
 sourceName = 'prettier',
  command = 'prettier',
  args = {'--stdin', '--stdin-filepath', '%filepath'},
  rootPatterns = {
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.toml',
    '.prettierrc.json',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    '.prettierrc.json5',
    '.prettierrc.js',
    '.prettierrc.cjs',
    'prettier.config.js',
    'prettier.config.cjs',
  },
}


local M = {
    filetypes = { "javascript", "typescript", "javascriptreact",
        "typescriptreact", "c", "markdown", "python", "sh", "css",
        "html", "vim", "lua" },
    init_options = {
        filetypes = {
            javascript = "eslint",
            typescript = "eslint",
            javascriptreact = "eslint",
            typescriptreact = "eslint",
            c = "cpplint",
            markdown = "markdownlint",
            python = "pylint",
            sh = "shellcheck" ,
            css = "stylelint",
            html = "tidy",
            vim = "vint",
            lua = "luac"
        },
        linters = linters,
        -- formatters = formatters
    }
}

return M
