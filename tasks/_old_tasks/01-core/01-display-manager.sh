#!/usr/bin/env bash

packages=(
	"lightdm"
	"lightdm-gtk-greeter"
)

function should_run() {
	has_packages "${packages[@]}" || return "$RUN"
	systemctl is-enabled lightdm || return "$RUN"
	return "$DONE"
}

function task() {
	sudo pacman -S --noconfirm "${packages[@]}" &&
		sudo systemctl enable lightdm &&
		sudo cp "$CONF" /etc/lightdm/lightdm-gtk-greeter.conf &&
		return "$OK"
}

CONF=$(mktemp)

cat >"$CONF" <<'EOF'
[greeter]
background=/usr/share/backgrounds/gnome/drool-d.svg
theme-name=rose-pine-gtk
icon-theme-name=rose-pine-icons
font-name=Fira Code Nerd Font 11
cursor-theme-name=Breeze_Snow
EOF
