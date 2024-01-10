# shellcheck disable=SC1090,SC2155
# If not running interactively, do nothing
case $- in
*i*) ;;
*) return ;;
esac

# get current branch in git repo
export PROMPT_DIRTRIM=3

PS1='\[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\[\e[31m\]$(git_branch)\[\e[m\]\[\e[0m\]\$ '

function git_branch { # get git branch of pwd
	local _branch
	_branch="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
	if [ -n "$_branch" ]; then
		echo " ($_branch)"
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
source "$HOME/.bash_aliases"
source "$HOME/.bash_functions"
source "$HOME/.bash_keybindings"

# Set vim as default editor
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

## source fzf settings
if eval which fzf >/dev/null 2>&1; then
	source /usr/share/fzf/key-bindings.bash
	source /usr/share/fzf/completion.bash
fi

## source sdk manager
if [ -d ~/.asdf ]; then
	source ~/.asdf/asdf.sh
	source ~/.asdf/completions/asdf.bash
fi

# Misc settings
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DOWNLOAD_DIR=$HOME/downloads
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

# GOPATH is required for LSP and gobuild
export GOPATH=$HOME/.go

# OPAM configuration
test -r /home/breno/.opam/opam-init/init.sh &&
	. /home/breno/.opam/opam-init/init.sh >/dev/null 2>/dev/null

# PATH
# if [ "$SHLVL" = 1 ]; then
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.npm/bin          # node
export PATH=$PATH:$HOME/.yarn/bin         # node
export PATH=$PATH:$HOME/.cargo/bin        # rust
export PATH=$PATH:$HOME/.local/bin        # python
export PATH=$PATH:$HOME/.pkgs/bin         # ngrok
export PATH=$PATH:$HOME/.go/bin           # go
export PATH=$PATH:$HOME/.nimble/bin       # nim
export PATH=$PATH:$HOME/.opam/default/bin # ocaml
export PATH=$PATH:$HOME/.dotnet/tools
# fi

test -e ~/.npmtoken && source ~/.npmtoken
test -e ~/.twitch-notify.conf && source ~/.twitch-notify.conf

export ASPNETCORE_Kestrel__Certificates__Default__Password=""
export ASPNETCORE_Kestrel__Certificates__Default__Path="$HOME/.aspnet/dotnet-devcert.pfx"
