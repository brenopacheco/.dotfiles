local gitsigns = require("gitsigns")
local telescope = require('telescope.builtin')

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

function M.hnext() gitsigns.next_hunk() end

function M.hprev() gitsigns.prev_hunk() end

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

function M.stage_hunk() gitsigns.stage_hunk() end

function M.undo_stage_hunk() gitsigns.undo_stage_hunk() end

function M.reset_hunk() gitsigns.reset_hunk() end

function M.preview_hunk() gitsigns.preview_hunk() end

function M.blame_line() vim.cmd([[GitBlameToggle]]) end
function M.blame() vim.cmd([[Gblame]]) end

function M.diagnostics()
    if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
      vim.lsp.diagnostic.set_qflist()
      vim.cmd([[wincmd p]])
    else
      print('> No client attached')
    end
end

function M.root()
  return vim.fn['utils#root']()
end

function M.home_files()
  telescope.find_files({
    cwd = vim.env.HOME;
    hidden = true;
  })
end

function M.live_grep()
  telescope.live_grep({
    cwd = M.root();
  })
end

function M.grep_string()
  telescope.grep_string({
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

return M
