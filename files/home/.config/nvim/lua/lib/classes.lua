---@class lib.State
---@field tabs lib.Tab[]
---@field wins lib.Win[]
---@field bufs lib.Buf[]

---@class lib.Tab
---@field id integer
---@field wins lib.Win[]
local Tab = {}

---@param id integer
---@return lib.Tab
function Tab:new(id)
	local tab = setmetatable({
		id = id,
		wins = {},
	}, self)
	self.__index = self
	return tab
end

---@param win lib.Win
function Tab:attach(win) table.insert(self.wins, win) end

---@class lib.Win
---@field id integer
---@field buf lib.Buf
---@field tab lib.Tab
---@field wintype lib.WinType
local Win = {}

---@alias lib.WinType "autocmd"|"command"|"none"|"loclist"|"popup"|"preview"|"quickfix"|"unknown"

---@param id integer
---@return lib.Win
function Win:new(id)
	local win = setmetatable({
		id = id,
		wintype = vim.fn.win_gettype(id),
	}, self)
	self.__index = self
	return win
end

---@param buf? lib.Buf
---@param tab? lib.Tab
function Win:attach(buf, tab)
	if buf then self.buf = buf end
	if tab then self.tab = tab end
end

---@class lib.Buf
---@field id integer
---@field wins lib.Win[]
---@field bufname string
---@field filetype string
---@field buftype string
---@field listed boolean
---@field loaded boolean
---@field modified boolean
---@field modifiable boolean
---@field readonly boolean
----@field status lib.BufStatus
----@field terminal lib.BufTerminal
local Buf = {}

---@alias lib.BufStatus "active"|"hidden"|"inactive"
---@alias lib.BufTerminal false|"running"|"finished"|"idle"

---@param id integer
---@return lib.Buf
function Buf:new(id)
	local buf = setmetatable({
		id = id,
		wins = {},
		bufname = vim.fn.bufname(id),
		filetype = vim.bo[id].filetype,
		buftype = vim.bo[id].buftype,
		listed = vim.bo[id].buflisted,
		loaded = vim.fn.bufloaded(id) == 1,
		modified = vim.bo[id].modified,
		modifiable = vim.bo[id].modifiable,
		readonly = vim.bo[id].readonly,
	}, self)
	self.__index = self
	return buf
end

---@param win lib.Win[]
function Buf:attach(win) table.insert(self.wins, win) end

-- TODO: should be able to query for any prop of Buf, Tab and Win
--       id should be special:
--        + can be 0 -> meaning current
--        + can be an integer -> matches only that id
--        + can be a table of integers -> matches any of those ids
-- find() -- matches any
-- find({ buf = { id = 0 } })
-- find({ tab = { id = 0 }, buf = { filetype = 'quickfix' } })
-- find({ win = { id = {1000, 1001 }}})

---@class lib.BufQuery
---@field ids?        number[]
---@field bufname?    string
---@field filetype?   string
---@field buftype?    string
---@field listed?     boolean
---@field loaded?     boolean
---@field modified?   boolean
---@field modifiable? boolean
---@field readonly?   boolean
----@field status?     lib.BufStatus
----@field terminal?   lib.BufTerminal

---@class lib.TabQuery
---@field ids? integer[]

---@class lib.WinQuery
---@field ids? integer[]
---@field wintype? lib.WinType

---@class lib.Query
---@field buf? lib.BufQuery
---@field tab? lib.TabQuery
---@field win? lib.WinQuery

return {
	Tab = Tab,
	Win = Win,
	Buf = Buf,
}
