#!/bin/sh
input=$(cat)

five_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Colour based on used %: green <30, yellow 30-59, red >=60
colorize() {
  pct=$1
  label=$2
  if [ "$pct" -lt 30 ]; then
    printf '\033[32m%s: %s%%\033[0m' "$label" "$pct"
  elif [ "$pct" -lt 60 ]; then
    printf '\033[33m%s: %s%%\033[0m' "$label" "$pct"
  else
    printf '\033[31m%s: %s%%\033[0m' "$label" "$pct"
  fi
}

parts=""

if [ -n "$five_used" ]; then
  five_pct=$(echo "$five_used" | awk '{printf "%.0f", $1}')
  parts=$(colorize "$five_pct" "5h")
fi

if [ -n "$seven_used" ]; then
  seven_pct=$(echo "$seven_used" | awk '{printf "%.0f", $1}')
  [ -n "$parts" ] && parts="$parts | "
  parts="${parts}$(colorize "$seven_pct" "7d")"
fi

if [ -n "$ctx_used" ]; then
  ctx_pct=$(echo "$ctx_used" | awk '{printf "%.0f", $1}')
  [ -n "$parts" ] && parts="$parts | "
  parts="${parts}$(colorize "$ctx_pct" "ctx")"
fi

[ -n "$parts" ] && printf 'used: %s' "$parts"
