local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local themes = require('telescope.themes')
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local io = require 'utils.io'
local fs = require 'utils.fs'
local uv = vim.loop

local M = {}

-- override default select used by applications
function M.select(items, opts, on_choice)
  opts = opts or {}
  opts.prompt = opts.prompt or 'Select:'
  opts.format_item = opts.format_item or function(item) return item end
  local entry_maker = function(entry)
    local item = opts.format_item(entry)
    return {value = entry, display = item, ordinal = item}
  end
  pickers.new(themes.get_dropdown({}), {
    prompt_title = opts.prompt,
    finder = finders.new_table({results = items, entry_maker = entry_maker}),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        on_choice(selection)
      end)
      return true
    end
  }):find()
end

function M.projects()
  local list = vim.fn.systemlist([[ ls ~/promote/src ]])
  local on_choice = function(choice)
    vim.cmd('e ~/promote/src/' .. choice.value)
  end
  return M.select(list, {prompt = 'Projects'}, on_choice)
end

function M.lua()
  local items = vim.fn.systemlist([[ fd '\.lua$' ~/.config/nvim ]])
  local on_choice = function(selection) vim.cmd('e ' .. selection.value) end
  local pwd_len = string.len(vim.fn.expand('~/.config/nvim')) + 2
  local format = function(item) return string.sub(item, pwd_len) end
  local opts = {prompt = 'Lua configurations:', format_item = format}
  return M.select(items, opts, on_choice)
end

function M.dotfiles()
  local items = vim.fn.systemlist([[ fd . ~/.dotfiles ]])
  local on_choice = function(selection) vim.cmd('e ' .. selection.value) end
  local pwd_len = string.len(vim.fn.expand('~/.dotfiles')) + 2
  local format = function(item) return string.sub(item, pwd_len) end
  local opts = {prompt = 'Dotfiles:', format_item = format}
  return M.select(items, opts, on_choice)
end

function M.npm()
  local dir, match = fs.root('^package%.json$')
  assert(dir ~= nil, 'Directory is not an npm project')
  local path = dir .. '/' .. match
  io.readFileAsync(path, function(data)
    local scripts = vim.json.decode(data).scripts
    local items = {}
    local max_len = 0
    for name, cmd in pairs(scripts) do
      max_len = string.len(name) > max_len and string.len(name) or max_len
      table.insert(items, {name = name, cmd = cmd})
    end
    local on_choice = function(selection)
      vim.cmd([[let g:floaterm_autoclose = 0]])
      local cmd = 'npm run ' .. selection.value.name
      -- vim.cmd('bo 10sp | terminal cd ' .. dir .. '; ' .. cmd)
      vim.cmd('FloatermNew --cwd=' .. dir .. ' ' .. cmd)
    end
    local opts = {
      prompt = 'Npm run',
      format_item = function(item)
        local format = '✔ %-s %-' ..
                           tostring(max_len - string.len(item.name)) ..
                           's   %s'
        return string.format(format, item.name, '', item.cmd)
      end
    }
    M.select(items, opts, on_choice)
  end)
end

function M.run()
  local systems = {
    node = {
      cmd = 'yarn run',
      file = 'package.json',
      parse = function(data)
        local scripts = vim.json.decode(data).scripts
        local items = {}
        local max_target_len = 0
        local max_description_len = 0
        for k, v in pairs(scripts) do
          max_target_len = string.len(k) > max_target_len and string.len(k) or
                               max_target_len
          max_description_len = string.len(v) > max_description_len and
                                    string.len(v) or max_description_len
          table.insert(items, {target = k, description = v})
        end
        return items, max_target_len, max_description_len
      end
    },
    make = {
      cmd = 'make',
      file = 'Makefile',
      parse = function(data)
        local items = {}
        local max_len = 0
        for s in string.gmatch(data, '[^\r\n]+') do
          local match = string.match(s, '^(%a+):')
          if match ~= nil then
            max_len = string.len(match) > max_len and string.len(match) or
                          max_len
            table.insert(items, {description = match, target = match})
          end
        end
        return items, max_len, max_len
      end
    },
    dotnet = {
      cmd = 'dotnet',
      file = '.+%.sln',
      parse = function(data)
        P(data)
        local items = {}
        local max_len = 0
        for s in string.gmatch(data, '[^\r\n]+') do
          local f = string.gsub(s, '\\', '/')
          local proj, path =
              string.match(f, '"([%a.]+)".*"([%a/.]+%.csproj)"')
          if proj ~= nil and path ~= nil then
            if string.match(proj, 'Test') then
              table.insert(items, {
                description = 'Run ' .. proj,
                target = 'run --project ' .. path
              })
            else
              --  TODO: add env opt
              --  modify [name] [desc] - do not show [target]
              -- VSTEST_HOST_DEBUG=1 dotnet test --filter 'Category=Integration'
              table.insert(items, {
                description = 'Unit test',
                target = 'test --filter \'Category=Unit\''
              })
              table.insert(items, {
                description = 'Integration test',
                target = 'test --filter \'Category=Integration\''
              })
            end
            max_len = string.len(items[#items].target) > max_len and string.len(items[#items].target) or max_len
          end
        end
        return items, max_len, max_len
      end
    }
  }
  local targets = {}
  local max_target_len = 0
  local max_description_len = 0
  for key, system in pairs(systems) do
    local dir, match = fs.root('^' .. system.file)
    if match ~= nil then
      local path = dir .. '/' .. match
      local fd = assert(uv.fs_open(path, 'r', 438))
      local stat = assert(uv.fs_fstat(fd))
      local data = assert(uv.fs_read(fd, stat.size, 0))
      local items, target_len, description_len = system.parse(data)
      max_target_len = target_len > max_target_len and target_len or
                           max_target_len
      max_description_len = description_len > max_description_len and
                                description_len or max_description_len
      for _, item in ipairs(items) do
        table.insert(targets, {
          target = item.target,
          description = item.description,
          dir = dir,
          cmd = system.cmd .. ' ' .. item.target,
          sysname = key
        })
      end
    end
  end

  local on_choice = function(selection)
    vim.cmd([[let g:floaterm_autoclose = 0]])
    vim.cmd('FloatermNew --cwd=' .. selection.value.dir .. ' ' ..
                selection.value.cmd)
  end

  local opts = {
    prompt = 'Run',
    format_item = function(item)
      local format = '✔ %-8s %-' .. tostring(max_target_len) + 4 .. 's %s'
      return string.format(format, '[' .. item.sysname .. ']', item.target,
                           item.description)
    end
  }
  M.select(targets, opts, on_choice)
end

return M
