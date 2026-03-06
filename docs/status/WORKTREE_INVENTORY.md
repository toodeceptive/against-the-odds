# Worktree Inventory

**Purpose**: Single source of truth for actual worktrees (from `git worktree list`).

**Last updated**: 2026-03-05 (aligned with current `git worktree list`; stale hal/hvf still documented)

---

## Actual worktrees (from git worktree list)

| Label       | Path                                                    | Branch/HEAD                      | Commit  | Purpose                                  |
| ----------- | ------------------------------------------------------- | -------------------------------- | ------- | ---------------------------------------- |
| **Primary** | `C:/Users/LegiT/against-the-odds`                       | main                             | 90b197b | Primary repo checkout in current session |
| **hkx**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/hkx` | pp/guru-closure-20260305         | c3d28d4 | Active Cursor worktree in this run       |
| **mhx**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/mhx` | handoff-doc-permissions-20260129 | b0a8f30 | Active worktree on feature branch (user) |
| **bjm**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/bjm` | (detached HEAD)                  | 6e73084 | Worktree                                 |
| **bri**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/bri` | (detached HEAD)                  | c26bfe3 | Worktree                                 |
| **cpd**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/cpd` | (detached HEAD)                  | 6e73084 | Worktree                                 |
| **ghd**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/ghd` | (detached HEAD)                  | eabaf83 | Worktree                                 |
| **igt**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/igt` | (detached HEAD)                  | 6e73084 | Worktree                                 |
| **ltt**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/ltt` | (detached HEAD)                  | ad98d32 | Worktree                                 |
| **olu**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/olu` | (detached HEAD)                  | cdcc0ae | Worktree                                 |
| **osd**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/osd` | (detached HEAD)                  | 6e73084 | Worktree                                 |

**Removed (historical)**: ewa, snq, uub were removed via `git worktree remove`; opo and qqa are not in current `git worktree list`. **Not in git worktree list (stale in Cursor/IDE)**: **hal**, **hvf** — if Cursor shows "Failed to apply worktree" or paths under `hal` or `hvf`, remove those workspace entries from Cursor.

**Important**: Commits to `main` must be made from the **primary** repo path (`C:/Users/LegiT/against-the-odds`). Commits to dedicated worktree feature branches (for example `pp/guru-closure-20260305` in `hkx`) are allowed from that active worktree. Git stores paths relative to the repo root (for example `docs/status/CONSOLIDATION_LOG.md`), not under worktree subfolders. If Source Control shows paths under stale/non-git worktrees (`hal`, `hvf`, or unknown entries not in `git worktree list`), close that workspace and reopen a valid repo/worktree root before committing.

---

## Usage

All commands run from **repo root**. Do not commit from worktrees without coordinating with main branch.

**Note**: `.cursor/worktrees.json` may not list mhx; this doc is the single source of truth for actual worktrees.
