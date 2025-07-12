-- Lualine configuration

local ok, devicons = pcall(require, 'nvim-web-devicons')
if not ok then devicons = nil end

local mode = { 'mode' }

local foldlevel = {
	function() return ' ' .. vim.o.foldlevel end,
}

local branch = { 'branch', icon = { '' } }

local dap = {
	function()
		local loaded = pcall(require, 'dap')
		if not loaded then return '' end
		local status = require('dap').status()
		if string.len(status) == 0 then return '' end
		return ' [' .. status .. ']'
	end,
}

local diff = {
	'diff',
	always_visible = true,
}

local filename = {
	'filename',
	file_status = true,
	newfile_status = true,
	path = 0, -- 4
	symbols = {
		modified = ' ',
		readonly = ' ',
		unnamed = '[No Name]',
		newfile = '[New]',
	},
	fmt = function(name) return name .. ' ' end,
}

local lualine_git = require('lualine.components.branch.git_branch')
local string_utils = require('utils.strings')

local directory = {
	function()
		local win_width = vim.go.columns or vim.fn.winwidth(0)
		local branch_width = string.len(lualine_git.get_branch(vim.fn.bufnr()))
		local filename_width = string.len(vim.fn.bufname())
		local offset_width = 90
		local available_width = win_width
			- branch_width
			- filename_width
			- offset_width
		return string_utils.truncate_path(vim.fn.getcwd(), available_width)
	end,
}

local filetype = {
	function()
		local ft = vim.bo.filetype
		if not devicons then return ft end
		local icon = devicons.get_icon(ft)
		if icon == nil then return ft end
		return string.format('%s %s', icon, ft)
	end,
}

local fileformat = {
	'fileformat',
	symbols = {
		unix = '',
		dos = '',
		mac = '',
	},
}

local bomb = {
	function()
		if vim.bo.bomb then return 'BOM' end
		return ''
	end,
}

local encoding = { 'encoding' }

local lsp = {
	function()
		local clients = vim.lsp.get_clients({ bufnr = vim.fn.bufnr() })
		local names = ''
		for i, client in pairs(clients) do
			if i == 1 then
				names = client.name
			else
				names = names .. ', ' .. client.name
			end
		end
		if #names == 0 then
			return ' '
		else
			return names .. '   '
		end
	end,
}

local tabs = {
	'tabs',
	right_padding = 0,
	mode = 1,
	path = 0,
	max_length = vim.o.columns,
	symbols = {
		modified = '',
	},
	fmt = function(name)
		if string.len(name) == 0 then
			name = vim.fn.expand('%')
			name = string.gsub(tostring(name), '://.*', '')
			return name
		end
		return name
	end,
}

local diagnostics = {
	'diagnostics',
	sources = { 'nvim_lsp', 'nvim_diagnostic' },
	symbols = {
		error = ' ',
		warn = ' ',
		info = ' ',
		hint = '󰌶 ',
	},
	always_visible = true,
}

-- want

require('lualine').setup({
	options = {
		component_separators = '|',
		section_separators = '',
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { branch, dap, filename },
		lualine_c = { directory },
		lualine_x = {},
		lualine_y = { lsp, diff, diagnostics, foldlevel, filetype },
		lualine_z = { fileformat, bomb, encoding },
	},
	tabline = {
		lualine_a = { tabs },
	},
	extensions = {
		'quickfix',
		'nvim-tree',
		'man',
	},
})
