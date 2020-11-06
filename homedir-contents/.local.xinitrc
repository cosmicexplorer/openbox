#!/bin/zsh

source "$HOME/.zsh/functions.zsh"

function get-connected-displays {
  xrandr --current | grep -P '^[^[:space:]]+\sconnected'
}

function extract-display-name {
  sed -re 's#^([^[:space:]]+).*$#\1#g'
}

function xrandr-place-below {
  local -r canonical_screen="$1"
  local -r external_monitor="$2"
  xrandr \
    --output "$canonical_screen" \
    --below "$external_monitor"
}

function setup-xrandr-monitors {
  local -ra connected_displays=( $(get-connected-displays | extract-display-name) )

  case "${#connected_displays[@]}" in
    0)
      printf '%s\n' 'No connected displays found:' ${connected_displays[@]} \
        | die
      ;;
    1)
      # This is the laptop case. Do nothing.
      echo "xrandr says we only have one screen available!" \
        | err
      ;;
    2)
      xrandr-place-below ${connected_displays[@]}
      echo "Succeeded in moving the second display above, and promoting it to be the primary!" \
        | err
      ;;
  esac
}

