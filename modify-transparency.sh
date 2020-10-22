#!/bin/sh

# See arch linux docs at https://wiki.archlinux.org/index.php/Xterm#Configuration!
transset-df --id "$(xdotool getwindowfocus)" "$@"
