# Claude Code Statusline

Custom status line for Claude Code showing used token and rate limit percentages with colour-coded indicators.

## What you get

A status line at the bottom of Claude Code showing:

```
used: 5h: 62% | 7d: 44% | ctx: 2%
```

| Metric | Description |
|--------|-------------|
| 5h | 5-hour rolling rate limit used |
| 7d | 7-day rolling rate limit used |
| ctx | Context window used in current session |

### Colour coding

| Used | Colour |
|------|--------|
| < 30% | Green |
| 30–59% | Yellow |
| 60%+ | Red |

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

- The `5h` and `7d` rate limit values only appear after the first API response and require a Pro/Max subscription
- The `ctx` context window value appears once the session has at least one message
- Segments are hidden until their data becomes available — no "N/A" clutter

## Customisation

Edit `~/.claude/statusline-command.sh` to change:

- **Colour thresholds** — adjust the `30` and `60` values in the `colorize` function
- **Labels** — change `5h`, `7d`, `ctx` to whatever you prefer
- **Prefix** — change `used:` to any label

## How it works

Claude Code pipes a JSON object containing session metrics to the status line command via stdin. The script:

1. Extracts `rate_limits.five_hour.used_percentage`, `rate_limits.seven_day.used_percentage`, and `context_window.used_percentage` using `jq`
2. Rounds the used percentage to the nearest integer
3. Applies ANSI colour codes based on thresholds
4. Outputs the formatted string

## Licence

MIT
