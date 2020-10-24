#!/bin/zsh

readonly laptop_output='eDP-1'

function current-brightness {
  xrandr --query --verbose \
    | sed -rne '/Brightness:/ s#^.*Brightness: (.*)$#\1#gp' \
    | head -n1
}

case "$1" in
  max)
    readonly target='1'
    ;;
  min)
    readonly target='0'
    ;;
  inc)
    readonly current="$(current-brightness)"
    readonly arg="$2"
    readonly attempted="$(($current + $arg))"
    if [[ "$attempted" -ge '1' ]]; then
      readonly target='1'
    else
      readonly target="$attempted"
    fi
    ;;
  dec)
    readonly current="$(current-brightness)"
    readonly arg="$2"
    readonly attempted="$(($current - $arg))"
    if [[ "$attempted" -le 0 ]]; then
      readonly target='0'
    else
      readonly target="$attempted"
    fi
    ;;
  *)
    echo "Unrecognized argument: $1" >&2
    exit 1
    ;;
esac

xrandr --output "$laptop_output" --brightness "$target"
