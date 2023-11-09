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
	session=$(tmux ls | sed 's/:.*//' | fzf --reverse --prompt="Attach: ")
	if [ -n "$session" ]; then
		tmux attach -t "$session"
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
# # cmus : start cmus in tmux session {{{
# function cmus() {
# 	if ! tmux has-session -t cmus 2>/dev/null; then
# 		tmux new-session -s cmus -n cmus -c ~/Music
# 	fi
# 	if ! tmux list-windows -t cmus | grep -q cmus; then
# 		tmux new-window -t cmus -n cmus -c ~/Music
# 	fi
# 	# tmux send-keys -t cmus:cmus C-c cmus C-m
# }
# # }}}
# vim:tw=78:ts=8:noet:ft=sh:norl:
