#!/bin/sh
#name=dual
#desc=ASUS + HP
#
# This is a bit of a hack to get the second monitor to have the correct resolution
# without warping the cursor between the two monitors. It relies on the
# /etc/X11/xorg.conf.d/10-monitor.conf setting DisplayPort-0 resulution to
# 1920x1080 initially. This script will then set the resolution to 2560x1440
# after xorg has started.

xrandr --output HDMI-A-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DisplayPort-0 --mode 2560x1440 --pos 1920x0 --rotate normal
