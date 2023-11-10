#!/usr/bin/env bash

function should_run() {
	gpg --list-secret-keys brenoleonhardt@gmail.com && return "$DONE" || return "$RUN"
}

function task() {
	local tmpdir=$(mktemp -d)
	export GPG_TTY=$(tty)
	gpgconf --reload gpg-agent
	gpg-connect-agent reloadagent /bye
	gpg-connect-agent updatestartuptty /bye
	for device in $(lsblk | grep '/run/media/' | awk '{print $7}'); do
		local fname="${device}/secrets.tar.gz"
		if test -e "$fname"; then
			tar -zxf "$fname" --directory "$tmpdir"
			find "$tmpdir" -name "netrc.gpg-*" | while read -r netrc; do
				cp "$netrc" "$HOME/.$(basename $netrc)" || return
			done
			ln -sn .netrc.gpg-breno .netrc.gpg
			find "$tmpdir" -name "*.private.pgp" | while read -r key; do
				gpg --pinentry-mode loopback --import "$key" || return
			done
		fi
		gpg --list-secret-keys brenoleonhardt@gmail.com && return "$OK"
	done
}
