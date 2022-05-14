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

## NPM / NODE config
NPM_PACKAGES="${HOME}/.npm"
[[ ! -f $HOME/.npmrc ]] && echo "prefix=${NPM_PACKAGES}" >> $HOME/.npmrc
[[ ! -d ${NPM_PACKAGES} ]] && mkdir ${NPM_PACKAGES}

# Misc settings
export XDG_CONFIG_HOME=$HOME/.config
export GPG_TTY=$(tty)

export GOPATH=$HOME/.go
export GEM_HOME=$HOME/.gems
export GEM_PATH=$GEM_PATH


# PATH
if [ "$SHLVL" = 1 ]; then
    export PATH=$PATH:$HOME/bin
    export PATH=$PATH:$HOME/.go/bin
    export PATH=$PATH:$HOME/.cargo/bin
    export PATH=$PATH:$HOME/.local/bin
    export PATH=$PATH:$NPM_PACKAGES/bin
    export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
    export NODE_PATH=${NPM_PACKAGES}/lib/node_modules
    export PATH=$PATH:$HOME/.lua/bin
    export PATH=$PATH:$HOME/.pkgs/bin
    export PATH=$PATH:$GEM_HOME/bin
fi

# JAVA/JDTLS
# Java
export JAVA_HOME=/usr/lib/jvm/default
export JDTLS_HOME=$HOME/.cache/nvim/lsp/jdtls
export JDTLS_CONFIG=$JDTLS_HOME/config_linux
export WORKSPACE=$HOME/.cache/jdtls

# NVM
test -e /usr/share/nvm/init-nvm.sh && source /usr/share/nvm/init-nvm.sh

#.bash_profile
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export AWT_TOOLKIT=MToolkit


export PATH="$PATH:/home/breno/.dotnet/tools"

test -e .npmtoken && source .npmtoken

alias luamake=/home/breno/.cache/nvim/lsp/lua-language-server/3rd/luamake/luamake

