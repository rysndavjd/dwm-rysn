#!/bin/sh

set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        echo "pasystray does not exist"
        exit 1
    else
	echo "killed pasystray"
       	pkill pasystray
    fi
}
trap endsh EXIT

if ! command -v pasystray &> /dev/null
then
    endsh "notFound"
else
    echo "started pasystray"
    pasystray
fi


