#!/bin/bash

# Basically the gentoo-pipewire-launcher with all the extra bits and logging removed

if pgrep -u "${USER}" -x wireplumber\|pipewire\|pipewire-pulse ; then
    pkill -u "${USER}" -x wireplumber\|pipewire\|pipewire-pulse
    
    if command -v pidwait > /dev/null ; then
        pidwait -u "${USER}" -x wireplumber\|pipewire\|pipewire-pulse
    elif command -v pwait > /dev/null ; then
        pwait -u "${USER}" -x wireplumber\|pipewire\|pipewire-pulse
    fi
fi

pipewire &
if command -v pipewire-pulse > /dev/null ; then
    pipewire-pulse &
fi
sleep 1
exec wireplumber