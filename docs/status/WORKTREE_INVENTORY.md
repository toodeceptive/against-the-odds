# Worktree Inventory

**Purpose**: Single source of truth for actual worktrees (from `git worktree list`).

**Last updated**: 2026-02-27 (aligned with current `git worktree list`; stale hal/hvf still documented)

---

## Actual worktrees (from git worktree list)

| Label       | Path                                                    | Branch/HEAD                      | Commit  | Purpose                                  |
| ----------- | ------------------------------------------------------- | -------------------------------- | ------- | ---------------------------------------- |
| **Primary** | `C:/Users/LegiT/against-the-odds`                       | main                             | 3f25a20 | Primary repo checkout in current session |
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

**Important**: All commits to main (including CONSOLIDATION_LOG and worktree-doc fixes) must be made from the **primary** repo path only (`C:/Users/LegiT/against-the-odds`). Git stores paths relative to the repo root (e.g. `docs/status/CONSOLIDATION_LOG.md`), not under any worktree subfolder. **Before committing**: If your diff or Source Control shows a path containing any worktree name (e.g. `hal`, `hvf`, `jxj`, `mhx`) or any path under `.cursor/worktrees/against-the-odds/`, you are in the wrong workspace; committing from here would violate the policy. Do **not** commit. Close that root, open **only** the primary repo (`C:/Users/LegiT/against-the-odds`) as the workspace, then stage and commit from there so the policy is satisfied.

---

## Usage

All commands run from **repo root**. Do not commit from worktrees without coordinating with main branch.

**Note**: `.cursor/worktrees.json` may not list mhx; this doc is the single source of truth for actual worktrees.
