alias tl='tmux list-sessions -F "#{session_id}: #{session_name} (group: #{session_group}) - #{?session_attached,attached,detached}"'
alias ta='tmux new -A -t scratch'
alias tk='tmux kill-server'
alias ts='tmux new -t scratch \; neww'
alias t='tmux'
alias notes="cd ~/git/notes"
alias ec="emacsclient --create-frame & disown"

alias aliases='v ~/.bash_aliases'
alias pp='pushd .'
alias po='popd'

alias packettracer='/opt/pt/packettracer'
alias fcd='cd $(fd -t d | fzf)'
alias fv='v $(fd -t f | fzf)'

# yarn/npm
alias ys='yarn start'
alias ns='npm start'
alias yt='yarn test'
alias nt='npm test'
alias yi='yarn install'
alias ni='npm install'
alias yr='rm -rf ./node_modules && yarn install'
alias nr='rm -rf ./node_modules && npm install'

# docker
alias dc='docker-compose'
alias dcd='docker-compose down'
alias dcb='docker-compose build'
alias dcu='docker-compose up'
alias dc='docker container ls'
alias di='docker image ls'
alias dps='docker ps -a'
alias dr='docker stop $(docker ps -aq)'
alias d='docker'
alias dl='docker-logs'
alias de='docker-exec'

# git
alias gamend='git commit --amend --no-edit'
alias gpu='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias gcm='git commit -m '
alias gr='git-root'
alias gR='cd $(upsearch package.json)'
alias gs='git status'
alias gS='git stash'
alias grm='git clean -fd'
alias ga='git add -A'
alias gm='git commit'
alias gf='git fetch'
alias gp='git pull'
alias gw='git-watch'
alias gb='git-branch'
alias g='git'
alias gc='git-checkout'

# pacman
alias pi='sudo pacman -Syu'
alias pac='sudo pacman -S'
alias pr='sudo pacman -Rncs'
alias pq='list-pkgs'

# programs
alias python='python3'
alias lua='lua5.1'
alias geny='/opt/genymobile/genymotion/genymotion'
alias rename='perl-rename'
alias dmenu='dmenu_color'
alias v='nvim'

# colors/defaults
alias bat='bat --color=always'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias less='less -r'
alias ls='ls -F --color=auto -1'
alias ll='ls -l'
alias la='ls -la'
alias reload='source ~/.bashrc'
alias usage='du -sch .[!.]* * |sort -h'
alias pstree='ps -aef --forest'

# directories
# alias dot='cd ~/.dotfiles'
alias mnt='cd /var/run/media/breno'
alias tmp='cd /tmp/'
alias desk='cd ~/Desktop'
alias down='cd ~/Downloads'
alias bin='cd ~/.dotfiles/bins/bin'
alias vv='cd ~/.config/nvim'
alias reps='cd ~/promote'
alias deps='cd ~/promote/dependencies/operate'
alias skt='cd ~/sketch'
