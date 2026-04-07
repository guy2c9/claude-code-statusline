#!/bin/sh
input=$(cat)

five_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Color based on remaining %: green >=60, yellow 30-59, red <30
colorize() {
  rem=$1
  label=$2
  if [ "$rem" -ge 60 ]; then
    printf '\033[32m%s: %s%%\033[0m' "$label" "$rem"
  elif [ "$rem" -ge 30 ]; then
    printf '\033[33m%s: %s%%\033[0m' "$label" "$rem"
  else
    printf '\033[31m%s: %s%%\033[0m' "$label" "$rem"
  fi
}

parts=""

if [ -n "$five_used" ]; then
  five_rem=$(echo "$five_used" | awk '{printf "%.0f", 100 - $1}')
  parts=$(colorize "$five_rem" "5h")
fi

if [ -n "$seven_used" ]; then
  seven_rem=$(echo "$seven_used" | awk '{printf "%.0f", 100 - $1}')
  [ -n "$parts" ] && parts="$parts | "
  parts="${parts}$(colorize "$seven_rem" "7d")"
fi

if [ -n "$ctx_used" ]; then
  ctx_rem=$(echo "$ctx_used" | awk '{printf "%.0f", 100 - $1}')
  [ -n "$parts" ] && parts="$parts | "
  parts="${parts}$(colorize "$ctx_rem" "ctx")"
fi

[ -n "$parts" ] && printf 'remaining: %s' "$parts"
