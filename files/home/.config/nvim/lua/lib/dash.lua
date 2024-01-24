--- Dash docs functions
--

---@class dash.DocsetInfo
---@field name string
---@field title string
---@field url string
---@field index? string

---@class dash.Docset : dash.DocsetInfo
---@field path string

local M = {}

local cache_dir = vim.fn.stdpath('data') .. '/docsets'

---@type { [string]: dash.DocsetInfo }:nil
local cache = nil

---@type { [string]: dash.Docset }:nil
M.enabled_docsets = {}

---Returns a map of available docsets by name
---@return { [string]: dash.DocsetInfo }
M.list_docsets = function()
	if cache then return cache end
	local out = vim
		.system({ 'curl', 'https://api.zealdocs.org/v1/docsets' }, { text = true })
		:wait()
	assert(out.code == 0, out.stderr)
	local docset_list = vim.fn.json_decode(out.stdout)
	assert(docset_list, 'Could not decode json')
	---@type { [string]: dash.DocsetInfo }
	local docsets = vim
		.iter(docset_list)
		:filter(function(docset) return docset.sourceId == 'com.kapeli.dash' end)
		:map(
			function(docset)
				return {
					name = docset.name,
					title = docset.title,
					url = 'http://sanfrancisco.kapeli.com/feeds/'
						.. docset.name
						.. '.tgz',
					index = docset.extra and docset.extra.indexFilePath,
				}
			end
		)
		:fold({}, function(acc, docset)
			acc[docset.name] = docset
			return acc
		end)
	cache = docsets
	return docsets
end

local get_docset_path = function(name) return cache_dir .. '/' .. name end

---@param name string : name of the docset
local is_docset_installed = function(name)
	local contents_dir = get_docset_path(name) .. '/Contents'
	return vim.fn.isdirectory(contents_dir) == 1
end

---Downloads the docset to cache dir
---@param docset dash.DocsetInfo
---@return string path to the downloaded docset
local download_docset = function(docset)
	local docset_dir = get_docset_path(docset.name)
	local tgz_path = docset_dir .. '.tgz'
	if vim.fn.isdirectory(cache_dir) == 0 then vim.fn.mkdir(cache_dir, 'p') end
	local out = vim
		.system({ 'wget', '-O', tgz_path, docset.url }, { text = true })
		:wait()
	assert(out.code == 0, out.stderr)
	if vim.fn.isdirectory(docset_dir) == 0 then vim.fn.mkdir(docset_dir, 'p') end
	out = vim
		.system(
			{ 'tar', '-xzf', tgz_path, '-C', docset_dir, '--strip-components=1' },
			{ text = true }
		)
		:wait()
	assert(out.code == 0, out.stderr)
	return docset_dir
end

---@param info dash.DocsetInfo
local function add_docset(info)
  local docset = vim.tbl_extend('keep', info, { path = get_docset_path(info.name) })
  M.enabled_docsets[info.name] = docset
end

---@class dash.SetupOpts
---@field docsets string[]

---@param opts dash.SetupOpts
M.setup = function(opts)
	local available_docsets = M.list_docsets()
	vim.iter(opts.docsets):each(function(docset_name)
		local docset = available_docsets[docset_name]
		if not docset then
			vim.notify('Could not find docset ' .. docset_name, vim.log.levels.ERROR)
			return
		end
		if is_docset_installed(docset.name) then
      add_docset(docset)
			return
		end
		vim.notify('Downloading docset ' .. docset.name, vim.log.levels.INFO)
		local ok, err = pcall(download_docset, docset)
		if not ok then
			vim.notify(
				'Could not download docset ' .. docset.name .. ': ' .. err,
				vim.log.levels.ERROR
			)
			return
		end
    add_docset(docset)
	end)
end

M.setup({
	docsets = { 'Vim', 'Lua_5.4' },
})

return M
