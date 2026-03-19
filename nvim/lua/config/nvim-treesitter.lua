local ok, nvim_treesitter = pcall(require, 'nvim-treesitter')
if not ok then return end

local ts_langs = {
  'bash',
  'css',
  'go',
  'html',
  'javascript',
  'json',
  'jsx',
  'make',
  'python',
  'rust',
  'toml',
  'tsx',
  'typescript',
  'yaml',
}

nvim_treesitter.install(ts_langs)

local group =
  vim.api.nvim_create_augroup('my/tree-sitter-start', { clear = true })
vim.iter(ts_langs):each(function(lang)
  vim.treesitter.language.add(lang)
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = lang,
    callback = function(ev)
      vim.treesitter.start(ev.buf, lang)
      vim.bo[ev.buf].syntax = 'OFF' -- only if additional legacy syntax is needed
    end,
  })
end)
