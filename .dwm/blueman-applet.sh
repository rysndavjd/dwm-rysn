#!/bin/sh

set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        echo "blueman-applet does not exist"
        exit 1
    else
	echo "killed blueman-applet"
       	pkill blueman-applet
    fi
}
trap endsh EXIT

if ! command -v blueman-applet &> /dev/null
then
    endsh "notFound"
else
    echo "started blueman-applet"
    blueman-applet
fi


