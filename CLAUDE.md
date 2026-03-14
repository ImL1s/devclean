# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Bash script that safely cleans up development environments. Supports macOS and Linux. Four modes: safe (orphans only), `--deep` (heavy daemons), `--optimize` (IDE settings), `--disk` (caches and build artifacts).

## Development Commands

```bash
./devclean          # Run safe orphan cleanup
./devclean --deep     # Aggressive cleanup (Gradle, Flutter daemon, simulators, etc.)
./devclean --optimize # Disable crash reporters, clean Crashpad dumps, disable background agents
./devclean --disk     # Clean development caches and build artifacts
./install.sh          # Install to ~/.local/bin/devclean
bash -n devclean    # Syntax check
shellcheck devclean # Static lint (recommended)
```

## Architecture

Single-file script (`devclean`) with this flow:

1. **Argument parsing** — Supports `--deep`, `--optimize`, `--disk`, `--dry-run`, `--help`; flags are combinable
2. **OS detection** — `uname -s` to distinguish Darwin/Linux
3. **Pattern matching** — `ORPHAN_PATTERNS` array defines regex patterns for targetable processes
4. **Safe cleanup** — Finds processes matching patterns with `PPID=1`, plus orphaned `adb logcat`; kills via `kill_and_report()`
5. **Deep cleanup** (`--deep`) — Kills non-orphaned heavy daemons (Kotlin LSP, Gradle, FVM, Antigravity LSP, Logi Options+, Ruby/Fastlane); iOS Simulators via `xcrun simctl shutdown all`
6. **Optimize** (`--optimize`) — Patches VS Code fork `argv.json` to disable crash reporters; cleans Crashpad dumps; disables SMAppService agents (ChatGPTHelper, FigmaAgent)
7. **Disk cleanup** (`--disk`) — Cleans Xcode DerivedData, iOS DeviceSupport, Gradle/CocoaPods/npm/pub caches, FVM incomplete versions, Gemini recordings, project build artifacts

Key functions:
- `report_stats(PIDS, LABEL)` — Calculates memory usage via `ps -o rss=` and prints report
- `graceful_kill(PIDS)` — SIGTERM → wait 2s → SIGKILL fallback for stubborn processes; respects `--dry-run`
- `kill_and_report(PIDS, LABEL)` — Combines `report_stats` + `graceful_kill`
- `cleanup_by_name(LABEL, PATTERN)` — Uses `pgrep -f` to find and kill matching processes
- `cleanup_orphaned_by_name(LABEL, PATTERN)` — Same but restricted to PPID=1 (safe for tools like xcodebuild that may be actively in use)

## Coding Conventions

- Bash with `#!/bin/bash`; uppercase for globals (`ORPHAN_PATTERNS`, `REGEX_PATTERN`), `snake_case` for functions
- `ORPHAN_PATTERNS` array is the primary extension point — add new patterns there when supporting new tools
- Comments in Chinese (繁體中文) are normal for this project
- Commit style: `feat:`, `refactor:`, `style:` prefixed, imperative, single logical change
