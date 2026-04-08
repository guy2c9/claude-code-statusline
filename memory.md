# Claude Code Statusline — Memory

## Project Overview

Custom Claude Code status line showing used token and rate limit percentages with ANSI colour-coded indicators (green/yellow/red based on thresholds).

## Key Files

| File | Purpose |
|------|---------|
| `~/.claude/statusline-command.sh` | Shell script — reads JSON from stdin, outputs coloured status |
| `~/.claude/settings.json` | Claude Code settings with `statusLine` block |

## Dependencies

| Dependency | Purpose |
|------------|---------|
| `jq` | JSON parsing of session metrics |

## Architecture

- Claude Code pipes session metrics JSON to the script via stdin
- Script extracts three fields: `rate_limits.five_hour.used_percentage`, `rate_limits.seven_day.used_percentage`, `context_window.used_percentage`
- Rounds used percentage and applies ANSI colour codes
- Segments are only shown when their data is available (rate limits appear after first API response)

## Design Decisions

- Used a standalone shell script rather than inline jq in settings.json for readability and maintainability
- Colour thresholds: green < 30% used, yellow 30–59% used, red >= 60% used
- Segments hidden when data unavailable rather than showing "N/A"
- Prefix "used:" to match native `/usage` presentation
