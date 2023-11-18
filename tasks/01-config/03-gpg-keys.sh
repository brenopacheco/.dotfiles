#!/usr/bin/env bash
# Grabs gpg-keys and netrc files from a mounted device and imports them.
# File must be named secrets.tar.gz and contain:
# - netrc.gpg-*
# - *.private.pgp


function get_secrets_filename() {
	for device in $(lsblk | grep '/run/media/' | awk '{print $7}'); do
		local fname="${device}/secrets.tar.gz"
		if test -e "$fname"; then
			echo "$fname"
			return 0
		fi
	done
	return 1
}

function should_run() {
	gpg --list-secret-keys brenoleonhardt@gmail.com && return "$DONE"
	if ! get_secrets_filename; then
		return "$SKIP"
	fi
	return "$RUN"
}

function task() {
	local tmpdir=$(mktemp -d)
	export GPG_TTY=$(tty)
	gpgconf --reload gpg-agent
	gpg-connect-agent reloadagent /bye
	gpg-connect-agent updatestartuptty /bye
	local fname=$(get_secrets_filename)
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
}
