#!/bin/sh

endsh() {
    exit 1
}

if ! command -v flameshot &> /dev/null
then
    endsh
else
    flameshot gui
    exit 0
fi


