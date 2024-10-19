#!/bin/bash
# @file spin.sh
# @example: spin.sh sleep 3
#
# @description Add a spinner to any long running `<command>`
# @arg $1 string Long running command the spinner should wait for
#
# spinner characters

# @description Loops spinner until `pid` exits
# @arg $1 A pid for a long running command
spin() {
  trap 'tput cnorm; exit' INT TERM # Ensure cursor is reset on exit
  readonly spin_str='⬝ ⬞ ▫ ◻ 󰝣 ◻ ▫ ⬞ ⬝'
  local pid="$1"
  local delay=0.1
  local spin_chars=($spin_str)

  local i=0

  while kill -0 "$pid" 2>/dev/null; do
    printf "\r%s " "${spin_chars[$i]}"
    i=$(( (i + 1) % ${#spin_chars[@]} ))
    sleep "$delay"
  done
  printf "\r"
}

exec "$@" &
tput civis # hide the cursor
spin $!
tput cnorm # show the cursor
