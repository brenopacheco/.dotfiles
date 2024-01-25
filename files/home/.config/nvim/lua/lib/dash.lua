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
---@field path string

---@class dash.Document
---@field html string[]
---@field lynx string[]
---@field result dash.QueryResult

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
	assert(out.code == 0, out.stderr)
	return vim
		.iter(out.stdout:split('\n'))
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
			local iter = vim.iter(row:split('|'))
			local _, match, type = iter:next(), iter:next(), iter:next()
			local path = iter:join('|')
			local file, anchor = path:gsub('^.*>', ''):match('(.*)#(.*)')
			return {
				match = match,
				name = name,
				type = type,
				file = get_docset_path(name) .. '/Contents/Resources/Documents/' .. file,
				anchor = anchor,
				path = path,
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

---@param result dash.QueryResult
---@return dash.Document
local function get_result_contents(result)
	local status, html = pcall(vim.fn.readfile, result.file)
	assert(status, html)

	---1. here we'll need to inject the placeholder DASH_LINE_PLACEHOLDER into
	---the <a> tag with id -matching result.anchor
  -- cat fmt@go1.21.html | htmlq 'a[name="//dash_ref_Println/Function/Println/0"]'


  ---
	---2. we'll need to write the modified html into a temporary file
	local tmpfile = os.tmpname()
	local file = io.open(tmpfile, 'w')
	assert(file, 'Could not open file ' .. tmpfile)
	file:write(table.concat(html, '\n'))
	file:close()

	---3. generate the text output with lynx
	local out = vim
		.system({ 'lynx', '-dump', '-hiddenlinks=merge', result.file }, { text = true })
		:wait()
	local lynx = vim.split(vim.trim(out.stdout), '\n')
	assert(out.code == 0, out.stderr)

	---4. find the current line number matching the placeholder and remove the
	---text from the lynx output
	local line = vim.iter(lynx):enumerate():find(
		function(_, line) return line:match('DASH_LINE_PLACEHOLDER') end
	) or nil
	-- if line then lynx[line] = lynx[line]:gsub('DASH_LINE_PLACEHOLDER', '') end
	return { html = html, lynx = lynx, line = line, result = result }
end

---@param result dash.QueryResult
local function open_result(result)
	local content = get_result_contents(result)
	vim.cmd('vsp')
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content.lynx)
end

M.query = function(name, pattern)
	local docset = M.enabled_docsets[name]
	assert(docset, 'Docset ' .. name .. ' is not enabled')
	if docset.type == 'dash' then
		local results = query_dash(name, pattern)
		if #results == 0 then
			vim.notify('No results found for ' .. pattern, vim.log.levels.WARN)
			return
		end
		log(results)
    -- log(get_result_contents(results[1]))
		if #results == 1 then
			open_result(results[1])
			return
		end
		-- pick_result(results, function(choice)
		-- 	if choice ~= nil then open_result(choice) end
		-- end)
	else
		vim.notify('zdash not implemented yet', vim.log.levels.ERROR)
	end
end

---@class dash.SetupOpts
---@field docsets string[]

---@param opts dash.SetupOpts
M.setup = function(opts)
	if vim.fn.executable('sqlite3') == 0 then
		vim.notify('sqlite3 is not installed', vim.log.levels.ERROR)
		return
	end
	register_docsets(opts.docsets)
	-- log(M.list_docsets())
	-- log(M.enabled_docsets)
	M.query('Go', 'fmt.Println')
	-- M.query('Vim', [['foldlevel']])
	-- M.query('NodeJS', [[^assert.AssertionError]])
end

M.setup({
	docsets = { 'Vim', 'Lua_5.4', 'Go', 'NodeJS', 'OCaml' },
})

return M
