# BUGS

- [ ] replace <leader>s
- [ ] tapping <leader><key> too quick is not registered (keyboard issue?)
- [ ] backup module is screwing up undo file? (not sure) - complains on
      which-key.lua open
- [ ] visual K in help files keeps selection
- [ ] keyword for K does not work quite alright (check ft)
      one idea is to try to hgrep the whole thing (vim.lsp.buf.de^inition)
      and if not found, try to hgrep the smaller part:
      `lsp.buf.definition, buf.definition, definition`
- [ ] grep is not scaping special chars
- [-] add special grep keymaps { b: buffer_grep, p: project_grep, ... }
- [ ] maybe create custom telescope live_grep?
- [ ] sometimes the window from argsview gets a little fuzzy
      add some logic to re-do the window if it gets fuzzy
- [x] also in argsview, resolve paths relative to root or cur dir
- [ ] re-organize `modules` as local plugins, so they can export their own
      functions besides commands. local plugins have access to a shared `lib`,
      which currently is the utils

# TODO

- [ ] make (dotnet)
- [ ] dap (dotnet, node, lua)
- [ ] bugs
- [ ] zeal/doc integration
- [ ] test conf
- [ ] org mode / agenda + notes w/ zk
- [ ] # 2.0 release
