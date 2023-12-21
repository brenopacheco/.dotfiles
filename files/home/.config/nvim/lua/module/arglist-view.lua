--- TODO: wip
local api = vim.api

-- *api-floatwin*

local ns_id = api.nvim_create_namespace("demo")

local function get_buflist()
	local buf_list = {}
	for i = 1, vim.fn.tabpagenr("$") do
		local tab_buf_list = vim.fn.tabpagebuflist(i)
		for _, buf in ipairs(tab_buf_list) do
			local buf_name = vim.fn.bufname(buf)
			if buf_name == "" then
				buf_name = "[No Name]"
			end
			if vim.fn.bufname() == buf_name then
				buf_name = "❱ " .. buf_name
			end
			table.insert(buf_list, buf_name .. " - " .. string.format("%03d", buf))
		end
	end
	return buf_list
end

local function show_list()
	local buf_list = get_buflist()

	vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

	local line_num = vim.fn.line("w0")
	local hl_group = "Title"

	for i, buf_name in ipairs(buf_list) do
		pcall(api.nvim_buf_set_extmark, 0, ns_id, line_num + i - 2, 0, {
			id = i,
			virt_text = { { buf_name, hl_group } },
			virt_text_pos = "right_align",
		})
	end
end

-- TODO: create a window for this

-- local group = vim.api.nvim_create_augroup("demo", { clear = true })

-- vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
-- 	desc = "Demonstration",
-- 	group = group,
-- 	callback = show_list,
-- })

-- vim.api.nvim_create_autocmd({ "BufLeave" }, {
-- 	desc = "Demonstration clearup",
-- 	group = group,
-- 	callback = function(ev)
--     vim.api.nvim_buf_clear_namespace(ev.buf, ns_id, 0, -1)
--   end,
-- })
