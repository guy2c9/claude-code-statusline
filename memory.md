# Claude Code Statusline — Memory

## Project Overview

Custom Claude Code status line showing 6 segments: project name, git branch, MCP indicator, context window remaining, and 5h/7d rate limit usage — all ANSI colour-coded.

## Key Files

| File | Purpose |
|------|---------|
| `scripts/statusline-command.sh` | Shell script — reads JSON from stdin, outputs coloured status |
| `~/.claude/statusline-command.sh` | Installed copy of the script |
| `~/.claude/settings.json` | Claude Code settings with `statusLine` block |

## Dependencies

| Dependency | Purpose |
|------------|---------|
| `jq` | JSON parsing of session metrics and settings files |
| `git` | Branch detection |

## Architecture

- Claude Code pipes session metrics JSON to the script via stdin
- Script extracts workspace directory, context window remaining, and rate limit used percentages
- Git branch detected via `git rev-parse` using workspace directory
- MCP status detected by checking `mcpServers` in global and project-level settings files
- Segments are only shown when their data is available

## Status Line Segments

| Segment | Colour | Source |
|---------|--------|--------|
| Project name | Cyan (38;5;81) | `workspace.current_dir` basename |
| Git branch | Coral (38;5;215) | `git rev-parse --abbrev-ref HEAD` |
| MCP indicator | Purple (38;5;141) | `mcpServers` in settings files |
| Context remaining | Green >50%, Yellow 20–50%, Red <20% | `context_window.remaining_percentage` |
| 5h rate used | Green <30%, Yellow 30–59%, Red 60%+ | `rate_limits.five_hour.used_percentage` |
| 7d rate used | Green <30%, Yellow 30–59%, Red 60%+ | `rate_limits.seven_day.used_percentage` |

## Design Decisions

- Context shows remaining ("82% left") — more intuitive for "how much space do I have"
- Rate limits show used ("5h: 29%") — matches native `/usage` presentation
- MCP indicator checks settings files since MCP status is not exposed in the statusLine JSON
- Two colour helpers: `color_used` (low=good) for rate limits, `color_rem` (high=good) for context
- `--no-optional-locks` flag on git to avoid interfering with other git operations
- Segments hidden when data unavailable rather than showing "N/A"
- Use 256-colour mode (38;5;N) not high-intensity ANSI (90–97) — Claude Code status line doesn't render the latter

## Codex CLI

- Codex uses a built-in statusline with predefined items — no external script support
- Config: `tui.status_line` array in `~/.codex/config.toml` (TOML, not JSON)
- 17 available items including `current-dir`, `git-branch`, `context-remaining`, `five-hour-limit`, `weekly-limit`
- No MCP indicator, no custom colours, segments separated by ` · `
