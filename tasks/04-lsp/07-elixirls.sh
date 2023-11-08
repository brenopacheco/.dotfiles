#!/usr/bin/env bash

function get_version() {
	curl -s https://api.github.com/repos/elixir-lsp/elixir-ls/releases |
		jq -r '.[0] | .tag_name' | sed 's/^v//'
}

function should_run() {
	return "$SKIP"
	local VERSION=$(get_version)
	is_version_newer elixir-ls $VERSION &&
		return "$RUN" || return "$DONE"
}

function task() {
	local VERSION=$(get_version)
	local DATA=$(jq -n --arg input "$VERSION" '{"PKGVER": $input}')
	makepkg_PKGBUILD elixir-ls PKGBUILD.in "$DATA"
	makepkg_task elixir-ls && return "$OK"
}
