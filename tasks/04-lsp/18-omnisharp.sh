#!/usr/bin/env bash

function get_version() {
	# curl -s https://api.github.com/repos/OmniSharp/omnisharp-roslyn/releases |
	# 	jq -r '.[0] | .tag_name' | sed 's/^v//'
	#
	# there is a regression error going above that
	# https://github.com/OmniSharp/omnisharp-roslyn/issues/2574
	echo "1.38.0"
}

function should_run() {
	has_packages omnisharp || return "$RUN"
	VERSION=$(get_version)
	is_version_newer omnisharp "$VERSION" &&
		return "$RUN" || return "$DONE"
}

function task() {
	VERSION=$(get_version)
	DATA=$(jq -n --arg input "$VERSION" '{"PKGVER": $input}')
	makepkg_PKGBUILD omnisharp PKGBUILD.in "$DATA"
	makepkg_task omnisharp && return "$OK"
}
