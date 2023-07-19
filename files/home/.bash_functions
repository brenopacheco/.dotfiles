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
# reset_caps : toggle caps lock  {{{
function reset_caps() {
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
# vim:tw=78:ts=8:noet:ft=sh:norl:
