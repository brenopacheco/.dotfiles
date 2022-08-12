local selector = require('util.picker').selector
local str = require('util.string')

local M = {}

function M.inputlistfd(dir, pattern, opts, callback)
  opts = opts or {
    filetype = 'f',
    noignore = false
  }
  results = make_results(dir, pattern, opts)
  entries = make_entries(results, dir)
  idx = vim.ui.select(entries, {
    prompt = 'Select file',
    format_item = function(entry)
      return make_entry(entry, vim.o.columns - 15)
    end
  }, function(entry)
    vim.cmd([[redraw!]])
    callback(entry)
  end)
end

function M.telescopefd(dir, pattern, opts, callback)
  results = make_results(dir, pattern, opts)
  entries = make_entries(results, dir)

  selector('Select file', entries, function(entry) callback(entry.value) end,
           function(entry)
    return {
      value = entry,
      display = make_entry(entry, 69),
      ordinal = make_entry(entry, 69)
    }
  end)
end

function make_results(dir, pattern, opts)
  filetype = opts.filetype
  noignore = opts.noignore
  local cmd = 'fd -p -t ' .. filetype .. (noignore and ' -HI ' or ' ') ..
                  pattern .. ' ' .. dir
  local results = vim.fn.systemlist(cmd)
  return results
end

function make_entries(paths, root)
  local entries = {}
  local stats = {
    max_path_len = 0,
    max_fname_len = 0,
    max_dir_len = 0,
    max_reldir_len = 0,
    max_relpath_len = 0
  }
  local max = function(str, num)
    len = string.len(str)
    return len > num and len or num
  end
  for _, path in ipairs(paths) do
    local entry = {
      path = path,
      fname = vim.fs.basename(path),
      dir = vim.fs.dirname(path),
      reldir = './' .. vim.fs.dirname(string.sub(path, string.len(root) + 2)),
      relpath = './' .. string.sub(path, string.len(root) + 2),
      rootdir = root
    }
    table.insert(entries, entry)
    stats.max_path_len = max(entry.path, stats.max_path_len)
    stats.max_fname_len = max(entry.fname, stats.max_fname_len)
    stats.max_dir_len = max(entry.dir, stats.max_dir_len)
    stats.max_reldir_len = max(entry.reldir, stats.max_reldir_len)
    stats.max_relpath_len = max(entry.relpath, stats.max_relpath_len)
  end
  return entries, stats
end

function make_entry(entry, max_len)
  local padding = 6
  local max_fname_len = math.floor((max_len - padding) / 2)
  local max_dir_len = max_len - max_fname_len
  local len = math.min(max_fname_len + padding, 99)
  local format = '%-' .. tostring(len) .. 's [%s]'
  local dir = str.string_truncate(entry.reldir, max_dir_len, true)
  local file = str.string_truncate(entry.fname, max_fname_len, false)
  return string.format(format, file, dir)
end

return M
