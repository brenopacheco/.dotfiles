alias ts='read -p "Session name: "; tmux new -s $REPLY'
alias ta="tmux a -t \$(tmux ls | rofi -dmenu | awk '{print \$1}' | sed 's/:\$//')"
alias tl='tmux list-sessions -F "#{session_id}: #{session_name} (group: #{session_group}) - #{?session_attached,attached,detached}"'
alias tk='tmux kill-server'

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
alias gr='git-root'
alias gs='git status'
alias grm='git clean -fd'
alias ga='git add -A'
alias gm='git commit'
alias gc='git-checkout'
alias gb='git-branch'

# pacman
alias pi='sudo pacman -Syu'
alias pac='sudo pacman -S'
alias pr='sudo pacman -Rncs'
alias pq='list-pkgs'

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
