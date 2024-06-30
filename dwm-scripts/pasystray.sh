#!/bin/sh

set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        exit 1
    else
       	pkill pasystray
        exit 0
    fi
}
trap endsh EXIT

if ! command -v pasystray &> /dev/null
then
    endsh "notFound"
else
    pasystray
fi


