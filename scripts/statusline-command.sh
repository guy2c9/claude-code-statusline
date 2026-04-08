#!/bin/sh
input=$(cat)

# --- Extract values ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
ctx_rem=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
five_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# --- Colour helpers ---
color_used() {
  pct=$1; label=$2
  if [ "$pct" -lt 30 ]; then
    printf '\033[32m%s: %s%%\033[0m' "$label" "$pct"
  elif [ "$pct" -lt 60 ]; then
    printf '\033[33m%s: %s%%\033[0m' "$label" "$pct"
  else
    printf '\033[31m%s: %s%%\033[0m' "$label" "$pct"
  fi
}

color_rem() {
  pct=$1; label=$2
  if [ "$pct" -gt 50 ]; then
    printf '\033[32m%s%% %s\033[0m' "$pct" "$label"
  elif [ "$pct" -gt 20 ]; then
    printf '\033[33m%s%% %s\033[0m' "$pct" "$label"
  else
    printf '\033[31m%s%% %s\033[0m' "$pct" "$label"
  fi
}

sep() { [ -n "$parts" ] && printf ' | '; }

parts=""

# --- Project name (cyan) ---
if [ -n "$cwd" ]; then
  repo_name=$(basename "$cwd")
  printf '\033[38;5;81m%s\033[0m' "$repo_name"
  parts="1"
fi

# --- Git branch (coral) ---
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    sep; printf '\033[38;5;215m%s\033[0m' "$branch"; parts="1"
  fi
fi

# --- MCP indicator (purple if any servers available) ---
mcp_found=0
# Check mcpServers in settings files
for f in "$HOME/.claude/settings.json" "$HOME/.claude/settings.local.json"; do
  [ -f "$f" ] && jq -e '.mcpServers | length > 0' "$f" >/dev/null 2>&1 && mcp_found=1 && break
done
# Check project-level settings
if [ "$mcp_found" -eq 0 ] && [ -n "$cwd" ]; then
  for f in "$cwd/.claude/settings.json" "$cwd/.claude/settings.local.json"; do
    [ -f "$f" ] && jq -e '.mcpServers | length > 0' "$f" >/dev/null 2>&1 && mcp_found=1 && break
  done
fi
# Check Claude.ai integrations (auth cache has entries when platform MCP servers are active)
if [ "$mcp_found" -eq 0 ] && [ -f "$HOME/.claude/mcp-needs-auth-cache.json" ]; then
  jq -e 'length > 0' "$HOME/.claude/mcp-needs-auth-cache.json" >/dev/null 2>&1 && mcp_found=1
fi
# Check installed plugins with MCP servers
if [ "$mcp_found" -eq 0 ]; then
  [ -n "$(find "$HOME/.claude/plugins/marketplaces" -name ".mcp.json" -maxdepth 5 2>/dev/null | head -1)" ] && mcp_found=1
fi
sep
if [ "$mcp_found" -eq 1 ]; then
  printf '\033[38;5;141mmcp\033[0m'
else
  printf '\033[31mmcp\033[0m'
fi
parts="1"

# --- Context remaining ---
if [ -n "$ctx_rem" ]; then
  ctx_pct=$(echo "$ctx_rem" | awk '{printf "%.0f", $1}')
  sep; color_rem "$ctx_pct" "left"; parts="1"
fi

# --- Rate limits (used) ---
if [ -n "$five_used" ]; then
  five_pct=$(echo "$five_used" | awk '{printf "%.0f", $1}')
  sep; color_used "$five_pct" "5h"; parts="1"
fi

if [ -n "$seven_used" ]; then
  seven_pct=$(echo "$seven_used" | awk '{printf "%.0f", $1}')
  sep; color_used "$seven_pct" "7d"; parts="1"
fi
