local M = {}

M.loaded = nil

--- Configure reloader.
--  Setup autocmd on BufWrite to reload the module if it is a config file.
function M.config()
  if M.loaded then
    print('reloader already setup')
    return
  end
  M.loaded = vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*.lua',
    desc = 'Reload lua modules if file is in .config/nvim/lua',
    callback = function(context)
      vim.schedule(function()
        if string.match(context.match, '%.config/nvim/lua/') then
          local module = string.gsub(context.match,
                                     '^.*%.config/nvim/lua/(.*)%.lua', '%1')
          M.reload(module)
        end
      end)
    end
  })
end

function M.reload(key)
  key = key or ''
  dkey = string.gsub(key, '/', '.')
  skey = string.gsub(key, '%.', '/')
  if (not package.loaded[dkey]) and (not package.loaded[skey]) then
    print('Package \'' .. key .. '\' loaded.')
    return require(key)
  end
  key = (package.loaded[dkey] and dkey) or (package.loaded[skey] and skey)
  package.loaded[key] = nil
  print('Package \'' .. key .. '\' reloaded')
  return require(dkey)
end

function M.modules()
  local m = {}
  for k, _ in pairs(package.loaded) do table.insert(m, k) end
  vim.pretty_print(m)
end

function M.is_loaded(module)
  print('Package \'' .. module .. '\' is ' ..
            (package.loaded[module] and '' or 'NOT ') .. 'loaded.')
end

return M
