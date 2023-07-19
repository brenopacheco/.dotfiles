#!/usr/bin/env bash

function should_run() {
	has_packages rose-pine-gtk-theme && return $DONE || return $RUN
}

function task() {
	makepkg_task rose-pine-gtk-theme && 
		gsettings set org.gnome.desktop.interface gtk-theme rose-pine-gtk &&
		return $OK
}
