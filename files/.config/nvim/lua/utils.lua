gitsigns = require("gitsigns")
local M = {}

function M.dump(tbl, header)
    header = header and '> ' .. header or '> '
    print(header .. vim.inspect(tbl))
end

function M.t(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

function M.map(keymaps) for _, map in pairs(keymaps) do vim.cmd(M.t(map)) end end

function M.spawn_terminal() vim.fn.system('st >/dev/null 2>&1 & disown $!') end

function M.maximize() vim.cmd([[norm <c-w>_<c-w>\|]]) end

function M.insert_line_below() vim.cmd([[norm mzo<C-[>0D`z]]) end

function M.insert_line_above() vim.cmd([[norm mzO<C-[>0D`z]]) end

function M.substitute() vim.fn['tools#buffer_substitute']() end

function M.cnext() vim.fn['quickfix#next']() end

function M.cprev() vim.fn['quickfix#prev']() end

function M.hnext() gitsigns.prev_hunk() end

function M.hprev() gitsigns.next_hunk() end

function M.lnext() vim.fn.lnext() end

function M.lprev() vim.fn.lprev() end

function M.lf() vim.cmd('Lf') end

function M.terminal() vim.fn['utils#toggle']('term', 'term#open') end

function M.tree() vim.cmd('NvimTreeToggle') end

function M.quickfix() vim.fn['utils#toggle']('qf', 'copen') end

function M.loclist() vim.fn['utils#toggle']('qf', 'lopen') end

function M.tagbar() vim.cmd('SymbolsOutline') end

function M.zen() vim.cmd('ZenMode') end

function M.fugitive() vim.cmd([[]]) end

function M.gv() vim.cmd([[GV]]) end

function M.diff() vim.cmd([[Gvdiffsplit | norm <c-w>x]]) end

function M.stage_hunk() gitsigns.stage_hunk() end

function M.undo_stage_hunk() gitsigns.undo_stage_hunk() end

function M.reset_hunk() gitsigns.reset_hunk() end

function M.preview_hunk() gitsigns.preview_hunk() end

function M.toggle_blame() vim.cmd([[GitBlameToggle]]) end

function M.diagnostics()
    if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        vim.lsp.diagnostic.set_loclist()
    end
    M.quickfix()
end

return M
