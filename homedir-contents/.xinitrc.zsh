#!/bin/zsh

set -euxo pipefail

source "$HOME/.zsh/functions.zsh"

# Order system resources before user resources.
declare -rA x_resources=(
  [sysresources]='/etc/X11/xinit/.Xresources'
  [sysmodmap]='/etc/X11/xinit/.Xmodmap'
  [userresources]="$HOME/.Xresources"
  [usermodmap]="$HOME/.Xmodmap"
)

# Declare the directory to search for scripts in.
declare -r x_initrc_dir='/etc/X11/xinit/xinitrc.d'

function with_merged_resources {
  local -r command_name="$1"
  local -rA to_merge=( ${(kv)@:2} )
  for name file in ${(kv)to_merge[@]}; do
    echo -n "Merging $name from $file..."
    if [[ -f "$file" ]]; then
      "$command_name" "$file"
      echo 'success!'
    else
      echo 'file not found!'
    fi
  done | err
}

# Merge defaults.

function merge_xrdb {
  xrdb -merge "$1"
}

# See zshparam(1) and zshexpn(1) to understand this incantation. All it does is find the keys named
# "resources" with (I), then returns the key and value for those entries with (kv).
with_merged_resources merge_xrdb ${(kv)x_resources[(I)*resources]}

# Merge keymaps.
with_merged_resources xmodmap ${(kv)x_resources[(I)*modmap]}

# Source the global startup scripts.
find "$x_initrc_dir" -name '*.sh' \
  | while read source_script; do
      source "$source_script"
    done

# Apply the desired xrandr settings.
source "$HOME/.local.xinitrc"

setup-xrandr-monitors

set +euxo pipefail

exec openbox-session
