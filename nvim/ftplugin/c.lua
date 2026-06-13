local opts = {
  equalprg = '',
  shiftwidth = 2,
  tabstop = 2,
  foldmethod = 'expr',
  foldexpr = 'v:lua.vim.treesitter.foldexpr()',
  formatoptions = 'croqlj',
  textwidth = 80,
  comments = 's1:/*,mb:*,ex:*/',
  commentstring = '// %s',
  define = '^\\s*#\\s*define',
  include = '^\\s*#\\s*include',
  suffixesadd = '~,.o,.h,.obj,.cpp',
  keywordprg = ':Man',
  path = '.,/usr/include/,**',
}

local undos = vim.iter(opts):fold({}, function(acc, name, val)
  vim.opt_local[name] = val
  table.insert(acc, name .. '<')
  return acc
end)

vim.b.undo_ftplugin = 'setl ' .. table.concat(undos, ' ')

vim.b.man_default_sects = '3,2'
