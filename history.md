# Claude Code Statusline — History

## Session 1 — 2026-04-08

### Goal

Add a status line to Claude Code showing remaining token and rate limit percentages.

### What was done

1. **Created `~/.claude/statusline-command.sh`** — shell script that reads Claude Code session metrics from stdin and outputs formatted remaining percentages

2. **Updated `~/.claude/settings.json`** — added `statusLine` block pointing to the script

3. **Three metrics configured:**
   - `5h` — 5-hour rolling rate limit remaining
   - `7d` — 7-day rolling rate limit remaining
   - `ctx` — context window remaining in current session

4. **Added colour coding:**
   - Green for 60%+ remaining
   - Yellow for 30–59% remaining
   - Red for under 30% remaining

5. **Added "remaining:" prefix** to the status line output

### Current output format

```
remaining: 5h: 97% | 7d: 85% | ctx: 88%
```

### Key files

| File | Purpose |
|------|---------|
| `~/.claude/statusline-command.sh` | Status line script |
| `~/.claude/settings.json` | Claude Code settings with statusLine config |

## Session 2 — 2026-04-08

### Goal

Switch from showing remaining percentages to showing used percentages, matching the native `/usage` command's presentation.

### What was done

1. **Flipped percentages** — now shows used % directly instead of calculating remaining (100 - used)

2. **Flipped colour thresholds** to match:
   - Green for < 30% used
   - Yellow for 30–59% used
   - Red for 60%+ used

3. **Changed prefix** from `remaining:` to `used:`

4. **Updated all three copies:**
   - `~/.claude/statusline-command.sh` (active)
   - `~/claude-code/statusline-command.sh` — different script (git info + context only), left unchanged
   - `scripts/statusline-command.sh` (this repo)

5. **Reviewed accuracy against native `/usage`** — confirmed the script reads the same data source (status line JSON from stdin). The 7d figure matched exactly; 5h had ±1% rounding difference.

### Current output format

```
used: 5h: 62% | 7d: 44% | ctx: 2%
```
