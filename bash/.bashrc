# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\[\e[34m\]/\[\e[m\]\[\e[31m\]\`parse_git_branch\`\[\e[m\]\\$ "
export PROMPT_DIRTRIM=3



# History settings
shopt -s histappend	# appends history entries in .bash_history
export HISTFILESIZE=9999999
export HISTSIZE=9999999
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

# PATH
export PATH=$PATH:$HOME/bin
export PATH=$PATH:~/go/bin

# Source aliases and functions and keybindings
source $HOME/.bash_aliases
source $HOME/.bash_functions
source $HOME/.bash_keybindings

# Set vim as default editor
export EDITOR=nvim
export VISUAL=nvim
export SVN_EDITOR="$VISUAL"

## source fuzzy finder fzf settings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Java 
export JAVA_HOME=/usr/lib/jvm/default
export JETTY_HOME=$HOME/Java/jetty-9.4

## NPM / NODE config
NPM_PACKAGES="${HOME}/npm"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
[[ ! -f ~/.npmrc ]] && echo "prefix=${NPM_PACKAGES}" >> ~/.npmrc
[[ ! -d ${NPM_PACKAGES} ]] && mkdir ${NPM_PACKAGES}
export NODE_PATH=/home/breno/npm/lib/node_modules


# true color kitty support
# tic -x -o ~/.terminfo ~/.config/kitty/xterm-24bit.terminfo
# export TERM=xterm-24bit
alias ssh="TERM=xterm-256color ssh"


## CONFIG HOME (for GTK)
##    GTK 2 user specific: ~/.gtkrc-2.0
##    GTK 2 system wide: /etc/gtk-2.0/gtkrc
##    GTK 3 user specific: $XDG_CONFIG_HOME/gtk-3.0/settings.ini, or $HOME/.config/gtk-3.0/settings.ini if $XDG_CONFIG_HOME is not set
##    GTK 3 system wide: /etc/gtk-3.0/settings.ini
export XDG_CONFIG_HOME=$HOME/.config


# export MANPAGER='nvim +Man!'
# export MANPAGER='nvim --startuptime vim.log +Man!'
# export MANWIDTH=999
# export MANPAGER="nvim -"

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.gem/ruby/2.7.0/bin"


source /home/breno/.config/broot/launcher/bash/br
