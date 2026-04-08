# Claude Code Statusline

Custom status line for Claude Code with colour-coded project info, context window, and rate limit indicators.

## What you get

A status line at the bottom of Claude Code:

```
agent-runtime | main | mcp | 82% left | 5h: 29% | 7d: 6%
```

| Segment | Description | Colour |
|---------|-------------|--------|
| Project name | Current directory name | Cyan |
| Git branch | Current branch (if in a repo) | Coral |
| MCP | Shown if MCP servers are configured | Green |
| `% left` | Context window remaining | Green >50%, Yellow 20–50%, Red <20% |
| `5h` | 5-hour rate limit used | Green <30%, Yellow 30–59%, Red 60%+ |
| `7d` | 7-day rate limit used | Green <30%, Yellow 30–59%, Red 60%+ |

Segments are hidden until their data is available — no "N/A" clutter.

## Requirements

- macOS or Linux
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)
- `jq` (usually pre-installed on macOS, or `brew install jq`)
- `git` (for branch detection)
- Claude.ai Pro or Max subscription (for rate limit metrics)

## Quick install

Paste this into Claude Code:

```
please install this statusline for me: https://github.com/guy2c9/claude-code-statusline
```

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

## Customisation

Edit `~/.claude/statusline-command.sh` to change:

- **Colour thresholds** — adjust values in `color_used` and `color_rem` functions
- **Labels** — change `5h`, `7d`, `left` to whatever you prefer
- **Segments** — remove or reorder any segment block

## How it works

Claude Code pipes a JSON object containing session metrics to the status line command via stdin. The script:

1. Extracts workspace, context window, and rate limit data using `jq`
2. Detects git branch and MCP server configuration
3. Applies ANSI colour codes based on thresholds
4. Outputs pipe-separated formatted segments

## Licence

MIT
