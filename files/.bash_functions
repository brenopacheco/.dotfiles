# cd : display files when cd'ing {{{
function cd() {
	builtin cd "$@" && ls -F
}
# }}}
# man : Color man pages {{{
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
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
# dkill : kill process sing dmenu {{{
    function dkill () {
		while true; do
			# ids=$(ps -e | tac |  fzf -m | awk '{print $1}')
			ids=$(ps -e | tac |  dmenu_color -p "Process:" | awk '{print $1}')
			if [[ ${#ids} == 0 ]]; then
				# no id selected
				break
			fi
			for id in $ids; do
				# kill all selected processes
				kill -9 $id
			done
		done
    }
# }}}
# truecolortest : tests terminal truecolor {{{
    function truecolortest () {
		awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
			s="/\\";
			for (colnum = 0; colnum<term_cols; colnum++) {
				r = 255-(colnum*255/term_cols);
				g = (colnum*510/term_cols);
				b = (colnum*255/term_cols);
				if (g>255) g = 510-g;
				printf "\033[48;2;%d;%d;%dm", r,g,b;
				printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
				printf "%s\033[0m", substr(s,colnum%2+1,1);
			}
			printf "\n";
		}'
    }
# }}}
# lf : run lf cding to last dir & reseting marks {{{
	function lf () {
		# reset marks
        test ! -d $HOME/.local/share/lf && mkdir $HOME/.local/share/lf
		marks=$HOME/.local/share/lf/marks
		cat<<-EOF > $marks
			a:/home/breno/Aulas
			d:/home/breno/Desktop
			w:/home/breno/Downloads
			m:/run/media/breno
			n:/home/breno/.config/nvim
			o:/home/breno/org
			h:/home/breno
			t:/tmp
			v:/home/breno/Videos
			w:/home/breno/Downloads
		EOF
		[[ -f "$marks" ]] && sed -i 's/[ \t]//g' $marks
		# run lf and save dir
		tmp="$(mktemp)"
		$(which lf) -last-dir-path="$tmp"
		# when lf closes, cd into it
		if [ -f "$tmp" ]; then
			dir="$(cat "$tmp")"
			rm -f "$tmp"
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
# gpg-reload : reload gpg agent {{{
function gpg-reload(){
     pkill scdaemon
     pkill gpg-agent
     gpg-connect-agent /bye >/dev/null 2>&1
     gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
     gpgconf --reload gpg-agent
 }
 # }}}
# query-packages : find pacman packages given a name/regex {{{
function query-packages() {
    for i in "${@}"; do
        pacman -Qi | sed -n "/^Name.*$i/,/^$/p" | egrep "(Name|Installed Size)"
        echo ""
    done
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
	CMD="fd . -HIia -t d -j 5 2>/dev/null | fzf $OPTS"
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
    local app=$(ls -d ~/repos/*/ | sed 's/^.*repos\///' | sed 's/\/\+$//' | fzf -m --layout=reverse --header="Projects:")
    if [ ! -z "$app" ]; then
        local dir="$HOME/repos/${app}"
        cd $dir
    fi
}
# }}}
# git-branch() {{{
git-branch() {
    local branch=$(git branch -vva | grep remotes | awk '{print $1}' | sed 's/^remotes\/origin\///' | fzf -m --layout=reverse --header="Projects:")
    if [ ! -z "$branch" ]; then
        local b="origin/{$branch}"
        git checkout --track ${b}
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
