#!/usr/bin/env bash

packages=(
	'ocaml'
	'opam'
	'rlwrap'
)

opam_pkgs=(
	'utop'
	'ocaml-lsp-server'
	'ocamlformat'
	'ocp-indent'
)

function should_run() {
	has_packages "${packages[@]}" || return "$RUN"

	for package in "${opam_pkgs[@]}"; do
		if ! opam list --installed --short | grep -q "$package"; then
			return "$RUN"
		fi
	done

	[[ -d "$HOME/.opam" ]] || return "$RUN"

	return "$DONE"
}

function task() {
	sudo pacman -S --noconfirm "${packages[@]}" &&
		mkdir -p "$HOME/.opam" &&
		cd "$HOME/.opam" &&
		opam init -y &&
		opam install "${opam_pkgs[@]}" -y &&
		return "$OK"
}
