# Worktree Inventory

**Purpose**: Single source of truth for actual worktrees not listed in .cursor/worktrees.json.

**Last updated**: 2026-01-31 (executing final plan)

---

## Actual worktrees (from git worktree list)

| Path                                                    | Branch/HEAD                                | Commit         | Purpose                                                |
| ------------------------------------------------------- | ------------------------------------------ | -------------- | ------------------------------------------------------ |
| `C:/Users/LegiT/against-the-odds`                       | main                                       | 505df09        | Primary repo, main branch                              |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/ewa` | detached HEAD                              | 505df09        | Cursor navigation worktree (may be temporary)         |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/mhx` | handoff-doc-permissions-20260129           | b0a8f30        | Active worktree on feature branch (user visible)      |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/snq` | detached HEAD                              | 1c5ed2e        | Cursor navigation worktree (may be temporary)         |

**Note**: worktrees ewa and snq are detached HEAD and may be temporary; mhx is on a live feature branch.

---

## Setup instruction

Worktrees are managed by git; no additional action required. If extending worktrees.json, add an entry for each with path and setup command (e.g. ["npm install"]) as in primary worktree.

---

## Sign-off

Worktree inventory completed. All actual worktrees are now documented. Nothing is overlooked.