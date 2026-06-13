# Fish Shell Quick-Sheet

You come from bash. Fish is different but not hostile. Here's what matters.

## Keybindings (emacs mode)

You're in fish's default emacs mode — same keybindings you know from bash.

```
Ctrl+A        beginning of line        Ctrl+E        end of line
Ctrl+F        forward one char         Ctrl+B        backward one char
Ctrl+Right    forward one word         Ctrl+Left     backward one word
Ctrl+Delete   delete forward word      Ctrl+Backspace delete backward word
Ctrl+K        kill (cut) to end        Ctrl+U        kill from start to cursor
Ctrl+W        kill previous word       Ctrl+Y        yank (paste) last kill
Ctrl+D        delete forward char      Ctrl+H        backspace
Ctrl+P / Up   previous history         Ctrl+N / Down next history
Ctrl+R        history pager (interactive search)
Ctrl+L        clear screen
Ctrl+C        cancel / interrupt
Ctrl+D        close shell (at empty prompt)

# Edit current command in $EDITOR (like bash's v in vi mode)
Alt+E / Alt+V  open command line in vim
```

## Completions

Fish completions are richer than bash. They work out of the box for most commands.

```
Tab                 trigger completion
Ctrl+F / →          accept first suggestion (right arrow)
Alt+→               accept next word of suggestion
Ctrl+S              toggle search-as-you-type in pager
```

- Completions show descriptions, not just names
- Git branches, man pages, package names all have completions
- Tab on an empty line shows a pager with all available commands
- Type `--` then Tab to see all options for a command with descriptions

## History

```
Ctrl+R              interactive history pager
Ctrl+P / Up         previous command (prefix-aware: type first, then Up)
Ctrl+N / Down       next command
history             show full history
history search foo  search history for "foo"
```

Inside the history pager (Ctrl+R): type to filter, `Ctrl+R` cycles older matches,
`Ctrl+S` cycles newer matches, `↑`/`↓`/`Tab` to select, `Enter` to accept, `Esc` to cancel.

Fish filters history as you type — if you type `git` then press Up, you only see
git commands.

## Auto-suggestions

This is the gray text that appears after your cursor as you type. Bash doesn't
have this built-in.

```
Ctrl+F / →          accept the suggestion
Alt+→               accept one word of the suggestion
Ctrl+E              end of line (also accepts the suggestion if at end)
```

The suggestion comes from history. Just keep typing to ignore it.

## Path / directory shortcuts

```
cd -                go to previous directory (like bash)
cd ..               parent directory
prevd / nextd       browse recent directory stack
dirh                show directory history
```

Fish expands `~` like bash. `$HOME` works too.

## Variables (interactive use, not scripting)

```
set -gx VAR value           export VAR=value (global, exported)
set -g VAR value            global but not exported
set -U VAR value            universal — persists across all fish sessions
echo $VAR                   same as bash
set -e VAR                  unset a variable
```

Universal variables (`-U`) survive shell restarts. Useful for:
```
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_search_match bryellow --background=brblack
```

## What fish has that bash doesn't

| Feature                        | How                                                   |
|--------------------------------|-------------------------------------------------------|
| Syntax highlighting            | Built-in: commands green if valid, red if not found   |
| Auto-suggestions               | Grayed-out text from history, Ctrl+F to accept        |
| Tab completion with descriptions| Just press Tab, see rich completions                  |
| Web-based config              | `fish_config` opens a browser UI for colors/prompt    |
| 24-bit true color              | Works out of the box                                  |
| Abbreviations                  | Expand inline as you type (better than aliases)       |
| Universal variables            | set -U: persists across restarts and sessions         |
| Event-driven hooks             | e.g. `--on-variable PWD` fires when directory changes |

## Help / finding things

```
help                 open fish docs in browser
help command         help for a specific command (e.g. `help set`)
fish_config          open web UI for colors, prompt, functions, variables
fish_key_reader      press a key combo, see its fish bind name

# Show current bindings:
bind                 list all user bindings
bind --preset        list all preset (default) bindings

# Show all functions:
functions

# Show all abbreviations:
abbr --list
```

## Abbreviations

Fish's `abbr` is better than bash's `alias`:

```
abbr gs 'git status'     expands inline as you type: gs → git status
abbr -e gs               erase an abbreviation
```

Unlike bash aliases, abbreviations expand so you see the full command before
executing. Your config.fish has abbreviations for: v, ls, ports, pac, pr, ta,
tk, ts, gs, gp.

## Colors / Theme

The default prompt is what you wanted. If you ever want to tweak colors:
```
fish_config             → web UI (Colors tab)
fish_config theme list  → list built-in themes
fish_config theme save  → save current as custom theme
```

## Notable differences from bash (interactive use)

- `Ctrl+R` → you bound it to `history-pager`, same as bash
- `Alt+E`/`Alt+V` → open command line in `$EDITOR` (like bash vi-mode `v`)
- `Ctrl+W` → kills path component (smarter than bash's word-kill)
- `export VAR=val` → `set -gx VAR val`
- `alias foo='bar'` → `abbr --add foo bar`
- `. file` → `source file` (dot doesn't work)
- `$?` → `$status`
- No `[[ ]]` → use `test` or `[ ]`
