#!/bin/bash

if ! command -v xsetroot &> /dev/null
then
    exit 1
else
    while true; do 
        xsetroot -name "$(date +'%b %d, %a %I:%M')"
        sleep $(( 60 - $(date +%-S) ))
    done
fi


