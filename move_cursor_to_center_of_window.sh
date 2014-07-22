#!/bin/zsh
eval "$(xdotool getwindowfocus getwindowgeometry --shell)"
xdotool getwindowfocus mousemove --window %1 $(echo "scale=2;$WIDTH / 2" | bc) $(echo "scale=2;$HEIGHT / 2" | bc)
