# ============================================================================
# Fish configuration — migrated from .bashrc, .bash_aliases, .bash_functions
# ============================================================================

# ---- Keybindings ----
# Default (emacs) mode with Ctrl+R bound to history search
fish_default_key_bindings
bind \cr history-pager

# ---- Environment variables ----
# Locale & system
set -gx LC_ALL en_US.UTF-8
set -gx XDG_CONFIG_HOME $HOME/.config

# Editors & viewers
set -gx EDITOR /usr/bin/vim
set -gx VISUAL /usr/bin/vim
set -gx BROWSER /usr/bin/chromium
set -gx OPENER /usr/bin/xdg-open
set -gx MANPAGER "bat -l man --style=plain"
set -gx LESS -R

# Dev tools
set -gx GOPATH $HOME/.go
set -gx ZK_NOTEBOOK_DIR $HOME/notes
set -gx PNPM_HOME $HOME/.local/share/pnpm
set -gx NODE_OPTIONS "--max-old-space-size=12288"

# GPG / SSH
set -gx GPG_TTY (tty)
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

# ---- PATH ----
fish_add_path $HOME/bin
fish_add_path $HOME/.asdf/shims
fish_add_path $HOME/.npm/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.luarocks/bin
fish_add_path $HOME/.go/bin
fish_add_path $HOME/.local/bin

if type -q rustup
    fish_add_path (dirname (rustup which rustc))
end

# ---- GPG agent ----
if not pgrep gpg-agent >/dev/null 2>&1
    if test (uname) = Darwin
        gpg-agent --daemon
    else if systemctl --user is-active gpg-agent.target >/dev/null
        echo "gpg-agent is not active. enable it by running:" >&2
        echo "  systemctl --user enable gpg-agent.target" >&2
        echo "  systemctl --user start gpg-agent.target" >&2
    end
else
    gpg-connect-agent updatestartuptty /bye >/dev/null
end

# ---- fzf ----
# Disabled — prefer fish's built-in Ctrl+R and native features.
# To re-enable: if type -q fzf; fzf --fish | source; end

# ---- asdf ----
if type -q asdf
    asdf completion fish | source
end

# ---- Fish settings ----
set -g fish_greeting ""
set -g fish_history_pager_case_sensitive 0

# ---- Abbreviations ----

# Editor / tools
abbr --add v nvim
abbr --add ls 'ls -Fl'
abbr --add ports 'ss -tulpn'

# Pacman
abbr --add pi 'sudo pacman -S'
abbr --add pr 'sudo pacman -Rncs'

# Tmux
abbr --add ta 'tmux attach'
abbr --add tk 'tmux kill-server'
abbr --add ts 'tmux new -s (basename $PWD)'

# Git shortcuts
abbr --add gs 'git status'
abbr --add gp 'git pull'
abbr --add grm 'git clean -fd'

# Common dirs
abbr --add desk 'cd ~/Desktop/'
abbr --add down 'cd ~/Downloads/'

# ---- Functions ----

# cd hook: auto-ls after directory change
function __ls_after_cd --on-variable PWD
    ls -Fl
end

# lf: lf file manager with last-dir support
function lf
    set -l tmp (mktemp)
    command lf -last-dir-path="$tmp"
    set -l dir (cat "$tmp")
    if test -d "$dir" -a "$dir" != (pwd)
        cd "$dir"
    end
end

# gc: git checkout with fzf branch selector
function gc
    if test (count $argv) -ne 0
        git checkout $argv
    else
        set -l branch (git branch -vva | awk '{print $1}' | \
            sed 's/^remotes\/origin\///' | sort -u | \
            fzf --no-multi --header="Branch:")
        if test -n "$branch"
            if git show-ref --verify --quiet refs/heads/"$branch"
                git checkout "$branch"
            else
                git checkout --track "origin/$branch"
            end
        end
    end
end

# gr: cd into git repository root
function gr
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$root"
        cd "$root"
    else
        echo "Not a git repository" >&2
    end
end

# ---- Per-directory config ----
# Fish sources every .fish file in ~/.config/fish/conf.d/ on startup.
# To load config only when entering a specific directory, check $PWD:
#
#   # ~/.config/fish/conf.d/work.fish
#   if string match -qr '^/home/breno/work/' "$PWD"
#       set -gx GIT_AUTHOR_EMAIL "me@work.com"
#       fish_add_path /opt/work/bin
#   end
#
# For auto-switching (node versions, venvs, env vars on cd), use direnv:
#   pacman -S direnv
#   # then add `use nodejs 20` or `layout python` to a .envrc file
#
# Current fallback (sourced unconditionally on startup):
if test -f $HOME/work/config.fish
    source $HOME/work/config.fish
end
echo "config-loaded" > /tmp/fish_config_test
