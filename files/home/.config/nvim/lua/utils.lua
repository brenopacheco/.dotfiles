local M = {}

function M.argadd()
  if vim.fn.argc() > 0 then vim.cmd('silent! argdelete ' .. vim.fn.bufname()) end
  vim.cmd([[argadd]])
  print('Added "' .. vim.fn.bufname() .. '" to arglist: ' ..
            vim.inspect(vim.fn.argv()))
end

function M.argdelete()
  if vim.fn.argc() > 0 then
    vim.cmd('silent! argdelete ' .. vim.fn.bufname())
    print('Removed "' .. vim.fn.bufname() .. '" to arglist: ' ..
              vim.inspect(vim.fn.argv()))
  else
    print('Arglist is empty')
  end
end

function M.prev() vim.fn['arglist#prev']() end
function M.next() vim.fn['arglist#next']() end

function M.args() print(vim.inspect(vim.fn.argv())) end

function M.blame_line() vim.cmd([[GitBlameToggle]]) end
function M.blame() vim.cmd([[Git blame]]) end
function M.cnewer() vim.fn['quickfix#cnewer']() end
function M.cnext() vim.fn['quickfix#next']() end
function M.colder() vim.fn['quickfix#colder']() end
function M.cprev() vim.fn['quickfix#prev']() end
function M.diagnostics(buf)
  local diagnostics = vim.diagnostic.get(buf)
  local qfitems = vim.diagnostic.toqflist(diagnostics)
  vim.fn.setqflist(qfitems)
  vim.cmd('copen')
  vim.cmd('wincmd p')
end
function M.diff() vim.cmd([[Gvdiffsplit | norm! \<c-w>x]]) end
function M.dump(tbl, header)
  header = header and '> ' .. header .. ' = ' or '> '
  print(header .. vim.inspect(tbl))
end
function M.files2()
  roots = require('util.fs').roots()
  root = "."
  for _, v in ipairs(roots) do
    dir = vim.fs.dirname(v)
    if string.len(dir) > string.len(root) then
      root = dir
    end
  end
  require('telescope.builtin').find_files({cwd = root, hidden = true})
end
function M.files(monorepo)
  local is_dotgit = vim.fn.fnamemodify(vim.fn.getcwd(), ':t') == '.git'
  local is_git = vim.fn['utils#is_git']()
  if is_git then
    if monorepo then
      require('telescope.builtin').find_files({
        cwd = M.rootnpm(),
        hidden = true
      })
    else
      require('telescope.builtin').find_files({cwd = M.root(), hidden = true})
    end
  elseif is_dotgit then
    local basepath = vim.fn.fnamemodify(vim.fn.getcwd(), ':h')
    require('telescope.builtin').find_files({cwd = basepath, hidden = true})
    print(vim.inspect(vim.fn.getcwd()))
  else
    require('telescope.builtin').find_files({cwd = M.root(), hidden = true})
  end
end
function M.fugitive() vim.fn['utils#toggle']('fugitive', 'G') end
function M.grep_string()
  require('telescope.builtin').grep_string({cwd = M.root()})
end
function M.gtree() vim.cmd('GTree') end
function M.gv() vim.cmd([[tabnew | GV]]) end
function M.hnext() require('gitsigns').next_hunk() end
function M.home_files()
  require('telescope.builtin').find_files({cwd = vim.env.HOME, hidden = true})
end
function M.hprev() require('gitsigns').prev_hunk() end
function M.insert_line_above() vim.cmd([[norm mzO<C-[>0D`z]]) end
function M.insert_line_below() vim.cmd([[norm mzo<C-[>0D`z]]) end
function M.lf() vim.cmd('Lf') end
function M.live_grep() require('telescope.builtin').live_grep({cwd = M.root(), hidden = true}) end
function M.lnext() vim.fn.lnext() end
function M.loclist() vim.fn['utils#toggle']('qf', 'lopen | wincmd p') end
function M.lprev() vim.fn.lprev() end
function M.map(keymaps) for _, map in pairs(keymaps) do vim.cmd(M.t(map)) end end
function M.maximize()
  vim.cmd([[resize +999]])
  vim.cmd([[vertical resize +999]])
end
function M.ntree() vim.cmd('NTree') end
function M.get_url()
  local uri = vim.fn.getline('.')
  if string.match(vim.fn.mode(), '[vV]') then
    vim.cmd('norm! "xy')
    uri = vim.fn.getreg('')
  end
  local col = vim.fn.getpos('.')[3]
  for i, match, l in uri:gmatch('()([A-Za-z0-9_.\\-~:/?=]+)()') do
    if col >= i and col < l then
      if not string.match(match, '^https?://') and
          not string.match(match, '^www\\.') then
        match = 'https://' .. match
      end
      return match
    end
  end
end
function M.open_url() vim.cmd('!chromium ' .. M.get_url()) end
function M.preview_hunk() require('gitsigns').preview_hunk() end
function M.projects() require('util.picker').projects() end
function M.git_dirs() require('util.picker').git_dirs() end
function M.qf_global() vim.fn['quickfix#filter'](vim.fn.input('> /')) end
function M.qf_vglobal() print('not ready') end
function M.quickfix() vim.fn['utils#toggle']('qf', 'copen | wincmd p') end
function M.reload(module)
  for k, _ in pairs(package.loaded) do
    if string.match(k, module) then package.loaded[k] = nil end
    require(module)
  end
end
function M.reset_hunk() require('gitsigns').reset_hunk() end
function M.root() return vim.fn['utils#root']() end
function M.rootnpm() return vim.fn['utils#npm_root']() end
function M.spawn_terminal() vim.fn.system('st >/dev/null 2>&1 & disown $!') end
function M.stage_hunk() require('gitsigns').stage_hunk() end
function M.stash() require('plug.telescope.stash') end
function M.substitute() vim.fn['tools#buffer_substitute']() end
function M.tagbar() vim.cmd('SymbolsOutline') end
function M.terminal() vim.fn['utils#toggle']('term', 'call term#open()') end
function M.nterminal() vim.cmd([[ terminal ]]) end
function M.trim() vim.cmd([[silent! %s/\s\+$//]]) end
function M.t(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end
function M.undo_stage_hunk() require('gitsigns').undo_stage_hunk() end
function M.zen() vim.cmd('ZenMode') end

function M.cmake_build()
  local root = vim.fn['utils#root']()
  local old_dir = vim.fn.getcwd()
  vim.fn.chdir(root .. '/build')
  vim.fn.make()
  vim.fn.chdir(old_dir)
end

function M.lsp_attach(client, bufnr)
  require('keymap').register_lsp(client, bufnr)
  require('nvim-navic').attach(client, bufnr)
  vim.g.navic_silence = true
  vim.api.nvim_command('setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  client.server_capabilities.semanticTokensProvider = nil
end

function M.org_tab()
  local curlevel = vim.o.foldlevel
  vim.cmd([[norm! zr]])
  if vim.o.foldlevel == curlevel then vim.cmd([[norm! zM]]) end
end

function M.org_untab()
  local curlevel = vim.o.foldlevel
  vim.cmd([[norm! zm]])
  if vim.o.foldlevel == curlevel then vim.cmd([[norm! zR]]) end
end

function M.toggle_scrolloff()
  local scrolloff = vim.api.nvim_get_option('scrolloff') > 0 and 0 or 999
  vim.api.nvim_set_option('scrolloff', scrolloff)
  print("scrolloff: " .. scrolloff)
end

return M
