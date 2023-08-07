#!/usr/bin/env bash

function get_version() {
	curl -s https://api.github.com/repos/mrjosh/helm-ls/releases |
		jq -r '.[0] | .tag_name' | sed 's/^v//'
}

function should_run() {
	VERSION=$(get_version)
	is_version_newer helm-ls $VERSION &&
		return "$RUN" || return "$DONE"
}

function task() {
	VERSION=$(get_version)
	DATA=$(jq -n --arg input "$VERSION" '{"PKGVER": $input}')
	makepkg_PKGBUILD helm-ls PKGBUILD.in "$DATA"
	makepkg_task helm-ls && return "$OK"
}
