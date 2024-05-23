#!/bin/sh
echo -ne '\033c\033]0;Dodge The Creeps\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/DodgeTheCreeps.x86_64" "$@"
