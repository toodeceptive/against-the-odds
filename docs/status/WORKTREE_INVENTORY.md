# Worktree Inventory

**Purpose**: Single source of truth for actual worktrees not listed in .cursor/worktrees.json.

**Last updated**: 2026-02-07 (aligned with BRANCH_INVENTORY; cleanup optional per doc)

---

## Actual worktrees (from git worktree list)

| Path                                                    | Branch/HEAD                      | Commit   | Purpose                                                        |
| ------------------------------------------------------- | -------------------------------- | -------- | -------------------------------------------------------------- |
| `C:/Users/LegiT/against-the-odds`                       | main                             | (HEAD)   | Primary repo, main branch                                      |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/ewa` | detached HEAD                    | 505df09  | Cursor navigation worktree (may be temporary)                  |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/mhx` | handoff-doc-permissions-20260129 | b0a8f30  | Active worktree on feature branch (user visible)               |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/snq` | detached HEAD                    | 1c5ed2e  | Cursor navigation worktree (may be temporary)                  |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/uub` | detached HEAD                    | 16a8024  | Cursor navigation worktree (may be temporary)                  |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/opo` | cursor-agent-setup               | (branch) | Cursor agent setup; branch merged to main; repurpose or remove |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/qqa` | detached HEAD                    | 3011143  | Guru finalization / full system test; work merged to main      |

**Note**: worktrees ewa, snq, uub are detached HEAD and may be temporary; mhx is on a live feature branch. Optional cleanup: `git worktree remove <path>` for detached worktrees no longer in use (from main repo).

---

## Finalization cleanup (optional)

To reflect systemwide changes and leave only the primary worktree and any actively used worktrees:

1. **From primary repo** (`C:\Users\LegiT\against-the-odds`): run `git worktree list` to see all worktrees.
2. **Remove unused worktrees**: `git worktree remove "C:/Users/LegiT/.cursor/worktrees/against-the-odds/ewa"` (repeat for snq, uub, opo, qqa if no longer needed). Do not remove mhx if you still use handoff-doc-permissions branch.
3. **Temp files**: `.gitignore` already excludes `*.tmp`, `*.temp`, `.cache/`, `*.bak`; no repo-level temp files should be committed. Delete any local `*.tmp` or `*.log` in repo root if present.
4. **Branches**: Optional `git branch -d <branch>` for merged local branches (e.g. guru-finalization-20260206, cursor-agent-setup) after confirming merged to main.

---

## Setup instruction

Worktrees are managed by git; no additional action required. If extending worktrees.json, add an entry for each with path and setup command (e.g. ["npm install"]) as in primary worktree.

---

## Sign-off

Worktree inventory completed. All actual worktrees are now documented. Nothing is overlooked.
