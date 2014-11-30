#!/bin/zsh

# $1: "up" or "down"

amixer contents -c 0 | grep "Headphone Surround Jack" -A 2 | tail -n1 | \
    grep -P -o "(?<==).*" | read is_headphone

echo $is_headphone >> /home/cosmicexplorer/file

if [ "echo $is_headphone | grep '^on'" != "" ]; then
    if [ "$1" = "up" ]; then
        amixer -c 0 set 'Headphone',1 5+ unmute > /dev/null
    else
        amixer -c 0 set 'Headphone',1 5- unmute > /dev/null
    fi
else                            # use master volume
    if [ "$1" = "up" ]; then
        amixer -c 0 set Master 5+ unmute > /dev/null
    else
        amixer -c 0 set Master 5- unmute > /dev/null
    fi
fi
