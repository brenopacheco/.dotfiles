# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# get current branch in git repo
export PROMPT_DIRTRIM=3

PS1='\[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e\[m\]\[\e[31m\]$(git_branch)\[\e\[m\]\[\e[0m\]\$ '

function git_branch {     # get git branch of pwd
    local branch="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
    if [ -n "$branch" ]; then
        echo " ($branch)"
    fi
}

# History settings
shopt -s histappend	# appends history entries in .bash_history
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

# PATH
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.go/bin
export PATH=$PATH:$HOME/.local/bin

# Source aliases and functions and keybindings
source $HOME/.bash_aliases
source $HOME/.bash_functions
source $HOME/.bash_keybindings

# Set vim as default editor
export EDITOR=nvim
export VISUAL=nvim
export SVN_EDITOR="$VISUAL"

## source fuzzy finder fzf settings
[ -f $HOME/.bash_fzf ] && source $HOME/.bash_fzf

# Java 
export JAVA_HOME=/usr/lib/jvm/default

## NPM / NODE config
NPM_PACKAGES="${HOME}/npm"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
[[ ! -f $HOME/.npmrc ]] && echo "prefix=${NPM_PACKAGES}" >> $HOME/.npmrc
[[ ! -d ${NPM_PACKAGES} ]] && mkdir ${NPM_PACKAGES}
export NODE_PATH=${NPM_PACKAGES}/lib/node_modules

## Luarocks modules
export PATH=$PATH:$HOME/.lua/bin

# true color kitty support
tic -x -o $HOME/.terminfo $HOME/.config/kitty/xterm-24bit.terminfo
export TERM=xterm-24bit
alias ssh="TERM=xterm-256color ssh"

# Misc settings
export XDG_CONFIG_HOME=$HOME/.config
export GPG_TTY=$(tty)

# JDTLS
#
export JAR=/path/to/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.0.v20200915-1508.jar
# export GRADLE_HOME=$HOME/gradle
# export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.9.11-9.fc33.x86_64/
export JDTLS_CONFIG=/path/to/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux
export WORKSPACE=$HOME/.cache/jdtls
