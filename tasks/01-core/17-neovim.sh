#!/usr/bin/env bash

function get_ver() {
	curl -s https://api.github.com/repos/neovim/neovim/releases |
		jq '.[] | select(.tag_name == "nightly")' |
		jq '.body | capture("NVIM (?<version>.+)")' |
		jq -r '.version | gsub("^v|-dev.*"; "")'
}

function get_rel() {
	curl -s "https://api.github.com/repos/neovim/neovim/actions/runs?event=schedule&status=completed" |
		jq '.workflow_runs | [.[] | select(.display_title == "Release")][0] | .run_number'
}

function should_run() {
	VER=$(get_ver)
	REL=$(get_rel)
	VERSION="$VER-$REL"
	is_version_newer neovim-fork "$VERSION" &&
		return "$RUN" || return "$DONE"
}

function task() {
	VER=$(get_ver)
	REL=$(get_rel)
	VERSION="$VER-$REL"
	DATA=$(jq -n --arg input "$VERSION" '{"PKGVER": ($input | split("-")[0]), "PKGREL": ($input | split("-")[1])}')
	makepkg_PKGBUILD neovim PKGBUILD.in "$DATA"
	makepkg_task neovim && 
		nvim --headless +PaqInstall +qa &&
		nvim --headless +TSUpdateSync +qa &&
		return "$OK"
}
