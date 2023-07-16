# If not running interactively, do nothing
case $- in
*i*) ;;
*) return ;;
esac

# get current branch in git repo
export PROMPT_DIRTRIM=3

PS1='\[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\[\e[31m\]$(git_branch)\[\e[m\]\[\e[0m\]\$ '

function git_branch { # get git branch of pwd
	local branch="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
	if [ -n "$branch" ]; then
		echo " ($branch)"
	fi
}

# History settings
shopt -s histappend # appends history entries in .bash_history
export HISTFILESIZE=9999999000
export HISTSIZE=9999999000
export HISTCONTROL=ignoreboth
export HISTIGNORE='&:[ ]*'
export HISTTIMEFORMAT='%F %T '
shopt -s cmdhist

## encoding
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

## Uses vim mode in bash
set -o vi
set -o notify
set completion-ignore-case On
shopt -s checkwinsize
shopt -s globstar

# Source aliases and functions and keybindings
source $HOME/.bash_aliases
source $HOME/.bash_functions
source $HOME/.bash_keybindings

# Set vim as default editor
export EDITOR=vim
export VISUAL=vim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

## source fzf settings
if $(which fzf >/dev/null 2>&1); then
	source /usr/share/fzf/key-bindings.bash
	source /usr/share/fzf/completion.bash
fi

## source sdk manager
if [ -d $HOME/.asdf ]; then
	source $HOME/.asdf/asdf.sh
	source $HOME/.asdf/completions/asdf.bash
fi

# Misc settings
export XDG_CONFIG_HOME=$HOME/.config
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

# PATH
# if [ "$SHLVL" = 1 ]; then
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.npm/bin   # node
export PATH=$PATH:$HOME/.cargo/bin # rust
export PATH=$PATH:$HOME/.local/bin # python
export PATH=$PATH:$HOME/.pkgs/bin  # ngrok
export GOPATH=$HOME/.go
export PATH=$PATH:$HOME/.go/bin    # go
# fi

test -e .npmtoken && source .npmtoken
