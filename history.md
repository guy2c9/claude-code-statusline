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
2. **Flipped colour thresholds** — green <30% used, yellow 30–59%, red 60%+
3. **Changed prefix** from `remaining:` to `used:`
4. **Reviewed accuracy against native `/usage`** — confirmed the script reads the same data source

### Current output format

```
used: 5h: 62% | 7d: 44% | ctx: 2%
```

## Session 3 — 2026-04-08

### Goal

Add project name, git branch, and MCP indicator to the status line for richer context.

### What was done

1. **Added project name** (cyan) — extracted from `workspace.current_dir` in the JSON input
2. **Added git branch** (coral) — detected via `git rev-parse` using the workspace directory
3. **Added MCP indicator** (green) — checks for `mcpServers` in global and project-level settings files
4. **Changed context to show remaining** — `82% left` (more intuitive for context)
5. **Kept rate limits as used** — matches native `/usage`
6. **Two colour helper functions** — `color_used` for rate limits, `color_rem` for context remaining

### Current output format

```
agent-runtime | main | mcp | 82% left | 5h: 29% | 7d: 6%
```

### Colour thresholds

| Segment | Green | Yellow | Red |
|---------|-------|--------|-----|
| Context remaining | >50% | 20–50% | <20% |
| Rate limit used | <30% | 30–59% | 60%+ |

## Session 4 — 2026-04-08

### Goal

Install latest statusline script on a second machine from GitHub repo.

### What was done

1. **Updated `~/.claude/statusline-command.sh`** — replaced old Session 1 script with latest Session 3 version (6 segments)
2. **Settings already configured** — `statusLine` block in `~/.claude/settings.json` was already present
3. **Updated repo files** — synced history.md, memory.md, and README.md to reflect current state
