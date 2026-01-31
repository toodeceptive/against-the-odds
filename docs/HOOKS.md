# Git Hooks

**Purpose**: Document what runs where for Git hooks. Single source of truth for pre-commit.

---

## Pre-commit

| Location | Purpose |
|----------|---------|
| **config/git-hooks/pre-commit** | Git hook entry (invoked by Git on `git commit`). |
| **scripts/git/pre-commit.ps1** | PowerShell script that runs the actual checks. Invoked by the hook. |

**Behavior**: The hook in `config/git-hooks/pre-commit` calls `scripts/git/pre-commit.ps1`. The script derives repo root from its location (`scripts/git/` → parent of parent = repo root) and runs lint/format or other checks from repo root.

**Setup**: Ensure the hook is installed (e.g. copy or link `config/git-hooks/pre-commit` to `.git/hooks/pre-commit` so Git invokes it on commit).

_Last updated: 2026-01-31._
