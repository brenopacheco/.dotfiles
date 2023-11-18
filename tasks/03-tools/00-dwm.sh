#!/usr/bin/env bash

function should_run() {
	local SHA
	has_packages dwm-fork || return "$RUN"
	SHA=$(curl -s "https://api.github.com/repos/brenopacheco/dwm-fork/commits" | jq -r '.[0].sha')
	SHA=$(echo "$SHA" | cut -c1-7)
	MATCHES=$(pacman -Q --info dwm-fork | grep -c "$SHA")
	[[ "$MATCHES" -gt 0 ]] && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -R --noconfirm dmenu
	makepkg_task dwm-fork && return "$OK"
}
