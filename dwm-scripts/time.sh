#!/bin/bash


set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        exit 1
    else
        pkill xsetroot
        exit 0
    fi
}
trap endsh EXIT

if ! command -v xsetroot &> /dev/null
then
    endsh "notFound"
else
    while true; do 
        xsetroot -name "$(date +'%b %d, %a %I:%M')"
        sleep $(( 60 - $(date +%-S) ))
    done
fi


