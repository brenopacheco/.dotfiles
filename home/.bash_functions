# cd : display files when cd'ing {{{
function cd() {
	builtin cd "$@" && ls -F
}
# }}}
# lf : run lf cding to last dir & reseting marks {{{
function lf() {
	tmp="$(mktemp)"
	$(which lf) -last-dir-path="$tmp"
	dir="$(cat "$tmp")"
	[[ -d "$dir" && "$dir" != "$(pwd)" ]] && cd "$dir" || return
}
# }}}
# caps-lock : toggle caps lock  {{{
function caps-lock() {
	xdotool key Caps_Lock
}
#}}}
# tmux-fzf : fzf tmux sessions and attach {{{
function tmux-fzf() {
	if pgrep tmux; then
		session=$(tmux ls | sed 's/:.*//' | fzf --reverse --prompt="Attach: ")
		if [ -n "$session" ]; then
			tmux attach -t "$session"
		fi
	else
		echo "No tmux sessions running" >&2
	fi
}
# }}}
# ocaml : wrap ocaml with rlwrap {{{
function ocaml() {
	rlwrap /bin/ocaml "$@"
}
# }}}
# fork : spawn st {{{
function fork() {
	st >/dev/null 2>&1 &
	disown
}
# }}}
# gen-password : generate a random password {{{
function gen-password() {
	openssl rand -base64 32
}
#}}}
# git-prune-branches: remove all branches that are not on remote {{{
function git-prune-branches() {
	echo "switching to master or main branch.."
	git branch | grep 'main\|master' | xargs -n 1 git checkout
	echo "fetching with -p option..."
	git fetch -p
	echo "running pruning of local branches"
	git branch -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1; }' | xargs -i bash -c 'git branch -D {}'
}
# }}}
# shut : shutdown {{{
function shut() {
	opt=$(echo -e "confirm" | dmenu -p "Shutdown?")
	[[ "$opt" == "confirm" ]] && shutdown -h now
}
# }}}
# reset-sudo : when sudo is suddenly rejecting password, run this {{{
function reset-sudo() {
	faillock --reset
}
# }}}
# sync-datetime : if time is out of sync {{{
function reset-datetime() {
	sudo ntpd -qg
	sudo hwclock --set --date="$(date +'%Y-%m-%d %H:%M:%S')" --utc
}
# }}}
# git-root : cd into git root  {{{
function git-root() {
	if root=$(git rev-parse --show-toplevel 2>/dev/null); then
		cd "$root" || return
	else
		echo "Not a git repository" >&2
	fi
}
# }}}
# git-checkout : select remote branch and checkout using --track {{{
function git-checkout() {
	if [ $# -ne 0 ]; then
		git checkout "$@"
	else
		branch=$(git branch -vva | grep remotes | awk '{print $1}' | sed 's/^remotes\/origin\///' | fzf --no-multi --header="Branch:")
		if [ -n "$branch" ]; then
			if git show-ref --verify --quiet refs/heads/"$branch"; then
				# Check if the branch exists locally
				git checkout "${branch}"
			else
				# If the branch doesn't exist locally, check it out and track it
				git checkout --track "origin/${branch}"
			fi
		fi
	fi
}
# }}}
# git-branch : select local branch and checkout {{{
function git-branch() {
	branch=$(git branch -vva | grep -v remotes\/ | grep -v '\*' | sed 's/\s\+//' | sed 's/\s.*//' | fzf -m --layout=reverse --header="Local branches:")
	if [ -n "$branch" ]; then
		git checkout "${branch}"
	fi
}
# }}}
# pinentry-status : show status for pinentries {{{
function pinentry-status() {
	for pinentry in $(fd pinentry /usr/bin); do
		err=$(mktemp)
		if $pinentry --help >/dev/null 2>"$err"; then
			printf "%-30s - OK\n" "$pinentry"
		else
			cat "$err"
		fi
	done
}
# }}}
# pacman-list : list largest pacman packages {{{
function pacman-list() {
	pacman -Qi | awk '/^Name/{name=$3}       \
			/^Installed Size/{print $4$5, name}' |
		sort -hr | head -34
}
# }}}
# clean-docker : remove containers, images, volumes, networks  {{{
function clean-docker() {
	docker stop "$(docker ps -qa)"
	docker rm "$(docker ps -qa)"
	docker rmi -f "$(docker images -qa)"
	docker volume rm "$(docker volume ls -q)"
	docker network rm "$(docker network ls -q)"
	docker system prune -a
}
# }}}
# clean-pacman : remove cache and orphaned packages {{{
function clean-pacman() {
	sudo pacman -Scc
	sudo pacman -Rns "$(pacman -Qtdq)"
	rm -rf ~/.cache/yay
	rm -rf ~/.cache/pacman
}
# }}}
# vim:tw=78:ts=8:noet:ft=sh:norl:fdl=0:fdm=marker:fmr={{{,}}}
