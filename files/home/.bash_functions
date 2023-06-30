# cd : display files when cd'ing {{{
function cd() {
	builtin cd "$@" && ls -F
}
# }}}
# extract : extract a compressed file {{{
function extract() {
	if [ -f $1 ]; then
		case $1 in
		*.tar.bz2) tar xjf $1 ;;
		*.tar.gz) tar xzf $1 ;;
		*.bz2) bunzip2 $1 ;;
		*.rar) unrar e $1 ;;
		*.gz) gunzip $1 ;;
		*.tar) tar xf $1 ;;
		*.tbz2) tar xjf $1 ;;
		*.tgz) tar xzf $1 ;;
		*.zip) unzip $1 ;;
		*.Z) uncompress $1 ;;
		*.7z) 7z x $1 ;;
		*) echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}
# }}}
# fork : forks current shell {{{
function fork() {
	st >/dev/null 2>&1 &
	disown $!
}
# }}}
# shut : Asks if user wants to shutdown {{{
function shut() {
	opt=$(echo -e "yes\nno" | dmenu_color -p "Shutdown?")
	[[ "$opt" == "yes" ]] && shutdown -h now
}
# }}}
# lf : run lf cding to last dir & reseting marks {{{
function lf() {
	tmp="$(mktemp)"
	echo $tmp >/tmp/log
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
			/^Installed Size/{print $4$5, name}' |
		sort -hr | head -34
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
# git-branch() {{{
git-branch() {
	local branch=$(git branch -vva | grep remotes | awk '{print $1}' | sed 's/^remotes\/origin\///' | fzf -m --layout=reverse --header="Projects:")
	if [ ! -z "$branch" ]; then
		local b="origin/$branch"
		git checkout --track ${b}
	fi
}
# }}}
# git-checkout() {{{
git-checkout() {
	if [ "$#" -eq 0 ]; then
		local branch=$(git branch -vva | grep remotes | awk '{print $1}' | sed 's/^remotes\/origin\///' | fzf -m --layout=reverse --header="Projects:")
		if [ ! -z "$branch" ]; then
			git checkout ${branch}
		fi
	else
		git checkout $@
	fi
}
# }}}
# fzf-dir : searches dirs and cd {{{
function fzf-dir(){
	OPTS="--height 40% --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
	CMD="fd . -ia -t d -j 5 2>/dev/null | fzf $OPTS"
	DIR=$(eval $CMD)
	[[ -n "$DIR" ]] && cd $DIR
}
# }}}
# fzf-vim : searches for files and opens in vim {{{
function fzf-vim() {
    OPTS="-m --ansi --height 40% --preview 'bat --color=always --style=header,grid --line-range :100 {}'"
    CMD="fd . -ia -t f -j 5 2>/dev/null | fzf $OPTS"
    FILES=$(eval $CMD)
    [[ -n "$FILES" ]] && nvim $FILES
}
# }}}

# vim:tw=78:ts=8:noet:ft=sh:norl:
