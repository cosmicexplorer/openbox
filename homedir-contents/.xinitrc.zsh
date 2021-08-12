#!/bin/zsh

set -euxo pipefail

source "${ZSH_DIR}/functions.zsh"
# Note these very specific files for tool integrations.
source "${ZSH_DIR}/gpg.zsh"
source "${ZSH_DIR}/ssh.zsh"
source "${ZSH_DIR}/term.zsh"
source "${ZSH_DIR}/x.zsh"

# Declare the directory to search for scripts in.
declare -r x_initrc_dir='/etc/X11/xinit/xinitrc.d'

# Order system resources before user resources.
declare -rA x_resources=(
  [sysresources]='/etc/X11/xinit/.Xresources'
  [sysmodmap]='/etc/X11/xinit/.Xmodmap'
  [userresources]="$HOME/.Xresources"
  [usermodmap]="$HOME/.Xmodmap"
)

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
  done | spew
}

# Merge defaults.
function merge_xrdb {
  xrdb -merge "$1"
}

# NB: Usually run this after checking that [[ "$SHLVL" -le 1 ]].
function summon-the-daemon {
  # TODO: we may wish to load the module itself, but not execute any commands with it, allowing the
  # user to do that later. A simple way to do that would be to have a marker in the file or next to
  # the file saying whether it should execute some methods. Just brainstorming!
  err "summoning ${1}..."
  "${@:2}"
}

function summon-all-daemons {
  summon-the-daemon 'ssh-agent' setup-ssh-agent-idempotent
  summon-the-daemon 'gpg-agent' setup-gpg-agent-idempotent
  summon-the-daemon 'xrandr' setup-xrandr-monitors
  summon-the-daemon 'emacs' emacs &!
  summon-the-daemon 'firefox' firefox-nightly &!
  summon-the-daemon 'ibus' ibus-daemon -drx
}

### Load X resources!
# See zshparam(1) and zshexpn(1) to understand this incantation. All it does is find the keys named
# "resources" with (I), then returns the key and value for those entries with (kv).
with_merged_resources merge_xrdb ${(kv)x_resources[(I)*resources]}

# Merge keymaps.
with_merged_resources xmodmap ${(kv)x_resources[(I)*modmap]}

### Source the global startup scripts.
find "$x_initrc_dir" -name '*.sh' \
  | while read source_script; do
      source "$source_script"
    done

# Apply the desired xrandr settings.
source "$HOME/.local.xinitrc"

### Before everything else, make sure we summon the daemons for strength.
summon-all-daemons

### BEGIN THE SESSION
exec openbox-session
