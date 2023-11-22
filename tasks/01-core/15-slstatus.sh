#!/usr/bin/env bash

function should_run() {
	local SHA
	has_packages slstatus-fork || return "$RUN"
	SHA=$(curl -s "https://api.github.com/repos/brenopacheco/slstatus-fork/commits" | jq -r '.[0].sha')
	SHA=$(echo "$SHA" | cut -c1-7)
	MATCHES=$(pacman -Q --info slstatus-fork | grep -c "$SHA")
	[[ "$MATCHES" -gt 0 ]] && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task slstatus-fork && return "$OK"
}

# How to change the network interface name
#
# $ ip link
# 2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
#     link/ether 58:47:ca:70:5e:74 brd ff:ff:ff:ff:ff:ff
#     altname enp2s0
#
# $ vim /etc/udev/rules.d/10-ethernet.rules
# SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="58:47:ca:70:5e:74", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eno1"
