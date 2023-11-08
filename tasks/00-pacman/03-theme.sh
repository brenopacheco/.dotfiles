#!/usr/bin/env bash
#
# Applying the theme requires setting ~/.config/gtk-3.0/settings.ini
# and ~/.gtkrc-2.0, which is configured by lxappearance.
#
# The setting gtk-application-prefer-dark-theme needs to be OFF or theme
# colors will be flipped

function should_run() {
	has_packages rose-pine-gtk-theme-full || return "$RUN"
	has_packages bibata-modern-ice || return "$RUN"
	return "$DONE"

}

function task() {
	has_packages rose-pine-gtk-theme-full ||
		makepkg_task rose-pine-gtk-theme-full || return
	has_packages bibata-modern-ice ||
		makepkg_task bibata-modern-ice || return
	return "$OK"
}
