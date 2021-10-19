local M = {}

function M.dump(tbl, header)
    header = header and '> ' .. header or '> '
    print(header .. vim.inspect(tbl))
end

function M.t(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

function M.map(keymaps) for _, map in pairs(keymaps) do vim.cmd(M.t(map)) end end

function M.spawn_terminal() vim.fn.system('st >/dev/null 2>&1 & disown $!') end

function M.maximize() 
  vim.cmd([[resize +999]])
  vim.cmd([[vertical resize +999]])
end

function M.insert_line_below() vim.cmd([[norm mzo<C-[>0D`z]]) end

function M.insert_line_above() vim.cmd([[norm mzO<C-[>0D`z]]) end

function M.substitute() vim.fn['tools#buffer_substitute']() end

function M.cnext() vim.fn['quickfix#next']() end

function M.cprev() vim.fn['quickfix#prev']() end

function M.hnext() require("gitsigns").next_hunk() end

function M.hprev() require("gitsigns").prev_hunk() end

function M.lnext() vim.fn.lnext() end

function M.lprev() vim.fn.lprev() end

function M.lf() vim.cmd('Lf') end

function M.terminal() vim.fn['utils#toggle']('term', 'call term#open()') end

function M.ntree()
    vim.cmd([[
      NvimTreeToggle
      wincmd p
    ]])
end

function M.gtree() vim.cmd('GTree') end

function M.quickfix() vim.fn['utils#toggle']('qf', 'copen | wincmd p') end

function M.loclist() vim.fn['utils#toggle']('qf', 'lopen | wincmd p') end

function M.tagbar() vim.cmd('SymbolsOutline') end

function M.zen() vim.cmd('ZenMode') end

function M.fugitive() vim.fn['utils#toggle']('fugitive', 'G') end

function M.gv() vim.cmd([[tabnew | GV]]) end

function M.diff() vim.cmd([[
  " let bufnr = bufnr()
  " tabnew
  " exec bufnr . 'b'
  Gvdiffsplit
  norm! \<c-w>x
]]) end

function M.stage_hunk() require("gitsigns").stage_hunk() end

function M.undo_stage_hunk() require("gitsigns").undo_stage_hunk() end

function M.reset_hunk() require("gitsigns").reset_hunk() end

function M.preview_hunk() require("gitsigns").preview_hunk() end

function M.blame_line() vim.cmd([[GitBlameToggle]]) end
function M.blame() vim.cmd([[Gblame]]) end

function M.diagnostics()
  opts = opts or {}
  local diags = vim.lsp.diagnostic.get_all()
  local items = vim.lsp.util.diagnostics_to_items(diags, false)
  vim.lsp.util.set_qflist(items)
  M.quickfix()
end

function M.root()
  return vim.fn['utils#root']()
end

function M.home_files()
  require('telescope.builtin').find_files({
    cwd = vim.env.HOME;
    hidden = true;
  })
end

function M.live_grep()
  require('telescope.builtin').live_grep({
    cwd = M.root();
  })
end

function M.grep_string()
  require('telescope.builtin').grep_string({
    cwd = M.root();
  })
end

function M.colder()
  vim.fn['quickfix#colder']()
end

function M.cnewer()
  vim.fn['quickfix#cnewer']()
end

function M.qf_global()
  vim.fn['quickfix#filter'](vim.fn.input('> /'))
end

function M.qf_vglobal()
  print('not ready')
end

M.projects = require('plug.telescope.projects')
M.stash = require('plug.telescope.stash')

return M
