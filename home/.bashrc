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

shopt -s histappend               # append to history file
shopt -s cmdhist                  # preserve multi-line commands
shopt -s checkwinsize             # update terminal size variables LINES/COLUMNS
shopt -s globstar                 # enable recursive globbing **/*
set -o vi                         # use vi mode for command line
set -o notify                     # immediate job completion notifications
set completion-ignore-case On     # case-insensitive completion

export PROMPT_DIRTRIM=3           # trim directory path to last 3 components

export HISTFILESIZE=9999999000    # max size of history file
export HISTSIZE=9999999000        # max number of history entries
export HISTCONTROL=ignoreboth     # ignore duplicates and blank lines
export HISTIGNORE='&:[ ]*'        # ignore specific patterns in history
export HISTTIMEFORMAT='%F %T '    # format for timestamp in history

export LC_ALL=en_US.UTF-8         # set locale for all categories
export LANG=en_US.UTF-8           # set default language
export LANGUAGE=en_US.UTF-8       # set preferred language for messages

source "$HOME/.bash_aliases"
source "$HOME/.bash_functions"
source "$HOME/.bash_keybindings"

if eval which fzf >/dev/null 2>&1; then
	source /usr/share/fzf/key-bindings.bash
	source /usr/share/fzf/completion.bash
fi

if [ -d ~/.asdf ]; then
	source ~/.asdf/asdf.sh
	source ~/.asdf/completions/asdf.bash
fi

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim
export MANPAGER='/usr/bin/nvim +Man!'
export OPENER='/usr/bin/xdg-open'
export BROWSER='/usr/bin/chromium'
export XDG_CONFIG_HOME=$HOME/.config
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GOPATH=$HOME/.go

export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.npm/bin          # node
export PATH=$PATH:$HOME/.cargo/bin        # rust
export PATH=$PATH:$HOME/.local/bin        # pipx
export PATH=$PATH:$HOME/.go/bin           # go
export PATH=$PATH:$HOME/.luarocks/bin     # lua
export PATH=$PATH:/usr/bin/core_perl      # perl

test -e ~/.npmtoken && source ~/.npmtoken
