local function dap_status()
	local status = require("dap").status()
	if string.len(status) == 0 then
		return ""
	end
	return " [" .. status .. "]"
end

dap_status()

local function lsp_status()
	if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
		return ""
	else
		return vim.bo.filetype == "" and "  noft" or ""
	end
end

local function dir()
	trim = 40
	local path = vim.fn.getcwd()
	local len = string.len(path)
	local diff = len - trim
	if diff < 0 then
		return path
	end
	local _dir = string.sub(path, diff, len)
	return string.gsub(_dir, "^[^/]+/", "…/")
end

local function foldlevel()
	return "[Z" .. vim.o.foldlevel .. "]"
end

local function protocol()
	local path = vim.fn.expand("%")
	local start_index = string.find(path, "://") -- Find the index where "://" starts

	if start_index ~= nil then
		return " [" .. string.sub(path, 1, start_index - 1) .. "://]"
	end
	return ""
end

local config = {
	options = {
		-- theme = "palenight",
		-- theme = "nova",
		-- theme = "github_light_high_contrast",
		section_separators = "",
		component_separators = "",
		icons_enabled = true,
		globalstatus = true,
	},
	sections = {
		lualine_a = {
			"mode",
			-- icons_enabled = true,
		},
		lualine_b = {
			{
				"branch",
				icon = { "" },
			},
			{
				"diff",
				always_visible = true,
			},
			dap_status,
		},
		lualine_c = {
			protocol,
			{
				"filename",
				path = 0,
				file_status = true,
				newfile_status = true,
			},
			"navic",
		},
		lualine_x = {
			dir,
			{
				"diagnostics",
				always_visible = true,
			},
			foldlevel,
		},
		lualine_y = {
			lsp_status,
			{
				"filetype",
				colored = true,
				icon = {
					align = "right",
				},
			},
		},
		lualine_z = {
			"fileformat",
			"encoding",
		},
	},
	extensions = {
		"fugitive",
		"nvim-tree",
	},
}

require("lualine").setup(config)
