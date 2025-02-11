#!/bin/bash

config="desktop laptop server mac"

echo "Enter config to link to ($config)"
read -r chose

for num in $config ; do 
    if [ "$num" = "$chose" ] ; then
        ln -srf "config-$chose.h" config.h
    fi
done