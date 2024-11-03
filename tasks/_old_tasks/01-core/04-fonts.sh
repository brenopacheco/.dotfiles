#!/usr/bin/env bash
# ttf-firacode-nerd > 3.* will have missing icons for some apps

packages=(
	"ttf-firacode-nerd"       # basic font + icons
	"ttf-3270-nerd"           # missing icons
	"otf-comicshanns-nerd"    # missing braille glyphs
)

function should_run() {
	has_packages "${packages[@]}" && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm nerd-fonts && return "$OK"
}
