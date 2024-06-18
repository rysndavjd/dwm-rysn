#!/bin/bash


set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        echo "xsetroot does not exist"
        exit 1
    else
        echo "killed xsetroot"
        pkill xsetroot
    fi
}
trap endsh EXIT

if ! command -v xsetroot &> /dev/null
then
    endsh "notFound"
else
    echo "started xsetroot"
    while true; do 
        xsetroot -name "$(date +'%b %d, %a %I:%M')"
        sleep $(( 60 - $(date +%-S) ))
    done
fi


