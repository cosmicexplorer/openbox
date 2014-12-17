#!/bin/bash

# this is because just checking for equality to empty string wasn't working
if [ "$(synclient | grep TouchpadOff | grep 1 | wc -l)" -ne 1 ]; then
    echo "hey"
    synclient | grep TouchpadOff
    synclient TouchpadOff=1
else
    echo "ya"
    synclient | grep TouchpadOff
    synclient TouchpadOff=2
fi
