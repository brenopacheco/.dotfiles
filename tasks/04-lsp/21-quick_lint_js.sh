#!/usr/bin/env bash

function get_version() {
	curl -s https://api.github.com/repos/quick-lint/quick-lint-js/releases |
		jq -r '.[0] | .tag_name'
}

function should_run() {
	VERSION=$(get_version)
	is_version_newer quick-lint-js $VERSION &&
		return $RUN || return $DONE
}

function task() {
	VERSION=$(get_version)
	DATA=$(jq -n --arg input "$VERSION" '{"PKGVER": $input}')
	makepkg_PKGBUILD quick-lint-js PKGBUILD.in "$DATA"
	makepkg_task quick-lint-js && return $OK
}
