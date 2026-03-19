local ok, conform = pcall(require, 'conform')
if not ok then return end

conform.setup({
  formatters_by_ft = {
    c = { 'clang-format' },
    go = { 'gofmt' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    lua = { 'stylua' },
    perl = { 'perltidy`' },
    shell = { 'shfmt' },
  },
})
