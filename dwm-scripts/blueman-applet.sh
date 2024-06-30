#!/bin/sh

set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        exit 1
    else
       	pkill blueman-applet
        exit 0
    fi
}
trap endsh EXIT

if ! command -v blueman-applet &> /dev/null
then
    endsh "notFound"
else
    blueman-applet
fi


