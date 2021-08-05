local M = {}

function M.dump(tbl, header) 
	header = header and '> '..header or '> '
	print(header .. vim.inspect(tbl))
end



return M
