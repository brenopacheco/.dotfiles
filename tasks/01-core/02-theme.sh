#!/usr/bin/env bash
#
# Applying the theme requires setting ~/.config/gtk-3.0/settings.ini
# and ~/.gtkrc-2.0, which is configured by lxappearance.
#
# The setting gtk-application-prefer-dark-theme needs to be OFF or theme
# colors will be flipped
#
# We might need to replace the usr share gtk files with symlinks, otherwise
# the cursor might not look correct

symlinks=(
	"/usr/share/gtk-2.0/gtkrc"
	"/usr/share/gtk-3.0/settings.ini"
	"/usr/share/gtk-4.0/settings.ini"
)

function verify_symlinks() {
	for symlink in "${symlinks[@]}"; do
		if [ ! -L "$symlink" ]; then
			return 1
		fi
	done
	return 0
}

function should_run() {
	has_packages rose-pine-gtk-theme-full || return "$RUN"
	has_packages xcursor-breeze || return "$RUN"
	has_packages gnome-backgrounds || return "$RUN"
	# verify_symlinks || return "$RUN"
	return "$DONE"
}

function task() {
	has_packages rose-pine-gtk-theme-full ||
		makepkg_task rose-pine-gtk-theme-full || return
	has_packages xcursor-breeze ||
		makepkg_task xcursor-breeze || return
	has_packages gnome-backgrounds ||
		sudo pacman -S --noconfirm gnome-backgrounds || return
	# TODO: fix this: we have not run stow yet. need to use ./files/home/...
	# sudo ln -sf "$HOME/.gtkrc-2.0" "/usr/share/gtk-2.0/gtkrc" || return
	# sudo ln -sf "$HOME/.config/gtk-3.0/settings.ini" \
	# 	"/usr/share/gtk-3.0/settings.ini" || return
	# sudo ln -sf "$HOME/.config/gtk-4.0/settings.ini" \
	# 	"/usr/share/gtk-4.0/settings.ini" || return
	return "$OK"
}
