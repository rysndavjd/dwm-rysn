#!/bin/bash

if [ -f /usr/libexec/polkit-gnome-authentication-agent-1 ] ; then
    exec /usr/libexec/polkit-gnome-authentication-agent-1
elif [ -f /usr/libexec/polkit-mate-authentication-agent-1 ]
    exec /usr/libexec/polkit-mate-authentication-agent-1
fi