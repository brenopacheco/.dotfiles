function _G.RgFindFiles(cmdarg)
  local fnames =
    vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
  if #cmdarg == 0 then
    return fnames
  else
    return vim.fn.matchfuzzy(fnames, cmdarg)
  end
end

function _G.FdFindFiles(cmdarg)
  local cwd = vim.fn.getcwd()

  ---@type string|nil
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then git_root = nil end

  local roots = { cwd }
  if git_root and git_root ~= cwd then table.insert(roots, git_root) end

  local cmd = 'fd --type f --hidden --color=never --exclude .git . '
    .. table.concat(vim.tbl_map(vim.fn.shellescape, roots), ' ')
    .. " | awk '!seen[$0]++'"

  local fnames = vim.fn.systemlist(cmd)

  if #cmdarg == 0 then
    return fnames
  else
    return vim.fn.matchfuzzy(fnames, cmdarg)
  end
end

vim.o.findfunc = 'v:lua.RgFindFiles'
vim.o.findfunc = 'v:lua.FdFindFiles'
