# `run.lua` — Refactoring Plan

This document covers each open TODO in `run.lua`, describing the problem, the
chosen solution, and a concrete implementation plan. It is intended as a
reference for the refactoring session.

---

## TODO 1 & 2 — Custom URI scheme and `BufReadCmd` re-run

These two are addressed together because the clean solution to one solves the
other as a consequence.

### Problem

**TODO 2:** Terminal buffers are currently anonymous. They are identified
internally by `b:run_entry`, but Neovim assigns them a name of the form
`term://{cwd}//{pid}:{cmd}` automatically. There is no `run://` URI scheme,
so the buffer name carries no information about the slot or the plugin's own
metadata, and `:ls` output is indistinct from any other terminal buffer.

**TODO 1:** Because there is no `run://` URI scheme, `:e` on a run buffer
tries to open it as a file rather than re-running the command. The plugin
currently has no way to intercept that.

### Solution

Introduce a `run://` URI scheme modelled directly on Neovim's own `term://`
convention. The buffer name format is:

```
run://{cwd}//@{name}//{pid}:{cmd}
```

Examples:

```
run://~/projects/myapp//@_//12345:fd foo
run://~/projects/myapp//@scratch//12345:cargo test
```

Where:
- `{cwd}` is the tilde-shortened working directory, matching `term://`'s first
  segment.
- `//@{name}` is the slot identifier (see TODO 5). The default implicit slot
  is `@_`.
- `{pid}` is the terminal job PID, preserving exact parity with `term://`.
- `{cmd}` is the raw command string.

Register a `BufReadCmd` autocommand matching `run://*`. When Neovim fires it,
read `b:run_entry` from the buffer, and re-run the command in-place. This
means `:e` and `:e!` on a run buffer naturally re-run it — which is the
correct mental model (treat the buffer like a live document whose "source" is
the command).

### Implementation

1. **Name assignment.** After `termopen` returns, set the buffer name inside
   the `TermOpen` autocmd callback, where `terminal_job_id` is available:

   ```lua
   local pid = vim.b[bufnr].terminal_job_id
   local name = string.format(
     'run://%s//@%s//%d:%s',
     tilde_path(entry.cwd), entry.slot or '_', pid, entry.cmd
   )
   vim.api.nvim_buf_set_name(bufnr, name)
   ```

   The name is set after Neovim has already assigned the `term://` name, so
   it overwrites it. There is no visible flicker because the buffer is not
   displayed with the old name in normal use.

2. **`BufReadCmd` handler.** Register once at module load:

   ```lua
   vim.api.nvim_create_autocmd('BufReadCmd', {
     pattern = 'run://*',
     callback = function(ev)
       local entry = vim.b[ev.buf].run_entry
       if not entry then return end
       if entry.mode == 'terminal' then
         -- kill existing job if still running, then termopen again
         local job = vim.b[ev.buf].terminal_job_id
         if job then pcall(vim.fn.jobstop, job) end
         vim.fn.termopen(entry.cmd, { cwd = entry.cwd })
       else
         -- re-run capture in place
         run_capture(entry, false)
       end
     end,
   })
   ```

3. **Capture buffers** follow the same naming convention without a pid:

   ```
   capture://{cwd}//@{name}//{bufnr}:{cmd}
   ```

   The existing `capture://` scheme is kept distinct from `run://` so the two
   buffer types remain easy to distinguish in `:ls` output.

---

## TODO 3 — `:Run !!` not pushing to history

### Problem

When `:Run !!` re-runs the last command, it does not call `push_history`. The
`!!` branch reads `history[#history]` and dispatches, but the history tail is
never refreshed. This means:

- The "last executed" invariant is broken: after a picker selection
  (which *does* push), `!!` correctly replays it; but after another `!!`,
  the tail is still the original entry, not the `!!`-executed one. In
  practice, this is fine since it re-runs the same thing, but it is
  inconsistent with the picker's behavior.
- More concretely, if history is somehow mutated between two `!!` calls
  (unlikely but possible if two Neovim instances share the history file),
  `!!` could silently run a different command than the user expects.

### Solution

Call `push_history(last)` inside the `!!` branch, after dispatching. This
makes `!!` behave identically to a picker selection: both execute the command
and push it to the top of history, ensuring `history[#history]` always equals
"the last thing that ran."

### Implementation

```lua
if raw == '!!' then
  if #history == 0 then
    vim.notify('Run history is empty', vim.log.levels.WARN)
    return
  end
  local last = history[#history]
  if last.mode == 'terminal' then
    run_terminal(last, bang)
  else
    run_capture(last, bang)
  end
  push_history(last)  -- add this line
  return
end
```

Note that `push_history` deduplicates, so pushing an entry that is already at
the tail is a no-op in terms of history content — it just re-saves the file,
which is acceptable.

---

## TODO 4 — Specifying a working directory per invocation

### Problem

Every `:Run {cmd}` uses `vim.fn.getcwd(0)` as the working directory. There is
no way to run a command in a different directory without first `:cd`-ing there,
which mutates global (or window-local) state in a disruptive way.

### Solution

Extend the command grammar with an optional cwd specifier using the `@:` sigil,
which composes cleanly with named slots (TODO 5):

```
:Run [@{name}][:{cwd}] {cmd}
```

Examples:

```
:Run fd foo                          — default slot, getcwd(0)
:Run @scratch fd foo                 — named slot, getcwd(0)
:Run :~/bar fd foo                   — default slot, explicit cwd
:Run @scratch:~/bar fd foo           — named slot, explicit cwd
```

The `:` immediately following an optional `@name` (or at the very start if
there is no slot) introduces the cwd. The cwd runs up to the first space, and
everything after is the command verbatim.

This approach is unambiguous: no shell command begins with `@word` or `:path`
as its first token in a way that would clash. The `@` is already reserved for
slot names, and `:` at position zero is already used for ex commands (which are
handled separately by the `:` prefix on the *full* raw string).

Alternative approaches considered and rejected:

- **`#path` suffix:** `#` is a valid shell character (bash comment, git refs,
  CSS). Stripping it from the tail requires parsing the full command string,
  which is fragile.
- **`--cwd path` flag:** unambiguous but verbose and un-Vim-like.
- **`%path` prefix:** `%` is expanded by Neovim before the command handler
  sees the argument, making it unreliable without escaping.

### Implementation

Extend the argument parser in `run_command` to extract the optional slot and
cwd before handing the remainder to `run_terminal` or `run_capture`:

```lua
local function parse_args(raw)
  local slot, cwd, cmd

  -- Match optional @name and optional :cwd, then the rest is the command.
  -- Patterns tried in order:
  --   @name:cwd cmd
  --   @name cmd
  --   :cwd cmd
  --   cmd

  local s, c, rest
  s, c, rest = raw:match('^@(%S-):(%S+)%s+(.+)$')
  if s then slot, cwd, cmd = s, c, rest; goto done end

  s, rest = raw:match('^@(%S+)%s+(.+)$')
  if s then slot, cmd = s, rest; goto done end

  c, rest = raw:match('^:(%S+)%s+(.+)$')
  if c then cwd, cmd = c, rest; goto done end

  cmd = raw

  ::done::
  cwd = cwd and vim.fn.expand(cwd) or vim.fn.getcwd(0)
  slot = slot or '_'
  return slot, cwd, cmd
end
```

The resolved `cwd` and `slot` are stored on the `RunEntry`. History entries
already store `cwd`, so replay via `!!` or the picker automatically uses the
original directory.

---

## TODO 5 — Named slots and default buffer reuse

### Problem

Every `:Run {cmd}` opens a new terminal buffer. There is no way to reuse or
replace an existing one. In practice, the most common case is iterative
refinement: running `fd foo`, then `fd foobar` to adjust — where a new buffer
each time is noise, not signal. But there are also cases where distinct buffers
are desirable: `yarn lint` and `yarn test` running concurrently, each in its
own buffer.

The current design has no mechanism to distinguish these cases.

### Solution

Introduce named slots. Every terminal run belongs to a slot, identified by a
short name. Re-running into the same slot reuses (replaces) the existing
buffer. Different slots give independent buffers.

**Default behavior change:** `:Run {cmd}` without an explicit `@name` uses the
implicit slot `@_`. This means by default, successive `:Run` invocations
replace the previous terminal buffer — which matches the most common
interactive use case (iterative refinement). To get a distinct buffer, the
user opts in explicitly with a named slot.

```
:Run fd foo           — uses @_, opens (or reuses) one buffer
:Run fd foobar        — uses @_, replaces the previous buffer
:Run @lint yarn lint  — uses @lint, its own buffer
:Run @test yarn test  — uses @test, its own buffer
```

### Implementation

1. **Slots table.** Module-level, session-scoped (not persisted):

   ```lua
   ---@type table<string, integer>  slot name → bufnr
   local slots = {}
   ```

2. **`run_terminal` accepts a slot.** Before creating a new buffer, check
   whether the slot already has a valid buffer:

   ```lua
   local function run_terminal(entry, bang)
     local prev_win = vim.api.nvim_get_current_win()
     local slot = entry.slot or '_'
     local bufnr = slots[slot]

     local reusing = bufnr and vim.api.nvim_buf_is_valid(bufnr)

     if reusing then
       -- Kill existing job if still running.
       local job = vim.b[bufnr].terminal_job_id
       if job then pcall(vim.fn.jobstop, job) end
       -- Wipe terminal state so termopen can be called again.
       vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
     else
       bufnr = vim.api.nvim_create_buf(false, true)
       vim.bo[bufnr].buflisted = true
       vim.bo[bufnr].bufhidden = 'hide'
     end

     slots[slot] = bufnr
     vim.b[bufnr].run_entry = entry

     -- Bring the buffer into a window.
     local wins = vim.fn.win_findbuf(bufnr)
     if #wins == 0 then
       vim.cmd('bo split | b ' .. bufnr)
     else
       vim.api.nvim_set_current_win(wins[1])
     end

     vim.fn.termopen(entry.cmd, { cwd = entry.cwd })

     -- TermOpen / TermClose handling (unchanged from current code)
     -- Name assignment (see TODO 1 & 2)

     if not bang then vim.api.nvim_set_current_win(prev_win) end
   end
   ```

3. **`RunEntry` gains a `slot` field.** History entries store the slot name
   so that replay via `!!` or the picker re-uses the same slot. The
   `push_history` deduplication key for terminal entries becomes
   `(cmd, cwd, slot)` rather than `(cmd, cwd)`.

4. **Picker display** includes the slot name as a column, so the user can see
   which lane each history entry belongs to.

5. **Slot cleanup.** When a slot's buffer is wiped (`:bwipeout`), remove it
   from the slots table via a `BufWipeout` autocmd registered on the buffer
   at creation time:

   ```lua
   vim.api.nvim_create_autocmd('BufWipeout', {
     buffer = bufnr,
     once = true,
     callback = function() slots[slot] = nil end,
   })
   ```

---

## Summary — `RunEntry` schema after refactoring

```lua
---@class RunEntry
---@field cmd   string
---@field cwd   string                      -- always the resolved absolute path
---@field mode  '"terminal"' | '"ex"'
---@field slot  string                      -- slot name; '_' for the default
```

## Summary — command grammar after refactoring

```
:Run                            fuzzy picker over history
:Run !!                         re-run last executed command
:Run {cmd}                      terminal, default slot (@_), getcwd(0)
:Run @{name} {cmd}              terminal, named slot, getcwd(0)
:Run :{excmd}                   ex command, capture buffer
:Run :{cwd} {cmd}               terminal, default slot, explicit cwd
:Run @{name}:{cwd} {cmd}        terminal, named slot, explicit cwd
```

With `!` appended to `:Run` in any form, focus moves to the new buffer;
without it, focus stays in the current window.

# Concerns and considerations

## Extra 1

It would be good if, everytime we run a :Run command, if we don't specify cwd
and name, the cmdline history entry gets replaced by the "full version of the
command". For instance:
1. User runs `:Run ls` from /etc
2. cmdline history entry is swapped by `:Run @_:/etc ls` (or @default)
Is this possible? If so, it would be great to implement it.

Also, re-running a run should add an entry to the cmdline history. (IMPORTANT)

## Extra 2

Currently, there's no way to select a previous run and "edit" (throw it into
the cmdline). The `:Run` (no argument) command fuzzy picks over history and
runs it again, the same way as before. We need to figure a way to do it that
does not add too much extra complexity. Of course we can make the picker
populate the quickfix instead of re-runing the run automatically, but I do not
know if this is the best approach.

## Extra 3

We also don't have a proper way to find currently existing run buffers. It'd be
good to add it without increasing the complexity too much. A picker, maybe? Or
should we rely on existing buffer pickers?

## Extra 4

I think we need to split this plugin into two. one is for `run`, the other is
for `capture`. That way we reduce the surface area.

## Extra 5

I'm concerned about long directory names being a thing.

`:Run @_:~/.dotfiles/nvim/lua/mods fd -t f lua`

Since we are already doing this like this, wouldn't it make sense to just do

`:Run run://~/.dotfiles/nvim/lua/mods/@_/fd -t f lua` ? Though it is less
readable, it maps 1-to-1 with the buffer name.

I think we are missing mapping the use-cases we are mostly interested in.

1. I'm editing file ~/Desktop/foo/bar/baz, and want to run a command on the current directory
2. I'm editing file ~/Desktop/foo/bar/baz, and want to run a command on the root directory (git dir)
3. I'm editing file ~/Desktop/foo/bar/baz, and want to run a command on a different directory (e.g: /usr/share)
4. I've ran a command on dir zzz a few sessions ago. I want to re-run it exactly as it was.
5. I've ran a command on dir zzz a few sessions ago. I want to edit it and run it again changing the command slightly (or not) on the same directory.
6. I've ran a command on dir zzz a few sessions ago. I want to edit it and run it again changing the command slightly (or not) on the current directory I'm in.
7. I've ran a command on dir zzz a few sessions ago. I want to edit it and run it again changing the command slightly (or not) on the current root directory.
8. I've ran a command on dir zzz a few sessions ago. I want to edit it and run it again changing the command slightly (or not) on a different directory.

One important detail: in order to decluter our window space, we should leave
only 1 run window open. i.e: we do `Run ls` and leave the window open, then
`Run ls -la`, the 2nd run should replace the previous run's window.

I think we should remove the named slot thing. It adds complexity we don't
need. If we hide the previous run window, we don't really need to replace any
run buffer. We could add an optional flag on the plugin like `UNLIST_TIMEOUT`
or `BUFLISTED_TIMEOUT` (default 0 to disable) where, when set, the terminal
buffer becomes unlisted after a timeout time passes. This is optional though.
