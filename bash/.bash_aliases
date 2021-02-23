# lua
alias lua="lua5.1"


# git
alias gs='git status'
alias ga='git add -A'
alias gm='git commit'
alias gp='git push'
alias gw='git-watch'
alias gb='git branch'
gc() {
    git checkout $(git branch -vva | fzf --reverse | sed 's/^[^a-zA-Z]\+//' | awk '{printf $1}')
}


alias pstree="ps -aef --forest"
alias v="nvim"
alias vv="cd ~/.config/nvim"


# custom
alias rename='perl-rename'
alias vim='nvim'
alias mutt='neomutt'
alias disks='gnome-disks'
alias dmenu='dmenu_color'
alias pi='sudo pacman -Syu'
alias pac='sudo pacman -S'
alias pr='sudo pacman -Rncs'
alias pq='list-pkgs'
alias yi='yay -Syu'
alias yr='yay -Rncs'
alias reload='source ~/.bashrc'
alias usage='du -sch .[!.]* * |sort -h'

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

# configurations for default cmds
alias joe="joe-gitignore"
alias scp='scp -F ~/.ssh/config'
alias python='python3'
alias ll='ls -l'
alias la='ls -la'

# colors for default cmds
alias bat='bat --color=always'
alias ls='ls -F --color=auto -1'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias less='less -r'
