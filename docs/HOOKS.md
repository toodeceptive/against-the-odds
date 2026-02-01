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

**Manual quality check (no commit)**: Run `npm run quality` to format, check format, lint, and run unit tests in one command.

---

_Last updated: 2026-02-01._
