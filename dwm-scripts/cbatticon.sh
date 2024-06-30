#!/bin/sh

set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        exit 1
    else
       	pkill cbatticon
        exit 0
    fi
}
trap endsh EXIT

if ! command -v cbatticon &> /dev/null
then
    endsh "notFound"
else
    cbatticon
fi


