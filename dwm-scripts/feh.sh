#!/bin/sh

set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        echo "feh does not exist"
        exit 1
    else
       	pkill feh
        exit 0
    fi
}
trap endsh EXIT

if ! command -v feh &> /dev/null
then
    endsh "notFound"
else
    feh --bg-scale /usr/share/dwm/detroitBecomeHumanBackground.png
fi


