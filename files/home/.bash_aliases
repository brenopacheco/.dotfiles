# shellcheck disable=SC2154

alias z='pdf=$(fd -t f "\.pdf$" ~/books | dmenu) && zathura $pdf &'

# rlwrap
alias fennel='rlwrap fennel'
alias csi='rlwrap chicken-csi'
alias guile='rlwrap guile'
# alias lua='rlwrap lua'

# tmux
alias ts='tmux new -s'
alias ta="tmux_fzf"
alias tl='tmux list-sessions -F "#{session_id}: #{session_name} (group: #{session_group}) - #{?session_attached,attached,detached}"'

alias pp='pushd .'
alias po='popd'

alias cdf='cd $(fd -t d | fzf)'
alias vf='v $(fd -t f | fzf)'

# yarn/npm
alias ys='yarn start'
alias ns='npm start'
alias yr='rm -rf ./node_modules && yarn install'
alias nr='rm -rf ./node_modules && npm install'

# git
alias gff='git merge --ff-only'
alias gr='cd $(git-root)'
alias gs='git status'
alias grm='git clean -fd'
alias ga='git add -A'
alias gm='git commit'
alias gc='git-checkout'
alias gb='git-branch'
alias gp='git pull'
alias gcd='git commit -m "$(date)"'

# pacman
alias pi='sudo pacman -Syu'
alias pac='sudo pacman -S'
alias pr='sudo pacman -Rncs'
alias pq='pacman-list'

# programs
alias v='nvim'

# colors/defaults
alias bat='bat --color=always'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias less='less -r'
alias ls='ls -F --color=auto -1'
alias ll='ls -l'
alias la='ls -la'

# directories
alias mnt='cd /var/run/media/breno'
alias desk='cd ~/Desktop'
alias down='cd ~/Downloads'
alias dot='cd ~/.dotfiles'
alias bin='cd ~/.bin'
