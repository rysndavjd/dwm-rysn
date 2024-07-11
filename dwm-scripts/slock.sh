#!/bin/sh

endsh() {
    if [[ "$1" == "notFound" ]]
    then
        exit 1
    fi
}
trap endsh EXIT

if ! command -v slock &> /dev/null
then
    endsh "notFound"
else
    slock
    exit 0
fi