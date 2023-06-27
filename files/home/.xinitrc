#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx

userresources=$HOME/.Xresources

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi
