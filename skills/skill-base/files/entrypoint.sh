#!/bin/sh
set -eu

if [ "$#" -eq 0 ]; then
  echo "No command specified." >&2
  exit 1
fi

tz="${TZ:-UTC}"
zoneinfo="/usr/share/zoneinfo/${tz}"
localtime="${HOME:-/home/ovos}/.localtime"
timezone_file="${HOME:-/home/ovos}/.timezone"

if [ -r "$zoneinfo" ]; then
  cp "$zoneinfo" "$localtime"
  printf '%s\n' "$tz" > "$timezone_file"
else
  echo "Warning: TZ '$tz' not found; using UTC." >&2
  cp "/usr/share/zoneinfo/UTC" "$localtime"
  printf '%s\n' "UTC" > "$timezone_file"
fi

exec "$@"
