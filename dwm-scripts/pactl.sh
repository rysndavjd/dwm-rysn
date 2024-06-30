#!/bin/sh

endsh() {
    if [[ "$1" == "notFound" ]]
    then
        exit 1
    fi
}

if ! command -v pactl &> /dev/null
then
    endsh "notFound"
else
    if [[ "$1" == "inc" ]]
    then
        pactl -- set-sink-volume 0 +10%
        exit 0
    elif [[ "$1" == "dec" ]]
    then
        pactl -- set-sink-volume 0 -10%
        exit 0
    fi
fi


