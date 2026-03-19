# Unified Grep UX

A single-entrypoint grep interface driven by a structured query string. Instead of
separate keybindings for every combination of scope, pattern, and flags, all intent
is expressed inline in one prompt.

---

## Query grammar

```
[scope] [query] [-- flags]
```

All three parts are optional. A bare query with no scope defaults to git root. Flags
are passed directly to the underlying search tool (ripgrep).

---

## Entrypoints

Two keybindings, one for each _what_:

| Keybinding        | Behaviour                                     |
| ----------------- | --------------------------------------------- |
| `<leader>/`       | Open picker with empty query                  |
| `<leader><space>` | Open picker with word under cursor pre-filled |

---

## Scope prefixes

The scope determines _where_ to search. It is either a path or a named shorthand.

### Path scopes

Any valid path works as a scope. The parser recognises it by the leading character.

| Scope        | Where                                   |
| ------------ | --------------------------------------- |
| _(none)_     | git root (default)                      |
| `.` or `./`  | current working directory               |
| `~` or `~/`  | home directory                          |
| `/some/path` | absolute path                           |
| `../`        | parent directory (or any relative path) |

### Named shorthands

For things that are not expressible as filesystem paths.

| Scope | Where               |
| ----- | ------------------- |
| `g`   | git root (explicit) |
| `b`   | current buffer      |
| `B`   | all open buffers    |
| `q`   | quickfix list       |
| `a`   | arglist             |

---

## Inline flags

Flags are appended after `--` and passed verbatim to ripgrep. Any ripgrep option works.

| Example       | Effect                               |
| ------------- | ------------------------------------ |
| `-- --hidden` | include hidden files and directories |
| `-- -g *.lua` | restrict to files matching a glob    |
| `-- -t py`    | restrict to a filetype               |
| `-- -i`       | case insensitive search              |
| `-- -w`       | whole word match                     |

### Convenience keybinding

`<C-.>` inside the picker inserts or removes `--hidden` in the query string. It is
purely a shortcut — equivalent to typing `-- --hidden` by hand.

---

## Examples

| Intent                                  | Query                               |
| --------------------------------------- | ----------------------------------- |
| Search git root for `foo`               | `foo`                               |
| Search cwd for `foo`                    | `. foo`                             |
| Search home dir for `foo`               | `~ foo`                             |
| Search an absolute path                 | `/usr/local foo`                    |
| Search current buffer for `foo`         | `b foo`                             |
| Search all open buffers for `foo`       | `B foo`                             |
| Search quickfix list for `foo`          | `q foo`                             |
| Search arglist for `foo`                | `a foo`                             |
| Search git root, include hidden         | `foo -- --hidden`                   |
| Search cwd, only Lua files              | `. foo -- -g *.lua`                 |
| Search cwd, include hidden, only Python | `. foo -- --hidden -t py`           |
| Word under cursor, git root             | picker opens pre-filled: `myFunc`   |
| Word under cursor, cwd                  | picker opens pre-filled: `. myFunc` |

---

## Summary

| Dimension | Solution                | Mechanism                                                  |
| --------- | ----------------------- | ---------------------------------------------------------- |
| **what**  | two keybindings         | `<leader>/` for pattern, `<leader>*` for word under cursor |
| **where** | inline scope prefix     | path or shorthand typed at the start of the query          |
| **how**   | inline flags after `--` | any ripgrep flag; `<C-.>` toggles `--hidden` as a shortcut |
