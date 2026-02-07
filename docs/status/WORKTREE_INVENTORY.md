# Worktree Inventory

**Purpose**: Single source of truth for actual worktrees (from `git worktree list`).

**Last updated**: 2026-02-07 (corrected to match `git worktree list`: all 7 worktrees; stale hal/hvf documented)

---

## Actual worktrees (from git worktree list)

| Label       | Path                                                    | Branch/HEAD                      | Commit  | Purpose                                                 |
| ----------- | ------------------------------------------------------- | -------------------------------- | ------- | ------------------------------------------------------- |
| **Primary** | `C:/Users/LegiT/against-the-odds`                       | main                             | (HEAD)  | Primary repo; main branch; canonical                    |
| **mhx**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/mhx` | handoff-doc-permissions-20260129 | b0a8f30 | Active worktree on feature branch (user)                |
| **bjm**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/bjm` | (detached HEAD)                  | 6e73084 | Worktree; sync ref OPERATOR_RUNBOOK (CONSOLIDATION_LOG) |
| **cpd**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/cpd` | (detached HEAD)                  | 6e73084 | Worktree                                                |
| **ghd**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/ghd` | (detached HEAD)                  | eabaf83 | Worktree                                                |
| **igt**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/igt` | (detached HEAD)                  | 6e73084 | Worktree; sync ref OPERATOR_RUNBOOK (CONSOLIDATION_LOG) |
| **osd**     | `C:/Users/LegiT/.cursor/worktrees/against-the-odds/osd` | (detached HEAD)                  | 6e73084 | Worktree; sync ref OPERATOR_RUNBOOK (CONSOLIDATION_LOG) |

**Removed (2026-02-07)**: ewa, snq, uub removed via `git worktree remove`. opo, qqa were not in worktree list (already removed or not present). **Not in git worktree list (stale in Cursor/IDE)**: **hal**, **hvf** — if Cursor shows "Failed to apply worktree" or paths under `hal` or `hvf`, remove those worktree/workspace entries from Cursor; they are not in `git worktree list`. Merged branches guru-finalization-20260206 and cursor-agent-setup deleted locally.

**Important**: All commits to main (including CONSOLIDATION_LOG and worktree-doc fixes) are made from the **primary** repo path only (`C:/Users/LegiT/against-the-odds`). Git stores paths relative to the repo root (e.g. `docs/status/CONSOLIDATION_LOG.md`), not under `hal` or `hvf`. If your IDE shows a diff or file path like `c:/Users/LegiT/.cursor/worktrees/against-the-odds/hal/docs/status/...`, that is because a **workspace root** is (or was) the `hal` folder—the same repo file is being shown under that root. To avoid confusion and ensure edits/commits apply to the canonical location: **close the hal (and hvf) workspace root** and open the **primary** repo (`C:/Users/LegiT/against-the-odds`) instead.

---

## Usage

All commands run from **repo root**. Do not commit from worktrees without coordinating with main branch.

**Note**: `.cursor/worktrees.json` may not list mhx; this doc is the single source of truth for actual worktrees.
