packages=(
	"lua"   # Lua 5.4
	"lua53" # Lua 5.3
	"lua52" # Lua 5.2
	"lua51" # Lua 5.1
	"luajit"
)

function should_run() {
	has_packages $packages && return $DONE || return $RUN
}

function task() {
	sudo pacman -S --noconfirm ${packages[*]} && return $OK
}
