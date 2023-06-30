#!/usr/bin/env bash

packages=(
	"arandr"
	"bash-completion"
	"blueman"
	"bluez"
	"bluez-utils"
	"conky"
	"ctags"
	"dmenu"
	"dunst"
	"fd"
	"feh"
	"fzf"
	"htop"
	"imagemagick"
	"inotify-tools"
	"moreutils"
	"most"
	"ncdu"
	"net-tools"
	"network-manager-applet"
	"pa-applet"
	"parted"
	"pass"
	"pavucontrol"
	"pdftk"
	"perl"
	"polkit"
	"polkit-gnome"
	"redshift"
	"renameutils"
	"ripgrep"
	"rofi"
	"rsync"
	"screengrab"
	"sxiv"
	"tmux"
	"tree"
	"udiskie"
	"unrar"
	"unzip"
	"wget"
	"xclip"
	"xdotool"
	"xorg-xev"
	"xorg-xkill"
	"xorg-xmodmap"
	"xorg-xsetroot"
	"zathura"
	"zathura-pdf-mupdf"
)

function should_run() {
	has_packages $packages && return $DONE || return $RUN
}

function task() {
	sudo pacman -S --noconfirm ${packages[*]} && return $OK
}
