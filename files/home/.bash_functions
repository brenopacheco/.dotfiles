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
	[[ -d "$dir" && "$dir" != "$(pwd)" ]] && cd "$dir"
}
# }}}
# caps-lock : toggle caps lock  {{{
function caps-lock() {
	xdotool key Caps_Lock
}
#}}}
# tmux_fzf : fzf tmux sessions and attach {{{
function tmux_fzf() {
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
        echo "fetching with -p option...";
        git fetch -p;
        echo "running pruning of local branches"
        git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -i bash -c 'git branch -D {}' ;
}
# }}}

# vim:tw=78:ts=8:noet:ft=sh:norl:
