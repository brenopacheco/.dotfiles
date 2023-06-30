# cd : display files when cd'ing {{{
function cd() {
	builtin cd "$@" && ls -F
}
# }}}
# extract : extract a compressed file {{{
function extract() {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)   tar xjf $1     ;;
			*.tar.gz)    tar xzf $1     ;;
			*.bz2)       bunzip2 $1     ;;
			*.rar)       unrar e $1     ;;
			*.gz)        gunzip $1      ;;
			*.tar)       tar xf $1      ;;
			*.tbz2)      tar xjf $1     ;;
			*.tgz)       tar xzf $1     ;;
			*.zip)       unzip $1       ;;
			*.Z)         uncompress $1  ;;
			*.7z)        7z x $1        ;;
			*)     echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}
# }}}
# fork : forks current shell {{{
    function fork () {
        st >/dev/null 2>&1 & disown $!
    }
# }}}
# shut : Asks if user wants to shutdown {{{
    function shut () {
		opt=$(echo -e "yes\nno" | dmenu_color -p "Shutdown?")
		[[ "$opt" == "yes" ]] && shutdown -h now
    }
# }}}
# lf : run lf cding to last dir & reseting marks {{{
	function lf () {
		tmp="$(mktemp)"
		$(which lf) -last-dir-path="$tmp"
		if [ -f "$tmp" ]; then
			dir="$(cat "$tmp")"
			if [ -d "$dir" ]; then
				if [ "$dir" != "$(pwd)" ]; then
					cd "$dir"
				fi
			fi
		fi
	}
# }}}
# list-pkgs : list largest pacman packages{{{
	function list-pkgs() {
		pacman -Qi | awk '/^Name/{name=$3}       \
			/^Installed Size/{print $4$5, name}' \
			| sort -hr | head -34
	}
# }}}
# git-root : cd to root of git directory{{{
function git-root() {
    root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ $? -eq 0 ]]; then
        cd $root
    else
        echo "Not a git repository"
    fi
}
# upsearch
function upsearch () {
    pushd . >/dev/null
    test / == "$PWD" && return || test -e "$1" && echo "$PWD" && return || cd .. >/dev/null && upsearch "$1"
    popd >/dev/null
}
# }}}
# fzf-vim : searches for files and opens in vim {{{
function fzf-vim() {
    FILES=$(fd . ~ -HIia -t f -j 5 2> /dev/null | fzf --ansi  \
        --preview 'bat --color=always --style=header,grid --line-range :100 {}')
    [ $? == 0 ] && vim $FILES
    FZF_DEFAULT_OPTS=$OLD_OPTS
}
# }}}
# fzf-pdf : searches for pdfs and opens zathura {{{
function fzf-pdf() {
	OPTS="--height 100% --bind ctrl-j:down,ctrl-k:up"
	# local list=($(ag ~ -g "\.pdf$" 2> /dev/null))
	local list=($(fd . ~ -ia -t f -j 5 -e pdf 2> /dev/null))
	local base_list=($(printf '%s\n' "${list[@]}" | sed 's=.*/==' 2>/dev/null))
	local fzf_list_formatted=$(printf '%s\n' "${base_list[@]}")
	local CMD='echo "$fzf_list_formatted" | fzf'
    local selected="$(eval $CMD $OPTS)"
	for i in "${!base_list[@]}"; do
	   if [[ "${base_list[$i]}" = "${selected}" ]]; then
		   nohup bash -c "zathura ${list[$i]} &" > /dev/null 2>&1
		fi

	done
}
# }}}
# fzf-dir : searches dirs and cd {{{
function fzf-dir(){
	OPTS="--height 100% --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

	# CMD="find ~ -type d 2>/dev/null | fzf $OPTS"
	CMD="fd . -ia -t d -j 5 2>/dev/null | fzf $OPTS"
	dir_to_go=$(eval $CMD)
	[[ $dir_to_go ]] && cd $dir_to_go
}

#}}}
# fzf-joe : generate .gitginore with joe and fzf {{{
function fzf-joe(){
	list=$(joe-gitignore ls | sed '1d; 2s/, /\n/g')
	ignores=""
	while true; do
		header="Selected: $(echo $ignores | sed 's/,$//')"
		selected=$( echo "$list" | fzf -m --layout=reverse --header="$header" | tr '\n' ',')
		if [[ -z "$selected" ]]; then
		   break
		fi
		ignores+="$selected"
	done
	ignores=$(echo $ignores | sed 's/,$//')
	echo "Selected: $ignores"
	joe-gitignore g "$ignores"
	echo "joe-gitignore g $ignores"
}
#}}}
# fzf-hist : runs history cmd {{{
function fzf-hist(){
  eval $(cat ~/.bash_history | sed '/^#/d' | fzf)
}
#}}}
# zeal-docs-fix : fix broken zeal docs {{{
zeal-docs-fix() {
    pushd "$HOME/.local/share/Zeal/Zeal/docsets" >/dev/null || return
    find . -iname 'react-main*.js' -exec rm '{}' \;
    popd >/dev/null || exit
}
#}}}
# docker-logs() {{{
docker-logs() {
    local container=$(docker ps --format "{{.Names}}" | fzf)
    test -z "$container" || docker logs -f "$container"
}
# }}}
# docker-exec() {{{
docker-exec() {
    local container=$(docker ps --format "{{.Names}}" | fzf)
    if [ ! -z "$container" ]; then
        local shell=$(echo -e "bash\nsh" | fzf)
        if [ ! -z "$shell" ]; then
            docker exec -it "$container" "$shell"
        fi
    fi
}
# }}}
# apps() {{{
apps() {
    local app=$(ls -d ~/promote/src/*/ | sed 's/^.*promote\/src\///' | sed 's/\/\+$//' | fzf -m --layout=reverse --header="Projects:")
    if [ ! -z "$app" ]; then
        local dir="$HOME/promote/src/${app}"
        cd $dir
    fi
}
apps2() {
    local app=$(ls -d ~/promote/src/*/ | sed 's/^.*promote\/src\///' | sed 's/\/\+$//' | fzf -m --layout=reverse --header="Projects:")
    if [ ! -z "$app" ]; then
        local dir="$HOME/promote/src/${app}"
        tmux new-session -A -s "$app"
        # cd $dir
    fi
}
# }}}
# git-branch() {{{
git-branch() {
    local branch=$(git branch -vva | grep remotes | awk '{print $1}' | sed 's/^remotes\/origin\///' | fzf -m --layout=reverse --header="Projects:")
    if [ ! -z "$branch" ]; then
        local b="origin/$branch"
        git checkout --track ${b}
    fi
}
# git-checkout() {{{
git-checkout() {
    if [ "$#" -eq 0 ]
    then
        local branch=$(git branch -vva | grep remotes | awk '{print $1}' | sed 's/^remotes\/origin\///' | fzf -m --layout=reverse --header="Projects:")
        if [ ! -z "$branch" ]; then
            git checkout ${branch}
        fi
    else
        git checkout $@
    fi
}
# }}}
# delete-branches {{{
function delete-branches() {
  git branch |
    grep --invert-match '\*' |
    cut -c 3- |
    fzf --multi --preview="git log {} --" |
    xargs --no-run-if-empty git branch --delete --force
}
# }}}
function gstash() {
    git stash list | fzf --preview="echo {} | cut -d':' -f1 | xargs git stash show -p"
}

function clear_yarn() {
    cat /tmp/new | egrep '^ ' | sed 's/^ .//' | sed "s/'//g" | sed 's/: .*//' | xargs -i yarn config delete {}
}

# remove local branches that do not exist on remote
function git_clean_branches() {
  git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
}
