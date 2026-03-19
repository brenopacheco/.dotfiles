--- foldtext.lua
---
--- Custom fold line renderer that displays:
---   +-- label ----------- {start}-{end}#
---
--- Behavior:
---   - Shows fold depth using `+--` style indicators
---   - Extracts first line of folded text as label
---   - Removes comment prefixes from both sides of the line
---   - Truncates label to fit within `textwidth`
---   - Fills remaining space with separators
---   - Displays fold range at the end
---
--- Falls back to 80 columns when `textwidth` is unset.

local function render(foldstart, foldend, foldlevel)
  local tw = vim.bo.textwidth
  if tw == 0 then tw = 80 end

  local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]
  if not line then return '' end

  -- Strip commentstring markers from both sides.
  local cs = vim.bo.commentstring
  if cs and cs ~= '' then
    local left, right = cs:match('^(.-)%%s(.-)$')
    if left and left ~= '' then
      line = line:gsub('^' .. vim.pesc(left), '', 1)
    end
    if right and right ~= '' then
      line = line:gsub(vim.pesc(right) .. '$', '', 1)
    end
  end

  line = line:gsub('^[%-%{%[%(/%s=]*', '')
  line = line:gsub('[%-%{%[%(/%s=]*$', '')
  line = vim.trim(line)

  -- Fold depth indicator (foldlevel determines dash count).
  local prefix_ui = '+' .. string.rep('-', foldlevel + 1) .. ' '

  -- Suffix.
  local suffix = string.format(' %s-%s#', foldstart, foldend)

  local dw = vim.fn.strdisplaywidth

  -- Compute available space for label.
  local max_label = tw - dw(prefix_ui) - dw(suffix) - 1
  if max_label < 0 then max_label = 0 end

  if dw(line) > max_label then
    line = vim.fn.strcharpart(line, 0, math.max(0, max_label - 3)) .. '...'
  end

  local body = prefix_ui .. line

  -- Compute fill.
  local fill_len = tw - dw(body) - dw(suffix)
  if fill_len < 1 then fill_len = 1 end

  local fill = string.rep('-', fill_len)

  return body .. fill .. suffix
end

package.loaded['foldtext'] = { render = render }
vim.opt.foldtext =
  'v:lua.require("foldtext").render(v:foldstart, v:foldend, v:foldlevel)'

return { render = render }
