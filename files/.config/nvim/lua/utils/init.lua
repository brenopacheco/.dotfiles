local M = {}

function M.dump(tbl, header) 
	header = header and '> '..header or '> '
	print(header .. vim.inspect(tbl))
end

function M.t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.map(keymaps)
  --print(vim.inspect(keymaps))
  for _,map in pairs(keymaps) do
     vim.cmd(M.t(map))
  end
end

-- TODO: 
-- function M.bufferize(cmd)
  -- local result = vim.fn.execute(cmd)
  -- vim.api.nvim__
-- end


return M
