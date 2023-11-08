#!/usr/bin/env bash

packages=(
	"arandr"
	"bash-completion"
	"bear"
	"blueman"
	"bluez"
	"bluez-utils"
	"chromium"
	"conky"
	"ctags"
	"dmenu"
	"dunst"
	"fd"
	"feh"
	"firefox"
	"fzf"
	"gpick"
	"htop"
	"imagemagick"
	"inotify-tools"
	"jq"
	"moreutils"
	"ncdu"
	"net-tools"
	"network-manager-applet"
	"pa-applet"
	"parted"
	"pass"
	"pass-otp"
	"pavucontrol"
	"pdftk"
	"perl"
	"polkit"
	"polkit-gnome"
	"redshift"
	"renameutils"
	"ripgrep"
	"rsync"
	"screengrab"
	"stow"
	"sxiv"
	"tmux"
	"tree"
	"udiskie"
	"unrar"
	"unzip"
	"wget"
	"wmctrl"
	"xarchiver"
	"xclip"
	"xdotool"
	"xorg-xev"
	"xorg-xkill"
	"xorg-xmodmap"
	"xorg-xsetroot"
	"zathura"
	"zathura-pdf-mupdf"
	"zk"
)

function should_run() {
	has_packages "${packages[@]}" && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm "${packages[@]}" && return "$OK"
}
