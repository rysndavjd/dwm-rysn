#!/bin/bash

config="desktop laptop server"

echo "Enter config to link to ($config)"
read chose

for num in $config ; do 
    if [ "$num" = "$chose" ] ; then
        ln -srf config-$chose.h config.h
    fi
done