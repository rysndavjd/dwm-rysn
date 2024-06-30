#!/bin/sh

set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        exit 1
    else
       	pkill /usr/libexec/polkit-gnome-authentication-agent-1
        exit 0
    fi
}
trap endsh EXIT

if ! hash /usr/libexec/polkit-gnome-authentication-agent-1 &> /dev/null
then
    endsh "notFound"
else
    /usr/libexec/polkit-gnome-authentication-agent-1
fi


