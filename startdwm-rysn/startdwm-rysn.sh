#!/bin/sh

unset SESSION_MANAGER

d=0
while true ; do
    [ -e "/tmp/.X$d-lock" -o -S "/tmp/.X11-unix/X$d" ] || break
    d=$(($d + 1))
done
defaultdisplay=":$d"
unset d

if [ "$display" = "" ]; then
    display=$defaultdisplay
fi

xinit ~/startdwm-rysn -- :1