local delimiters = [[
let g:easy_align_delimiters = {
     ',': { 'pattern': ',',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
     ';': { 'pattern': ';',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
     ']': { 'pattern': ']',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
     '[': { 'pattern': '[',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
     '(': { 'pattern': '(',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
     ')': { 'pattern': ')',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
     '-': { 'pattern': '-',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 1 },
     '/': { 'pattern': '/',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 }
    }
]]

vim.cmd(string.gsub(delimiters, '\n', ''))

-- TODO: maybe replace with something?
