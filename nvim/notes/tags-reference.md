# Vim Tag Commands Reference

See tagsrch.txt

## Jumping to a tag (pushes onto tag stack)

| Command            | Tag source        | 1 match   | Multiple matches       |
| ------------------ | ----------------- | --------- | ---------------------- |
| `:tag {ident}`     | argument          | jump      | jump to first silently |
| `Ctrl-]`           | word under cursor | jump      | jump to first silently |
| `{Visual}Ctrl-]`   | selected text     | jump      | jump to first silently |
| `:tjump {ident}`   | argument          | jump      | show menu              |
| `g Ctrl-]`         | word under cursor | jump      | show menu              |
| `{Visual}g Ctrl-]` | selected text     | jump      | show menu              |
| `:tselect {ident}` | argument          | show menu | show menu              |
| `g]`               | word under cursor | show menu | show menu              |
| `{Visual}g]`       | selected text     | show menu | show menu              |

## Navigating the match list (does not change the tag stack)

| Command                | Effect                                 |
| ---------------------- | -------------------------------------- |
| `:tselect` (no arg)    | show menu for current tag (from stack) |
| `:tnext`               | next match                             |
| `:tprev`               | previous match                         |
| `:tfirst` / `:trewind` | first match                            |
| `:tlast`               | last match                             |

## Navigating the tag stack

| Command           | Effect                                           |
| ----------------- | ------------------------------------------------ |
| `Ctrl-T` / `:pop` | go back (older entry)                            |
| `:tag` (no arg)   | go forward (newer entry)                         |
| `:tags`           | show the full stack (`>` marks current position) |

## Split window variants (opens in a horizontal split)

| Command             | Equivalent to | Notes                              |
| ------------------- | ------------- | ---------------------------------- |
| `:stag {ident}`     | `:tag`        | jump to first silently             |
| `:stselect {ident}` | `:tselect`    | always show menu                   |
| `:stjump {ident}`   | `:tjump`      | show menu only if multiple matches |
| `Ctrl-W ]`          | `Ctrl-]`      | jump to tag under cursor in split  |

## Preview window variants (cursor stays in original window)

| Command                  | Equivalent to | Notes                                            |
| ------------------------ | ------------- | ------------------------------------------------ |
| `:ptag {ident}`          | `:tag`        | reuses existing preview window                   |
| `:ptselect {ident}`      | `:tselect`    | always show menu                                 |
| `:ptjump {ident}`        | `:tjump`      | show menu only if multiple matches               |
| `:ptnext`                | `:tnext`      | next match in preview window                     |
| `:ptprev`                | `:tprev`      | previous match in preview window                 |
| `:ptfirst` / `:ptrewind` | `:tfirst`     | first match in preview window                    |
| `:ptlast`                | `:tlast`      | last match in preview window                     |
| `:ppop`                  | `:pop`        | pop tag stack in preview window                  |
| `Ctrl-W }`               | `Ctrl-]`      | preview tag under cursor                         |
| `Ctrl-W g}`              | `g Ctrl-]`    | preview tag under cursor (show menu if multiple) |
| `Ctrl-W z` / `:pclose`   | —             | close the preview window                         |

## Key concepts

- **Tag stack** — history of tag jumps; each entry records where you came from and where you went. Unwound with `Ctrl-T`.
- **Match list** — all locations where a single tag name was found. Navigated with `:tnext`, `:tprev`, etc. without affecting the stack.
- **`:tselect` (no arg)** operates on the tag stack (shows match list for the current tag); **`:tselect {ident}`** does a fresh lookup.

## Trying it out

To get multiple matches from the help files, use a `/` pattern prefix:

```
:tselect /write
:tselect /tag
:tselect /set
```
