# Worktree Inventory

**Purpose**: Single source of truth for actual worktrees (from `git worktree list`).

**Last updated**: 2026-02-07 (worktree cleanup: ewa, snq, uub removed; opo, qqa no longer worktrees; only primary + mhx remain)

---

## Actual worktrees (from git worktree list)

| Path                                                    | Branch/HEAD                      | Commit  | Purpose                                  |
| ------------------------------------------------------- | -------------------------------- | ------- | ---------------------------------------- |
| `C:/Users/LegiT/against-the-odds`                       | main                             | (HEAD)  | **Primary repo**, main branch            |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/mhx` | handoff-doc-permissions-20260129 | b0a8f30 | Active worktree on feature branch (user) |

**Removed (2026-02-07)**: ewa, snq, uub removed via `git worktree remove`. opo, qqa were not in worktree list (already removed or not present). Merged branches guru-finalization-20260206 and cursor-agent-setup deleted locally.

---

## Usage

All commands run from **repo root**. Do not commit from worktrees without coordinating with main branch.

**Note**: `.cursor/worktrees.json` may not list mhx; this doc is the single source of truth for actual worktrees.
