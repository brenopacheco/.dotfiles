#!/usr/bin/env bash

function get_version() {
	curl -s https://api.github.com/repos/artempyanykh/marksman/releases |
		jq -r '.[0] | .tag_name' | sed 's/-/./g' | sed 's/^20//'
}

function should_run() {
	VERSION=$(get_version)
	is_version_newer marksman $VERSION &&
		return $RUN || return $DONE
}

function task() {
	VERSION=$(get_version)
	TAG=$(echo "20${VERSION}" | sed 's/\./-/g')
	DATA=$(jq -n --arg ver "$VERSION" --arg tag "$TAG" '{"PKGVER": $ver, "TAG": $tag}')
	makepkg_PKGBUILD marksman PKGBUILD.in "$DATA"
	makepkg_task marksman && return $OK
}
