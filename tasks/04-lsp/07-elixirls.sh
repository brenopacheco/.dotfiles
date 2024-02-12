#!/usr/bin/env bash

function get_version() {
	curl -s https://api.github.com/repos/elixir-lsp/elixir-ls/releases |
		jq -r '.[0] | .tag_name | sub ("^v"; "")'
}

function should_run() {
	local VERSION
	VERSION=$(get_version)
	is_version_newer elixir-ls "$VERSION" &&
		return "$RUN" || return "$DONE"
}

function task() {
	local VERSION
	local DATA
	VERSION=$(get_version)
	DATA=$(jq -n --arg input "$VERSION" '{"PKGVER": $input}')
	makepkg_PKGBUILD elixir-ls PKGBUILD.in "$DATA"
	makepkg_task elixir-ls && return "$OK"
}
