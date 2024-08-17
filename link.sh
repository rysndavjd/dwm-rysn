#!/bin/bash

echo "Enter config to link to (desktop, server, laptop)"
read config

if [[ $config == "desktop" ]] ; then
    echo "Config chosen is desktop."
    ln -sr config-desktop.h config.h
    exit 0
elif [[ $config == "server" ]] ; then
    echo "Config chosen is desktop."
    ln -sr config-server.h config.h
    exit 0
elif [[ $config == "laptop" ]] ; then
    echo "Config chosen is desktop."
    ln -sr config-laptop.h config.h
    exit 0
fi