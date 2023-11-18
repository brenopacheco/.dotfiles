#!/usr/bin/env bash

function should_run() {
	local SHA
	has_packages st-fork || return "$RUN"
	SHA=$(curl -s "https://api.github.com/repos/brenopacheco/st-fork/commits" | jq -r '.[0].sha')
	SHA=$(echo "$SHA" | cut -c1-7)
	MATCHES=$(pacman -Q --info st-fork | grep -c "$SHA")
	[[ "$MATCHES" -gt 0 ]] && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -R --noconfirm st
	makepkg_task st-fork && return "$OK"
}
