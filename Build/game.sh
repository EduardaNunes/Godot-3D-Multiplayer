#!/bin/sh
printf '\033c\033]0;%s\a' DCC148 - Multiplayer 3D
base_path="$(dirname "$(realpath "$0")")"
"$base_path/game.x86_64" "$@"
