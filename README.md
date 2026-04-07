# Claude Code Statusline

Custom status line for Claude Code showing remaining token and rate limit percentages with colour-coded indicators.

## What you get

A status line at the bottom of Claude Code showing:

```
remaining: 5h: 97% | 7d: 85% | ctx: 88%
```

| Metric | Description |
|--------|-------------|
| 5h | 5-hour rolling rate limit remaining |
| 7d | 7-day rolling rate limit remaining |
| ctx | Context window remaining in current session |

### Colour coding

| Remaining | Colour |
|-----------|--------|
| 60%+ | Green |
| 30–59% | Yellow |
| < 30% | Red |

## Requirements

- macOS
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)
- `jq` (usually pre-installed on macOS, or `brew install jq`)
- Claude.ai Pro or Max subscription (for rate limit metrics)

## Setup

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

- **Colour thresholds** — adjust the `60` and `30` values in the `colorize` function
- **Labels** — change `5h`, `7d`, `ctx` to whatever you prefer
- **Prefix** — change `remaining:` to any label

## How it works

Claude Code pipes a JSON object containing session metrics to the status line command via stdin. The script:

1. Extracts `rate_limits.five_hour.used_percentage`, `rate_limits.seven_day.used_percentage`, and `context_window.used_percentage` using `jq`
2. Calculates the remaining percentage (100 minus used)
3. Applies ANSI colour codes based on thresholds
4. Outputs the formatted string

## Licence

MIT
