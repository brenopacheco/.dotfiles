# shellcheck disable=SC2154
alias gpgr="gpgconf --reload gpg-agent"

alias ts='tmux new -s'
alias ta='tmux attach'
alias tk='tmux kill-server'

alias ports='netstat -tulpn'

alias pp='pushd .'
alias po='popd'

alias gff='git merge --ff-only'
alias gr='git-root'
alias gs='git status'
alias grm='git clean -fd'
alias ga='git add -A'
alias gm='git commit -m '
alias gc='git-checkout'
alias gb='git-branch'
alias gp='git pull'
alias gd='git add -A && git commit -m "`date`"'

alias pi='sudo pacman -Syu'
alias pac='sudo pacman -S'
alias pr='sudo pacman -Rncs'
alias pq='pacman-list'

alias v='nvim'
alias bat='bat --color=always'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias less='less -r'
alias ls='ls -F --color=auto -1'

alias down='cd ~/Downloads'
alias desk='cd ~/Desktop'
alias mnt='cd /var/run/media/breno'
