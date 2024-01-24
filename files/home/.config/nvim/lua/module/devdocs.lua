--- Devdocs keywordprg
--

---@param tbl {args: string}
local function devdocs(tbl)
	local cmd =
		{ 'jq', '--arg', 'input', tbl.args, '-n', [[$input | @uri]] }
	local out = vim.system(cmd, { text = true }):wait()
  assert(out.code == 0, out.stderr)
  local query = vim.trim(out.stdout):sub(2, -2)
  cmd = { 'xdg-open', 'https://devdocs.io/#q=' .. query }
  vim.system(cmd)
end

vim.api.nvim_create_user_command('Devdocs', devdocs, { nargs = 1 })
