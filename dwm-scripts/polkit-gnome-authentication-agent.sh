#!/bin/bash

if ! command -v ${polkitbin} > /dev/null 2>&1; then
    exit 1
elif [ -f /etc/arch-release ]; then
    polkitbin="/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
    $polkitbin
elif [ -f /etc/gentoo-release ]; then
    polkitbin="/usr/libexec/polkit-gnome-authentication-agent-1"
    $polkitbin
else
    exit 1
fi


