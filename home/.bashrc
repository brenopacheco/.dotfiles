# shellcheck disable=SC1090,SC2155

# If not running interactively, do nothing
case $- in
*i*) ;;
*) return ;;
esac

PS1='\[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\[\e[31m\]$(git_branch)\[\e[m\]\[\e[0m\]\$ '

function git_branch { # get git branch of pwd
	local _branch
	_branch="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
	if [ -n "$_branch" ]; then
		echo " ($_branch)"
	fi
}

shopt -s histappend            # append to history file
shopt -s cmdhist               # preserve multi-line commands
shopt -s checkwinsize          # update terminal size variables LINES/COLUMNS
shopt -s globstar              # enable recursive globbing **/*
set -o vi                      # use vi mode for command line
set -o notify                  # immediate job completion notifications
set completion-ignore-case On  # case-insensitive completion
export PROMPT_DIRTRIM=3        # trim directory path to last 3 components
export HISTFILESIZE=9999999000 # max size of history file
export HISTSIZE=9999999000     # max number of history entries
export HISTCONTROL=ignoreboth  # ignore duplicates and blank lines
export HISTIGNORE='&:[ ]*'     # ignore specific patterns in history
export HISTTIMEFORMAT='%F %T ' # format for timestamp in history
export LC_ALL=en_US.UTF-8      # override all locale categories

source "$HOME/.bash_aliases"
source "$HOME/.bash_functions"
source "$HOME/.bash_keybindings"

eval "$(fzf --bash)"
eval "$(asdf completion bash)"

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim
export MANPAGER='/usr/bin/nvim +Man!'
export OPENER='/usr/bin/xdg-open'
export BROWSER='/usr/bin/chromium'
export XDG_CONFIG_HOME=$HOME/.config
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

append_path() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*)
		PATH="${PATH:+$PATH:}$1"
		;;
	esac
}

export GOPATH=$HOME/.go
export ZK_NOTEBOOK_DIR="$HOME/notes"
export PNPM_HOME="$HOME/.local/share/pnpm"

append_path "$HOME/bin"
append_path "$HOME/.asdf/shims"
append_path "$HOME/.npm/bin"          # node
append_path "$HOME/.cargo/bin"        # rust
append_path "$HOME/.local/bin"        # pipx
append_path "$HOME/.go/bin"           # go
append_path "$HOME/.luarocks/bin"     # lua
append_path "$HOME/.perl5/bin"        # lua
append_path '/usr/bin/vendor_perl'
append_path '/usr/bin/core_perl'
append_path "$(dirname "$(rustup which rustc)")"

test -e ~/.npmtoken && source ~/.npmtoken

export NODE_OPTIONS="--max-old-space-size=12288"

# perl
export PERL5LIB="$HOME/.perl5/custom"  # for stowed modules
export PERL_CPANM_OPT="--local-lib=$HOME/.perl5"
eval "$(perl -I "$HOME"/.perl5/lib/perl5/ -Mlocal::lib="$HOME/.perl5")"
