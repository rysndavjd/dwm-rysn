#!/bin/bash

d=0
while true ; do
    [ -e "/tmp/.X$d-lock" -o -S "/tmp/.X11-unix/X$d" ] || break
    d=$(($d + 1))
done
display=":$d"
unset d

xinit ~/startdwm-rysn -- :1