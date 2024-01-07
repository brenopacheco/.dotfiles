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

function mount_devices() {
	for disk in $(lsblk -l -b -o NAME,TYPE,TRAN,RO | awk '$2 == "disk" && $3 == "usb" && $4 == 0 {print $1}'); do
		for partition in $(lsblk -l -b -o NAME,TYPE,MOUNTPOINTS | awk -v disk="^$disk" '$1 ~ disk && $2 == "part" && $3 == "" {print $1}'); do
			udisksctl mount -b "/dev/$partition"
		done
	done
}

function should_run() {
	gpg --list-secret-keys brenoleonhardt@gmail.com && return "$DONE"
	mount_devices
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
			ln -sn "$netrc" "$HOME/.netrc.gpg"
		done
		find "$tmpdir" -name "*.private.pgp" | while read -r key; do
			gpg --pinentry-mode loopback --import "$key" || return
		done
	fi
	rm $HOME/.netrc.gpg
	ln -sn $HOME/.netrc.gpg-breno $HOME/.netrc.gpg
	gpg --list-secret-keys brenoleonhardt@gmail.com && return "$OK"
}
