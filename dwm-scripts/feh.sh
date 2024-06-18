#!/bin/sh

set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        echo "feh does not exist"
        exit 1
    else
	echo "killed feh"
       	pkill feh
    fi
}
trap endsh EXIT

if ! command -v feh &> /dev/null
then
    endsh "notFound"
else
    echo "started feh"
    feh --bg-scale /home/rysndavjd/.dwm/detroitBecomeHumanBackground.png
fi


