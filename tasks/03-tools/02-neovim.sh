#!/usr/bin/env bash

function get_version() {
	curl -s https://api.github.com/repos/neovim/neovim/releases |
		jq '.[] | select(.tag_name == "nightly")' |
		jq '.body | capture("NVIM (?<version>.+)")' |
		jq -r '.version | gsub("^v|(-dev)|(\\+.*)"; "")'
}

function should_run() {
	VERSION=$(get_version)
	is_version_newer neovim-fork "$VERSION" &&
		return "$RUN" || return "$DONE"
}

function task() {
	VERSION=$(get_version)
	DATA=$(jq -n --arg input "$VERSION" '{"PKGVER": ($input | split("-")[0]), "PKGREL": ($input | split("-")[1])}')
	makepkg_PKGBUILD neovim PKGBUILD.in "$DATA"
	makepkg_task neovim && return "$OK"
}
