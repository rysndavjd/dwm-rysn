#!/bin/bash

tmp="/usr/share/dwm-rysn/fehtmp"
images=("detroitBecomeHuman1.png" "HorizonForbiddenWest1.png" "HorizonForbiddenWest2.png" "HorizonForbiddenWest3.png")

if ! command -v feh &> /dev/null
then
    exit 1
else
    if [ ! -f $tmp ] ; then
        touch $tmp
        echo "-1" > $tmp
    fi
    current=$(<"$tmp")
    next=$(( (current + 1) % ${#images[@]} ))
    echo "$next" > "$tmp"
    feh --bg-scale --no-fehbg "/usr/share/dwm-rysn/wallpapers/${images["$next"]}"
fi


