alias reps='cd ~/repos'
alias ns='npm start'
alias nt='npm test'

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
# TODO: see commands and add here


# git
alias gr='git-root'
alias gs='git status'
alias gS='git stash'
alias gC='git clean -fd'
alias ga='git add -A'
alias gm='git commit'
alias gf='git fetch'
alias gp='git fetch'
alias gw='git-watch'
alias gb='git-branch'
alias g='git'
gc() {
    git checkout $(git branch -vva | fzf --reverse | sed 's/^[^a-zA-Z]\+//' | awk '{printf $1}')
}
# TODO: better commands


alias pstree='ps -aef --forest'
alias v='nvim'
alias f='fork'
alias so='source'
# TODO: how to remember that?


# custom
alias pi='sudo pacman -Syu'
alias pac='sudo pacman -S'
alias pr='sudo pacman -Rncs'
alias pq='list-pkgs'
alias yi='yay -Syu'
alias yr='yay -Rncs'
alias ll='ls -l'
alias la='ls -la'

alias reload='source ~/.bashrc'
alias usage='du -sch .[!.]* * |sort -h'



# program aliasing
alias python='python3'
alias lua='lua5.1'
alias rename='perl-rename'
alias vim='nvim'
alias mutt='neomutt'
alias dmenu='dmenu_color'

# coloring
alias bat='bat --color=always'
alias ls='ls -F --color=auto -1'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias less='less -r'

# directories cd's
alias dotfiles='cd ~/.dotfiles'
alias org='cd ~/org'
alias vids='cd ~/Videos'
alias mnt='cd /var/run/media/breno'
alias aulas='cd ~/Aulas'
alias tmp='cd /tmp/'
alias desk='cd ~/Desktop'
alias down='cd ~/Downloads'
alias pics='cd ~/Pictures'
alias bin='cd ~/.dotfiles/bins/bin'
alias vv='cd ~/.config/nvim'
