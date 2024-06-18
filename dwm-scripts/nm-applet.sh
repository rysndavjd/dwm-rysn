#!/bin/sh

set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        echo "nm-applet does not exist"
        exit 1
    else
	echo "killed nm-applet"
       	pkill nm-applet
    fi
}
trap endsh EXIT

if ! command -v nm-applet &> /dev/null
then
    endsh "notFound"
else
    echo "started nm-applet"
    nm-applet
fi


