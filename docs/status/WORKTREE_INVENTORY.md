# Worktree Inventory

**Purpose**: Single source of truth for actual worktrees (from `git worktree list`).

**Last updated**: 2026-02-07 (aligned with `git worktree list`: 8 worktrees including jxj; stale hal/hvf documented)

---

## Actual worktrees (from git worktree list)

| Label       | Path                                                    | Branch/HEAD                      | Commit  | Purpose                                                 |
| ----------- | ------------------------------------------------------- | -------------------------------- | ------- | ------------------------------------------------------- |
| **Primary** | `C:/Users/LegiT/against-the-odds`                       | main                             | (HEAD)  | Primary repo; main branch; canonical                    |
| **mhx**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/mhx` | handoff-doc-permissions-20260129 | b0a8f30 | Active worktree on feature branch (user)                |
| **bjm**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/bjm` | (detached HEAD)                  | 6e73084 | Worktree; sync ref OPERATOR_RUNBOOK (CONSOLIDATION_LOG) |
| **cpd**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/cpd` | (detached HEAD)                  | 6e73084 | Worktree                                                |
| **ghd**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/ghd` | (detached HEAD)                  | eabaf83 | Worktree                                                |
| **jxj**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/jxj` | (detached HEAD)                  | bb147b0 | Worktree (guru PP run 2026-02-07)                       |
| **igt**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/igt` | (detached HEAD)                  | 6e73084 | Worktree; sync ref OPERATOR_RUNBOOK (CONSOLIDATION_LOG) |
| **osd**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/osd` | (detached HEAD)                  | 6e73084 | Worktree; sync ref OPERATOR_RUNBOOK (CONSOLIDATION_LOG) |

**Removed (2026-02-07)**: ewa, snq, uub removed via `git worktree remove`. opo, qqa were not in worktree list (already removed or not present). **Not in git worktree list (stale in Cursor/IDE)**: **hal**, **hvf** — if Cursor shows "Failed to apply worktree" or paths under `hal` or `hvf`, remove those worktree/workspace entries from Cursor; they are not in `git worktree list`. Merged branches guru-finalization-20260206 and cursor-agent-setup deleted locally.

**Important**: All commits to main (including CONSOLIDATION_LOG and worktree-doc fixes) must be made from the **primary** repo path only (`C:/Users/LegiT/against-the-odds`). Git stores paths relative to the repo root (e.g. `docs/status/CONSOLIDATION_LOG.md`), not under any worktree subfolder. **Before committing**: If your diff or Source Control shows a path containing any worktree name (e.g. `hal`, `hvf`, `jxj`, `mhx`) or any path under `.cursor/worktrees/against-the-odds/`, you are in the wrong workspace; committing from here would violate the policy. Do **not** commit. Close that root, open **only** the primary repo (`C:/Users/LegiT/against-the-odds`) as the workspace, then stage and commit from there so the policy is satisfied.

---

## Usage

All commands run from **repo root**. Do not commit from worktrees without coordinating with main branch.

**Note**: `.cursor/worktrees.json` may not list mhx; this doc is the single source of truth for actual worktrees.
