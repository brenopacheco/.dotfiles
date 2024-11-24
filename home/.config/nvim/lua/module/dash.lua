--[[ NOTE:

The scope of this project is too wide. Perhaps instead it'd be better
to actually create a custom project that:
  - pulls the docsets
  - for each entry in the database, parse the file using an html->md tool
  - keeps placeholders
  - outputs the markdown and potentially convert md->vimdoc
  - generates a new "database" based on tags
  - *each docset would require a specific pre/post-processing*
]]
--
--
--
--- Dash docs functions
--

---@class dash.DocsetInfo
---@field name string
---@field title string
---@field url string
---@field index? string

---@class dash.Docset : dash.DocsetInfo
---@field path string
---@field type 'dash' | 'zdash'

---@class dash.QueryResult
---@field match string
---@field name string
---@field type string
---@field file string
---@field anchor? string

---@class dash.Document
---@field html string[]
---@field lynx string[]
---@field result dash.QueryResult
---@field line number

local M = {}

local cache_dir = vim.fn.stdpath('data') .. '/docsets'
local docsets_file = cache_dir .. '/docsets.json'

---TODO: write/read this to/from file cache_dir/docsets.json
---@type { [string]: dash.DocsetInfo }:nil
local cache = nil

local offsets = {
	['Go'] = 2,
	['Ruby'] = 1,
}

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
local get_docset_db = function(name)
	return cache_dir .. '/' .. name .. '/Contents/Resources/docSet.dsidx'
end

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

local function query_db(name, query)
	local db = get_docset_db(name)
	local out = vim.system({ 'sqlite3', db, query }, { text = true }):wait()
	assert(out.code == 0, out.stderr, out.stdout)
	return vim
		.iter(vim.split(out.stdout, '\n'))
		:map(function(line) return vim.trim(line) end)
		:filter(function(line) return line ~= '' end)
		:totable()
end

---@param docset dash.DocsetInfo
local function get_docset_type(docset)
	local query = "SELECT name FROM sqlite_master WHERE type = 'table' LIMIT 1"
	local result = query_db(docset.name, query)[1]
	return result == 'searchIndex' and 'dash' or 'zdash'
end

---@param docset dash.DocsetInfo
local function add_docset(docset)
	M.enabled_docsets[docset.name] = vim.tbl_extend(
		'keep',
		docset,
		{ path = get_docset_path(docset.name), type = get_docset_type(docset) }
	)
end

---@param docsets string[]
local register_docsets = function(docsets)
	local function register(docset)
		local ok, err = pcall(add_docset, docset)
		if not ok then
			vim.notify(
				'Could not register docset ' .. docset.name .. ': ' .. err,
				vim.log.levels.ERROR
			)
		end
	end
	local available_docsets = M.list_docsets()
	vim.iter(docsets):each(function(docset_name)
		local docset = available_docsets[docset_name]
		if not docset then
			vim.notify('Could not find docset ' .. docset_name, vim.log.levels.ERROR)
			return
		end
		if is_docset_installed(docset.name) then
			register(docset)
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

---@param name string
---@param pattern string
---@return dash.QueryResult[]
local function query_dash(name, pattern)
	pattern = pattern:gsub([[']], [['']])
	local query = [[
    SELECT id, name, type, path
    FROM searchIndex
    WHERE name REGEXP ']] .. pattern .. [['
    ORDER BY name
    LIMIT 100
  ]]
	local rows = query_db(name, query)
	return vim
		.iter(rows)
		:map(function(row)
			local iter = vim.iter(vim.split(row, '|'))
			local _, match, type = iter:next(), iter:next(), iter:next()
			local path = iter:join('|')
			path = path:gsub('^.*>', '')
			local file = path:gsub('#[^#]*$', '')
			local anchor = path:match('#([^#]*)$')
			assert(file, 'Could not parse path ' .. path)
			return {
				match = match,
				name = name,
				type = type,
				file = get_docset_path(name)
					.. '/Contents/Resources/Documents/'
					.. file,
				anchor = anchor,
			}
		end)
		:totable()
end

---@param name string
---@param pattern string
---@return dash.QueryResult[]
local function query_zdash(name, pattern)
	pattern = pattern:gsub([[']], [['']])
	local query = [[
    SELECT ty.ZTYPENAME, t.ZTOKENNAME, f.ZPATH, m.ZANCHOR 
    FROM ZTOKEN t, ZTOKENTYPE ty, ZFILEPATH f, ZTOKENMETAINFORMATION m
    WHERE ty.Z_PK = t.ZTOKENTYPE AND f.Z_PK = m.ZFILE AND m.ZTOKEN = t.Z_PK
      AND t.ZTOKENNAME REGEXP ']] .. pattern .. [['
    ORDER BY LENGTH(t.ZTOKENNAME), LOWER(t.ZTOKENNAME)
    LIMIT 100
  ]]
	local rows = query_db(name, query)
	return vim
		.iter(rows)
		:map(function(row)
			local type, match, file, anchor = unpack(row:split('|'))
			log(file)
			file = file:gsub('^.*>', '')
			log({
				type = type,
				match = match,
				file = file,
				anchor = anchor,
			})
			return {
				match = match,
				name = name,
				type = type,
				file = get_docset_path(name)
					.. '/Contents/Resources/Documents/'
					.. file,
				anchor = anchor,
			}
		end)
		:totable()
end

---@param results dash.QueryResult[]
---@param cb fun(choice: dash.QueryResult|nil)
local function pick_result(results, cb)
	vim.ui.select(results, {
		prompt = 'Select doc:',
		---@param item dash.QueryResult
		format_item = function(item)
			return string.format('%-14s %-60s', '(' .. item.type .. ')', item.match)
		end,
	}, function(choice) cb(choice) end)
end

---@param path string
---@param content string|string[]
local function file_write(path, content)
	if type(content) == 'string' then content = { content } end
	content = table.concat(content, '\n')
	local file = io.open(path, 'w')
	assert(file, 'Could not open file ' .. path)
	local _, err = file:write(content)
	assert(not err, 'Could not write to file ' .. path)
	file:close()
end

local function mark_html_placeholder(html, anchor)
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, html)
	local lang = vim.treesitter.language.get_lang('html')
	assert(lang ~= nil, 'treesitter html parser missing')
	local parser = vim.treesitter.get_parser(bufnr, lang)
	local query = [[
    ((element
       (start_tag
       (attribute
         (attribute_name) @attr_name
         (#eq? @attr_name "name")
         (quoted_attribute_value
         (attribute_value) @attr_value
         (#eq? @attr_value "]] .. anchor .. [[")))) @start
       (end_tag) @end))
  ]]
	local parsed_query = vim.treesitter.query.parse('html', query)
	local tree = parser:parse()[1]
	local root = tree:root()
	local first, _, last, _ = root:range()
	---@type { node_start: { row: number, col: number }|nil, node_end: { row: number, col: number }|nil }
	local capture = {}
	for _, match, _ in parsed_query:iter_matches(root, bufnr, first, last) do
		for id, node in pairs(match) do
			local name = parsed_query.captures[id]
			if name == 'start' then
				local _, _, end_row, end_col = (node):range()
				capture.node_start = { row = end_row, col = end_col }
			end
			if name == 'end' then
				local start_row, start_col, _, _ = (node):range()
				capture.node_end = { row = start_row, col = start_col }
			end
		end
	end
	assert(
		capture.node_start and capture.node_end,
		'Could not find anchor ' .. anchor
	)
	vim.api.nvim_buf_set_text(
		bufnr,
		capture.node_start.row,
		capture.node_start.col,
		capture.node_end.row,
		capture.node_end.col,
		{ 'DASH_LINE_PLACEHOLDER' }
	)
	local copy = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
	return copy
end

---@param result dash.QueryResult
---@return dash.Document
local function get_result_contents(result)
	local status, html = pcall(vim.fn.readfile, result.file)
	assert(status, html)
	if result.anchor then html = mark_html_placeholder(html, result.anchor) end
	local tmpfile = os.tmpname() .. '.html'
	file_write(tmpfile, html)
	local out = vim
		.system({ 'lynx', '-dump', '-nocolor', '-hiddenlinks=merge', tmpfile }, { text = true })
		:wait()
	local lynx = vim.split(vim.trim(out.stdout), '\n')
	assert(out.code == 0, out.stderr)
	local line = vim.iter(lynx):enumerate():find(
		function(_, line) return line:match('DASH_LINE_PLACEHOLDER') end
	) or 1
	if line then lynx[line] = lynx[line]:gsub('DASH_LINE_PLACEHOLDER', '') end
	if offsets[result.name] then line = line + offsets[result.name] end
	return { html = html, lynx = lynx, line = line, result = result }
end

---@param result dash.QueryResult
local function open_result(result)
	log(result)
	-- assert(false, 'stop')
	local content = get_result_contents(result)
	vim.cmd('vsp')
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content.lynx)
	vim.api.nvim_win_set_cursor(0, { content.line, 0 })
	vim.cmd('norm! zt')
end

M.query = function(name, pattern)
	local docset = M.enabled_docsets[name]
	assert(docset, 'Docset ' .. name .. ' is not enabled')
	local results = docset.type == 'dash' and query_dash(name, pattern)
		or query_zdash(name, pattern)
	return results
end

M.open = function(name, pattern)
	local results = M.query(name, pattern)
	if #results == 0 then
		vim.notify('No results found for ' .. pattern, vim.log.levels.WARN)
		return
	end
	if #results == 1 then
		open_result(results[1])
		return
	end
	pick_result(results, function(choice)
		if choice ~= nil then open_result(choice) end
	end)
end

---@param reset boolean
local function load_docsets(reset)
	---@type string|string[]|nil
	local file = nil
	local exists = vim.fn.filereadable(docsets_file) == 1
	if exists then
		---@type string[]
		file = vim.fn.readfile(docsets_file)
		assert(file, 'Invalid docsets file')
	end
	if not exists or reset then
		local content = M.list_docsets()
		---@type string
		file = vim.fn.json_encode(content)
		file_write(docsets_file, file)
	end
	---@type { [string]: dash.DocsetInfo }
	cache = vim.fn.json_decode(file)
end

M.docset_names = function()
	local docsets = M.list_docsets()
	local installed = vim
		.iter(docsets)
		:filter(is_docset_installed)
		:map(function(key) return key end)
		:totable()
	local uninstalled = vim
		.iter(docsets)
		:filter(function(key) return not is_docset_installed(key) end)
		:map(function(key) return key end)
		:totable()
	table.sort(installed)
	table.sort(uninstalled)
	local output = {}
	local function format(key)
		local docset = docsets[key]
		local enabled = M.enabled_docsets[key]
		return string.format(
			'\t[%s] %-35s %38s',
			enabled and 'x' or ' ',
			docset.title,
			'(' .. docset.name .. ')'
		)
	end
	local function insert(line) table.insert(output, line) end
	table.insert(output, 'Installed docsets:')
	table.insert(output, '')
	vim.iter(installed):map(format):each(insert)
	table.insert(output, '')
	table.insert(output, 'Available docsets:')
	table.insert(output, '')
	vim.iter(uninstalled):map(format):each(insert)
	local text = table.concat(output, '\n')
	vim.notify(text)
end

---@class dash.SetupOpts
---@field docsets string[]
---@field reset? boolean

---@param opts dash.SetupOpts
M.setup = function(opts)
	local reset = opts.reset or false
	load_docsets(reset)
	if vim.fn.executable('sqlite3') == 0 then
		vim.notify('sqlite3 is not installed', vim.log.levels.ERROR)
		return
	end
	register_docsets(opts.docsets)
	-- M.docset_names()
	-- M.open('C', 'stdin')
	-- M.open('Ruby', 'StringIO.set_encoding')
	-- log(M.enabled_docsets)
	M.open('Go', 'fmt.Println')
	-- log(M.open('Lua_5.4', 'io'))
	-- M.query('Vim', [['foldlevel']])
	-- M.query('NodeJS', [[^assert.AssertionError]])
end

M.setup({
	reset = false,
	docsets = {
		-- 'Vim',
		-- 'Lua_5.4',
		'Go',
		-- 'NodeJS',
		-- 'OCaml',
		-- 'Ruby',
		-- 'Rust',
		-- 'TypeScript',
		-- 'C',
	},
})

return M
