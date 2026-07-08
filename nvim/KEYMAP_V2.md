# Keymap Plan v2

## Taxonomy

Six categories. Each is a prefix key. The second key is always a single
lowercase letter (with a few natural uppercase pairs in Go).

| Prefix      | Category | Mental model                         | Frequency |
|-------------|----------|--------------------------------------|-----------|
| `g`         | Go       | "Where am I going?"                  | constant  |
| `,`         | Edit     | "What am I changing?"                | often     |
| `<Space>`   | Find     | "What am I looking for?"             | often     |
| `;`         | Open     | "What am I opening?"                 | moderate  |
| `<Enter>`   | Run      | "What am I executing?"               | per-session |
| `]` / `[`   | Cycle    | directional, not a category prefix   | often     |

Each prefix owns one clear question. Before you press the second key you
already know what *kind* of thing is about to happen.

Debug is not a prefix — it is a **mode** (like visual mode). When a debug
session is active, single keys `c`, `s`, `i`, `o`, `b`, `h`, `r` become
debug actions.  Function keys `<F5>`—`<F11>` work globally as a fallback.

---

## g — Go

Mental model: navigate to a location in code. Bare jump, no picker.

```
gd    definition          go to definition
gD    declaration         go to declaration
gr    references          go to references
gy    type definition     go to type definition
gi    implementations     go to implementations
go    outgoing calls      show outgoing calls
gI    incoming calls      show incoming calls
```

Uppercase only where a natural pair exists (gd/gD, go/gI).

### Design notes

- `gr*` defaults (grn, gra, grr, gri, grt, grx) are unmapped.
- No document symbols or workspace symbols here — those are Find via picker.

---

## , — Edit

Mental model: transform text in the buffer. Modify, restructure, clean.
These operations change what is on screen.

```
,r    rename              rename symbol (LSP)
,f    format              format buffer / selection
,c    comment             toggle comment (linewise / operator-pending)
,s    substitute          replace word under cursor in buffer
,a    code action         code actions menu (LSP)
,=    align               align region
,j    join lines          join current line with next
,z    trim                strip trailing whitespace, normalize EOF
,x    delete buffer       close buffer / unload
```

All lowercase. Mnemonics: rename, format, comment, substitute, action,
align, (trailing) z's, x (delete).

### Design notes

- The `,` prefix waits; single-key normal-mode commands (`r`, `f`, `c`,
  `s`, `a`, `=`) are not overridden — they coexist with `,r`, `,f`, etc.
- `,x` for delete buffer: `x` already means "delete" in vim (delete char).
- `,j` for join lines: J still does the same in normal mode; `,j` is the
  Edit-prefix alternative for muscle memory consistency.
- No structural line moves here — those are visual-mode mappings (see below).

---

## Visual-mode mappings

Actions that only make sense with a selection. No prefix needed.

```
J    move down           move selected lines down
K    move up             move selected lines up
```

---

## `<Space>` — Find

Mental model: search and locate things via a picker (fuzzy, grep, list).
You type a query, you pick a result.

```
<Space>f     files            fuzzy file finder (cwd)
<Space>g     git changed      
<Space>p     project-files      
<Space>b     buffers          open buffer list
<Space>r     projects         recent projects / repo roots
<Space>h     help             help tags
<Space>/     grep             live grep (prompt for pattern)
<Space>.     grep word        grep word under cursor
<Space>,     smart finder     buffer + recent + git-files
<Space>o     buffer symbols   document symbols via picker
<Space>w     workspace syms   workspace symbols via picker
<Space>?     which-key        show which-key for Space prefix
```

Lowercase. Mnemonics: files, buffers, projects, help, / (search),
. (this), , (smart), outline, workspace.

### Design notes

- `<Space>` alone is remapped to `<Nop>` (overriding `l` right-motion).
- Grep scope can be changed inside the picker (cwd / repo / buffers /
  qf / args).
- Workspace symbols are Find, not Go — you search by name, you don't jump
  directly.

---

## ; — Open

Mental model: summon a tool panel or special buffer. Toggle if already open.
When inside a tool buffer, `;` gives tool-specific operations.

```
;e    oil                file explorer (directory editor)
;g    git                fugitive status window
;t    terminal           open or focus terminal
;q    quickfix           open quickfix window
;o    outline            symbols outline sidebar
;m    messages           show :messages
;d    diagnostics        open all diagnostics in quickfix
;x    browse             open URL under cursor in browser
;p    yank path          copy file path to clipboard (visual: add line range)
;P    yank permalink     copy git remote URL to clipboard (visual: add line range)
;,    cmdline            open cmdline buffer
```

Lowercase. Mnemonics: explorer, git, terminal, quickfix, outline,
messages, diagnostics, browse, path, permalink, cmdline.

### Design notes

- `;` is remapped to `<Nop>` (overriding f/t/T repeat). Not needed.
- `;d` sends all workspace diagnostics to quickfix and opens it.
- Oil, terminal, and quickfix are buffer-local contexts — `;` gains
  contextual bindings inside them (see Quickfix below).

---

## `<Enter>` — Run

Mental model: execute an external process. Build, compile, test, shell.

```
<Enter><Enter>    last             re-run most recent command
<Enter>m          make             run :make
<Enter>c          compile          prompt for compile command
<Enter>r          recompile        re-run last compile
<Enter>x          run              fuzzy picker over run history (:Run)
<Enter>tn         test nearest     run test under cursor
<Enter>tt         test file        run all tests in current file
<Enter>tr         test re-run      re-run last test
<Enter>ts         test suite       run all suite tests
<Enter>tp         test project     run all tests
```

Lowercase. Mnemonics: make, compile, recompile, eXecute, Nearest, File,
Last, Suite.

### Design notes

- `<Enter>` is remapped to `<Nop>` (overriding `+` first-non-blank motion).
- Double-Enter for the most frequent action (usually recompile / re-run).
  First Enter enters the prefix, second Enter triggers the action.
- If no command has been run yet, `<Enter><Enter>` is a no-op or prompts.
- Test bindings depend on neotest or equivalent test runner.
- `:Run` (the existing custom module) handles shell commands and ex
  commands with history.

---

## ] / [ — Cycle

Mental model: jump between items in a list. Directional pairs.

```
]b    next buffer          [b    prev buffer
]c    next git chunk       [c    prev git chunk       (+ diff preview)
]e    next diagnostic      [e    prev diagnostic      (+ diag preview)
]q    next quickfix        [q    prev quickfix
]t    next terminal        [t    prev terminal
```

### Design notes

- `]c`/`[c` auto-opens a git diff preview on chunk navigation.
- `]e`/`[e` auto-opens a diagnostic preview.
- `]q`/`[q` are distinct from `]e`/`[e`: quickfix is a location list of
  any kind (build errors, grep results, diagnostics dump); diagnostics
  are live LSP diagnostics.

---

## Cycle additions

```
]m    next method          [m    prev method
```

Treesitter-based. Jump between function / method boundaries.

---

## Uncategorized

Bindings that don't cleanly fit the five categories. Candidates for a
6th prefix, a separate `q`-style group, or moved once the right home
becomes clear.

```
toggle option        pick & toggle a vim option via picker

qf   cfilter         Cfilter /  (quickfix buffer-local)
qv   invert          Cfilter! /  (quickfix buffer-local)
qp   colder          older quickfix list
qn   cnewer          newer quickfix list
```

### Direct keys (no prefix)

Dedicated single-key or chord bindings that don't belong to any prefix.

```
<c-k>   hover        show LSP documentation / hover info
K       keywordprg   open man / help for word under cursor
```

### Cfilter / Invert

Operate on a quickfix buffer.  Not Edit (source text unchanged), not
Open (panel is already open), not Find (no picker).  If quickfix gets
its own sub-commands group, they belong there.  The old `q` prefix
(`qf`, `qv`, `qp`, `qn`) was serviceable.

### Toggle option

Pick and toggle a vim option (`:set` wrapper).  Not Edit (editor
setting, not buffer content), not Open (not a panel).  Could live
under `;v` or remain unbound.

### Increment / decrement

Defaults: `<c-a>` (increment number), `<c-x>` (decrement number).
These transform text, so Edit is the natural home.  Options:
- `,i` increment, `,d` decrement — or keep `<c-a>` / `<c-x>` as-is
  since they are standard and don't clash with anything.
- If moved to Edit, `,d` conflicts with "delete buffer" (`;x`? `,x`?).

### Case conversion

Defaults: `gu` (lowercase), `gU` (uppercase), `g~` (toggle), `~` (toggle
char under cursor).  Under `g` by default, so they need a new home now
that `g` is Go-only.  These are text transforms — Edit candidates:
- `,l` lowercase, `,u` uppercase, `,~` toggle
- Or keep `~` as a direct normal-mode key and only remap `gu`/`gU`.

### Expand / shrink selection

Treesitter-based.  Grows or shrinks the visual selection by AST node.
Visual-mode only — does not modify the buffer.  Candidates: `+` expand,
`-` shrink in visual mode.

### Write file

Save buffer to disk.  `,w` under Edit (persisting edits).  Universal
mnemonic (Ctrl-S = save = write).

### Reload file

Reload buffer from disk, discarding unsaved changes.  `;l` under Open
(load from disk).  Avoids `,R` which breaks the all-lowercase Edit rule.

### Undo tree

Browse undo history.  `;u` under Open.  "Open... the undo tree."

### Registers / paste

View and paste from registers.  `;r` opens register picker — select —
paste.  One unified action avoids needing a separate paste binding.

---

## Debug mode (future)

DAP session attaches → debug mode active in the current buffer.
Single keys override their normal meaning:

```
c    continue            resume execution
s    step over           next line, don't enter calls
i    step into           enter function call
o    step out            return from current function
C    run to cursor       temporary breakpoint, run to it
b    toggle breakpoint   set / remove breakpoint
B    conditional bp      prompt for condition
h    hover / evaluate    show value under cursor
r    repl                toggle REPL window
q    disconnect          end debug session
```

Function keys work globally regardless of mode:
`<F5>` continue, `<F10>` step over, `<F11>` step in, `<S-F11>` step out,
`<F9>` toggle breakpoint.

All normal-mode keys (motion, Edit, Find, etc.) still work during debug
mode — only the overridden letters change meaning.

---

## Implementation notes

These global remaps are required to use the full set of prefixes:

```
vim.keymap.set('n', '<Space>', '<Nop>')       -- override l
vim.keymap.set('n', ';',      '<Nop>')        -- override f/t/T repeat
vim.keymap.set('n', '<CR>',   '<Nop>')        -- override + (first non-blank)
```

Default `gr*` mappings must be removed (grn, gra, grr, gri, grt, grx).

Timeout (`timeoutlen`) must be reasonable — around 300ms — so prefix keys
don't feel sluggish.

---

## Open questions

- **n key under Open**: old plan had `n` for nvim-tree. Current plan uses
  `;e` for oil. Do we need a tree sidebar at all?
- **Notes / zk**: old plan had `,z` for zk notes. Does that fit
  Find (`<Space>z`) or Open (`;z`)?
- **`:g` / `:v` / `:r` / `:%!`**: ex-command actions. Consensus is these
  stay on `:` without a hotkey. They are composed commands, not discrete
  actions.
- **Which-key**: every prefix could benefit from `?` (g?, `<Space>?`,
  `,?`, `;?`, `<CR>?`) for discoverability.
