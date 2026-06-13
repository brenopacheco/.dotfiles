# Minimal bashrc — fish is the primary shell, this is a fallback.

case $- in
*i*) ;;
*) return ;;
esac

set -o vi
shopt -s histappend checkwinsize globstar

export HISTFILESIZE=9999999000
export HISTSIZE=9999999000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT='%F %T '
export LC_ALL=en_US.UTF-8
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim
export BROWSER=/usr/bin/chromium
export XDG_CONFIG_HOME=$HOME/.config
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GOPATH=$HOME/.go
export ZK_NOTEBOOK_DIR="$HOME/notes"
export PNPM_HOME="$HOME/.local/share/pnpm"
export NODE_OPTIONS="--max-old-space-size=12288"
export MANPAGER=/usr/bin/less

append_path() {
    case ":$PATH:" in
    *:"$1":*) ;;
    *)
        PATH="${PATH:+$PATH:}$1"
        ;;
    esac
}

append_path "$HOME/bin"
append_path "$HOME/.asdf/shims"
append_path "$HOME/.npm/bin"
append_path "$HOME/.cargo/bin"
append_path "$HOME/.local/bin"
append_path "$HOME/.go/bin"
append_path "$HOME/.luarocks/bin"
append_path "$HOME/.perl5/bin"
append_path /usr/bin/vendor_perl
append_path /usr/bin/core_perl

if rustup which rustc >/dev/null 2>&1; then
    append_path "$(dirname "$(rustup which rustc)")"
fi

if ! pgrep gpg-agent >/dev/null 2>&1; then
    if [[ "$(uname)" == "Darwin" ]]; then
        gpg-agent --daemon
    elif systemctl --user is-active gpg-agent.target >/dev/null; then
        printf '%s\n' \
            "gpg-agent is not active. enable it by running" \
            "  systemctl --user enable gpg-agent.target" \
            "  systemctl --user start gpg-agent.target" >&2
    fi
else
    gpg-connect-agent updatestartuptty /bye >/dev/null
fi

eval "$(fzf --bash)"
eval "$(asdf completion bash)"

test -f ~/work/bashrc && source ~/work/bashrc
