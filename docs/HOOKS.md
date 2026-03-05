# Git Hooks

**Purpose**: Document what runs where for Git hooks. Single source of truth for pre-commit.

---

## Pre-commit

| Location                        | Purpose                                                             |
| ------------------------------- | ------------------------------------------------------------------- |
| **config/git-hooks/pre-commit** | Git hook entry (invoked by Git on `git commit`).                    |
| **scripts/git/pre-commit.ps1**  | PowerShell script that runs the actual checks. Invoked by the hook. |

**Behavior**:

1. **Prettier (automatic)** — Runs `npm run format` so code is formatted before every commit. Re-stages any modified files so the commit includes formatted code.
2. **Large files** — Blocks commit if any staged file is >100MB.
3. **Merge conflict markers** — Blocks commit if conflict markers are present.
4. **Debug statements** — Warns if `console.log`/`debug`/`warn`/`error` found in staged JS/TS.
5. **Commit message** — Warns if message is very short or doesn’t follow conventional format.
6. **Linter** — Runs `npm run lint` (warnings only, non-blocking).

Repo root is resolved from the script location for worktree portability.

**Setup**: Ensure the hook is installed (e.g. copy or link `config/git-hooks/pre-commit` to `.git/hooks/pre-commit` so Git invokes it on commit).

**Platform**: The pre-commit hook invokes `powershell.exe` and is **Windows-oriented**. On non-Windows (e.g. WSL, CI), use `pwsh` if available or run `scripts/git/pre-commit.ps1` manually; document any CI override in your workflow.

**Manual quality check (no commit)**: Run `npm run quality` to format, check format, lint, and run unit tests in one command.

---

## Superpowers session-start hook (deprecated)

**Status: Deprecated (2026-02-27).** OpenClaw is gone; the session-start hook has been disabled locally. The Cursor **superpowers** plugin's SessionStart hook is disabled (hooks array emptied), and `session-start.sh` has been removed from the plugin cache.

| Legacy script                  | Purpose (archived)                              |
| ------------------------------ | ----------------------------------------------- |
| `session-start-disable.sh`     | No-op backup (no longer applied)                |
| `session-start-ao-hook.sh`     | AO backup (no longer applied)                   |
| `apply-session-start-hook.ps1` | Would copy a script to plugin; hook is disabled |

To fully remove superpowers behavior, uninstall the superpowers plugin in Cursor. If the plugin updates and restores its default hooks, the SessionStart hook may run again; re-disable via `.\scripts\cursor\apply-session-start-hook.ps1 -Mode disable` and clear the hooks array in `hooks/hooks.json` if needed.

---

_Last updated: 2026-02-27._
