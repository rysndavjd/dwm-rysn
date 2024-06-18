#!/bin/sh

set -e
endsh() {
    if [[ "$1" == "notFound" ]]
    then
        echo "/usr/libexec/polkit-gnome-authentication-agent-1 does not exist"
        exit 1
    else
	echo "killed /usr/libexec/polkit-gnome-authentication-agent-1"
       	pkill /usr/libexec/polkit-gnome-authentication-agent-1
    fi
}
trap endsh EXIT

if ! hash /usr/libexec/polkit-gnome-authentication-agent-1 &> /dev/null
then
    endsh "notFound"
else
    echo "started /usr/libexec/polkit-gnome-authentication-agent-1"
    /usr/libexec/polkit-gnome-authentication-agent-1
fi


