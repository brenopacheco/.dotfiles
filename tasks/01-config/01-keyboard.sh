#!/usr/bin/env bash

rule='ACTION=="bind", SUBSYSTEM=="hid", ENV{DISPLAY}=":0", RUN+="/usr/bin/su breno -c /opt/bin/keyboard.sh %p"'

function should_run() {
	test -e /etc/udev/rules.d/50-keyboard.rules &&
		test -e /opt/bin/keyboard.sh &&
		return $DONE || return $RUN
}

function task() {
	echo "$rule" | sudo tee /etc/udev/rules.d/50-keyboard.rules &&
		sudo mkdir -p /opt/bin &&
		sudo cp ./files/keyboard.sh /opt/bin/keyboard.sh &&
		sudo chmod +x /opt/bin/keyboard.sh &&
		return $OK
}
