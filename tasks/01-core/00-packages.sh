#!/usr/bin/env bash

packages=(
	"arandr"
	"base"
	"base-devel"
	"bash-completion"
	"bear"
	"blueman"
	"bluez"
	"bluez-utils"
	"chromium"
	"cmake"
	"conky"
	"ctags"
	"dosfstools"
	"dunst"
	"dzen2"
	"fd"
	"feh"
	"file-roller"
	"firefox"
	"fzf"
	"git"
	"gparted"
	"gpick"
	"gvim"
	"htop"
	"imagemagick"
	"inotify-tools"
	"jq"
	"libappindicator-gtk3"
	"lsof"
	"moreutils"
	"ncdu"
	"net-tools"
	"network-manager-applet"
	"ninja"
	"pamixer"
	"parted"
	"pass"
	"pass-otp"
	"pasystray"
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
	"usbutils"
	"wget"
	"wmctrl"
	"xarchiver"
	"xclip"
	"xdotool"
	"xorg-xev"
	"xorg-xkill"
	"xorg-xlsclients"
	"xorg-xmodmap"
	"xorg-xsetroot"
	"xorg-xwininfo"
	"zathura"
	"zathura-pdf-mupdf"
	"zip"
	"zk"
)

function should_run() {
	are_packages_synced || return "$RUN"
	has_packages "${packages[@]}" || return "$RUN"
	return "$DONE"
}

function task() {
	sudo pacman -Syu --noconfirm &&
		sudo pacman -S --noconfirm "${packages[@]}" && return "$OK"
}
