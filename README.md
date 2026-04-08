# Claude Code Statusline

Custom status line for Claude Code showing project context, MCP status, and usage metrics with colour-coded indicators.

## What you get

A status line at the bottom of Claude Code showing:

```
agent-runtime | main | mcp | 82% left | 5h: 29% | 7d: 6%
```

| Segment | Description |
|---------|-------------|
| Project name | Current directory name (cyan) |
| Branch | Git branch name (coral) |
| mcp | MCP servers connected indicator (green) |
| % left | Context window remaining |
| 5h | 5-hour rolling rate limit used |
| 7d | 7-day rolling rate limit used |

### Colour coding

**Context remaining** — green > 50%, yellow 20–50%, red < 20%

**Rate limits (used)** — green < 30%, yellow 30–59%, red 60%+

## Requirements

- macOS
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)
- `jq` (usually pre-installed on macOS, or `brew install jq`)
- Claude.ai Pro or Max subscription (for rate limit metrics)

## Quick install with Claude Code

Paste this prompt into Claude Code and it will do the rest:

```
Clone https://github.com/guy2c9/claude-code-statusline and follow the README to set it up. Copy the script to ~/.claude/statusline-command.sh, make it executable, and add the statusLine config to ~/.claude/settings.json. Do not overwrite any existing settings — merge the statusLine block in.
```

Then restart Claude Code.

## Manual setup

### 1. Copy the script

```bash
cp scripts/statusline-command.sh ~/.claude/statusline-command.sh
chmod +x ~/.claude/statusline-command.sh
```

### 2. Add to settings

Add the following to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "sh ~/.claude/statusline-command.sh"
  }
}
```

### 3. Restart Claude Code

The status line will appear after your first API response in the session.

## Notes

- The project name and git branch appear immediately
- The `mcp` indicator shows when MCP servers are configured in settings (global or project-level)
- The `5h` and `7d` rate limit values only appear after the first API response and require a Pro/Max subscription
- Context window value appears once the session has at least one message
- Segments are hidden until their data becomes available — no "N/A" clutter

## Customisation

Edit `~/.claude/statusline-command.sh` to change:

- **Colour thresholds** — adjust values in the `color_used` and `color_rem` functions
- **Labels** — change `5h`, `7d`, `left` to whatever you prefer
- **Segments** — remove any section you don't need

## How it works

Claude Code pipes a JSON object containing session metrics to the status line command via stdin. The script:

1. Extracts project directory, context window, and rate limit data using `jq`
2. Detects git repo and branch via `git` commands
3. Checks for MCP server configuration in settings files
4. Applies ANSI colour codes based on thresholds
5. Outputs the formatted string with pipe-separated segments

## Licence

MIT
