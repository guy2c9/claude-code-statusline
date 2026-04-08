# Claude Code Statusline — Memory

## Project Overview

Custom Claude Code status line showing project context, MCP status, and usage metrics with ANSI colour-coded indicators.

## Key Files

| File | Purpose |
|------|---------|
| `~/.claude/statusline-command.sh` | Shell script — reads JSON from stdin, outputs coloured status |
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
- MCP status detected by checking `mcpServers` in global and project-level settings files (not in JSON input)
- Segments are only shown when their data is available

## Design Decisions

- Combined project context (name, branch, MCP) with usage metrics in a single line
- Context shows remaining ("82% left") — more intuitive for "how much space do I have"
- Rate limits show used ("5h: 29%") — matches native `/usage` presentation
- MCP indicator checks settings files since MCP status is not exposed in the statusLine JSON
- Segments hidden when data unavailable rather than showing "N/A"
