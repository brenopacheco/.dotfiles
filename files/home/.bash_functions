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

function bold() {
	echo -e "\e[1m$*\e[0m"
}

function italic() {
	echo -e "\e[3m$*\e[0m"
}

function bolditalic() {
	echo -e "\e[3m\e[1m$*\e[0m"
}

function underline() {
	echo -e "\e[4m$*\e[0m"
}

function strikethrough() {
	echo -e "\e[9m$*\e[0m"
}
# vim:tw=78:ts=8:noet:ft=sh:norl:
