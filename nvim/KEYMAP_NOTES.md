# Keybindings Plan

Leaders: `,` (primary)

---

## g — Action / Goto
Mental model: operate on code. Navigate, modify, inspect.

### LSP Go-to
gd    lsp_definition          go to definition
gD    lsp_declaration         go to declaration
gr    lsp_references          go to references
gy    lsp_type_definition     go to type definition
gi    lsp_implementations     go to implementations
go    lsp_outgoing_calls      show outgoing calls
gI    lsp_incoming_calls      show incoming calls

### LSP Info
gk    lsp_hover               hover / documentation
gw    lsp_document_symbols    document symbols (picker)
gO    outline                 native outline buffer
gW    lsp_workspace_symbols   workspace symbols

### LSP Actions
ge    lsp_code_action         code actions menu
gR    lsp_rename              rename symbol

### Editing
ga    align                   align region
gc    comment                 toggle comment (linewise / operator-pending)
g=    format                  format buffer/region
gs    substitute              replace word under cursor in buffer
gz    trim                    trim whitespace

### Misc
gm    make                    run :make
gM    messages                show :messages
gx    browse                  open URL under cursor
gp    yank_url                yank file permalink (visual adds line range)
gP    yank_permalink          yank remote git permalink (visual adds line range)
g/    search_grep             live grep (cwd, prompt pattern)
g.    search_grep_word        grep word under cursor (cwd)
g?    which_key               show which-key for g prefix
gb    picker_buffers          switch buffer
g,    picker_smart            smart finder (buffer + recent + git-files)
gj    toggle_option           pick & toggle a vim option
gh    picker_help             help tags
gl    picker_projects         repo roots / recent projects

---

## , — Open & Focus
Mental model: summon a panel and jump to it. Toggle if already open.

e     open_errors             open all errors in quickfix + focus
.     open_oil                open oil + focus
g     open_git                open fugitive + focus
n     open_nvim_tree          open nvim-tree + focus
o     open_outline            open symbols outline + focus
q     open_quickfix           open quickfix + focus
t     open_terminal           open/focus terminal

### Other
,,    cmdline                 open cmdline buffer + focus

---

## ] / [ — Jump Pairs
]b    jump_buffer_next        next buffer
[b    jump_buffer_prev        prev buffer
]c    jump_chunk_next         next git chunk (+ shows diff preview)
[c    jump_chunk_prev         prev git chunk (+ shows diff preview)
]e    jump_error_next         next diagnostic error (+ shows diag preview)
[e    jump_error_prev         prev diagnostic error (+ shows diag preview)
]q    jump_qf_next            next quickfix entry
[q    jump_qf_prev            prev quickfix entry
]t    jump_term_next          next terminal
[t    jump_term_prev          prev terminal

---

## q — Quickfix Filters
qf    qf_filter               Cfilter /
qv    qf_filter_invert        Cfilter! /
qp    qf_colder               older quickfix list
qn    qf_cnewer               newer quickfix list

---

## Notes

- Grep: 2 bindings — `g/` (pattern), `g.` (word under cursor). Scope
  switched inside the picker (cwd/repo/buffers/cbuffer/args/qf).

- `]c`/`[c` auto-opens the git diff preview on chunk navigation

- All g-key slots:

  ```
  ga align       gc comment      g= format       gs substitute  gz trim
  ge code_action gk hover        gw doc_symbols  gW workspace   gR rename
  gd definition  gD declaration  gr references   gy type_def    gm make
  gi impl        gI incoming     go outgoing     gO outline     gx browse
  gp yank_url    g/ grep         g. grep_word    gP permalink   g? which_key
  gb buffers     g, smart        gl projects     gh help        gj toggle_opt
  ```

## Other ideas

- align could be g\
- gw could write the buffer :w<cr>
- we need better mnemonics for rename, substitute, symbols (doc/workspace)
- ideally we don't do uppercases
- do we need inbound, outbound? I've never used it
