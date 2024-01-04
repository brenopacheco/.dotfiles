--- Backup
--
-- Sets cache, swap, tag, undo, snippet, and template directories
-- and configures autocommands for backing up files.
--

local function setopts()
	-- stylua: ignore start
	local resolve = function (path) return vim.fn.expand("~/" .. path) end
	vim.g.backupdir     = resolve('.cache/nvim/backup/')
	vim.g.plugdir       = resolve('.cache/nvim/plug/')
	vim.g.undodir       = resolve('.cache/nvim/undo/')
	vim.g.swapdir       = resolve('.cache/nvim/swap//')
	vim.g.tagsdir       = resolve('.cache/nvim/tags')
	vim.g.snippetdir    = resolve('.config/nvim/snippet/')
	vim.g.templatedir   = resolve('.config/nvim/template/')
	vim.g.dictionarydir = resolve('.config/nvim/dict/')
	vim.opt.swapfile    = true
	vim.opt.directory   = vim.g.swapdir
	vim.opt.backup      = false
	vim.opt.writebackup = false
	vim.opt.undofile    = true
	vim.opt.undodir     = vim.g.undodir
	-- stylua: ignore end
end

local function makedirs()
	local dirs = {
		vim.g.backupdir,
		vim.g.plugdir,
		vim.g.swapdir,
		vim.g.undodir,
		vim.g.tagsdir,
	}
	for _, dir in ipairs(dirs) do
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, 'p')
		end
	end
end

local function addautocmd(debug)
	debug = debug or false
	local group = vim.api.nvim_create_augroup('backup_files', { clear = true })
	vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
		nested = true,
		desc = 'Backup file before writting',
		group = group,
		pattern = { '*' },
		callback = function(ev)
			-- check that buffer is not of type protocol:///
			if string.find(ev.match, ':///') ~= nil then
				return
			end
			local ts = os.date('%Y-%m-%d-%Hh%Mm%Ss')
			local obj = vim
				.system({ 'base64' }, { text = true, stdin = ev.match })
				:wait()
			if obj.code ~= 0 then
				vim.notify(
					'Backup: failed hashing file name ' .. ev.match .. ' - ' .. obj.stderr,
					vim.log.levels.ERROR
				)
				return
			end
			local name = string.gsub(vim.trim(obj.stdout), '\n', '')
			local fpath = vim.g.backupdir .. ts .. '_' .. name
			obj = vim.system({ 'cp', ev.match, fpath }):wait()
			if obj.code ~= 0 then
				vim.notify(
					'Backup: failed backing up file ' .. ev.match .. ' - ' .. obj.stderr,
					vim.log.levels.ERROR
				)
				return
			end
			if debug then
				vim.notify(
					'Backup: file ' .. ev.match .. ' backed up to ' .. fpath,
					vim.log.levels.INFO
				)
			end
		end,
	})
end

local function backups()
	local paths = vim.split(vim.trim(vim.fn.glob(vim.g.backupdir .. '*')), '\n')
	local entries = {}
	local choices = {}
	for _, path in ipairs(paths) do
		if path ~= '' then
			local ts =
				string.gsub(tostring(vim.fn.fnamemodify(path, ':t')), '_.*$', '')
			local backup = string.gsub(path, '^.*_', '')
			local name = vim
				---@diagnostic disable-next-line: missing-fields
				.system({ 'base64', '-d' }, { text = true, stdin = backup })
				:wait()
				.stdout
			local entry = { path = path, ts = ts, backup = backup, name = name }
			if name ~= nil then
				if entries[name] == nil then
					entries[name] = {}
					table.insert(choices, name)
				end
				table.insert(entries[name], 0, entry)
			end
		end
	end
	vim.ui.select(choices, {
		prompt = 'Backup file:',
	}, function(choice)
		backups = entries[choice]
		vim.ui.select(backups, {
			prompt = 'Backup entry:',
			format_item = function(item)
				return 'Timestamp: ' .. item.ts
			end,
		}, function(backup)
			vim.cmd('e ' .. backup.path)
		end)
	end)
end

local function addcmd()
	vim.api.nvim_create_user_command('Backups', backups, {})
end

-- setup
setopts()
makedirs()
addautocmd()
addcmd()
