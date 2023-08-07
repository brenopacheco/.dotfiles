#!/usr/bin/env bash
#
# Applying the theme requires setting ~/.config/gtk-3.0/settings.ini 
# and ~/.gtkrc-2.0, which is configured by lxappearance.
#
# The setting gtk-application-prefer-dark-theme needs to be OFF or theme
# colors will be flipped

function should_run() {
	has_packages rose-pine-gtk-theme && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task rose-pine-gtk-theme && 
		gsettings set org.gnome.desktop.interface gtk-theme rose-pine-gtk &&
		return "$OK"
}
