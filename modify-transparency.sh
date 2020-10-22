#!/bin/sh

transset-df --id "$(xdotool getwindowfocus)" "$@"
