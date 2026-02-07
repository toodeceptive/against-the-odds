# Branch and Worktree Inventory

**Purpose**: Single source of truth so nothing is overlooked during reorganization.

**Last updated**: 2026-02-06 (guru finalization merged to main; guru-finalization-20260206 branch merged)

---

## Branches (local and remote)

| Branch                                  | Location                                                       | Notes                                                                                                                                                   |
| --------------------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **main**                                | local (current), remote origin                                 | Default branch; workflow triggers are main-only (develop removed).                                                                                      |
| **develop**                             | Not present (local or remote)                                  | Main-only; deploy.yml and quality-check.yml deleted (CI consolidated into ci.yml).                                                                      |
| **feature/ao-brand-shopify-automation** | local, remote origin                                           | Optional: merge useful work to main and delete, or keep as reference. Main is canonical.                                                                |
| **cursor/main-project-setup-2bd1**      | local, remote origin                                           | Optional: merge useful work to main and delete, or keep as reference. Main is canonical.                                                                |
| **handoff-doc-permissions-20260129**    | local only (+ worktree mhx)                                    | Optional: handoff/permissions work reflected in main (AGENTS.md, handoff docs). Merge or delete when worktree no longer needed.                         |
| **cursor-agent-setup**                  | local, remote origin                                           | Cursor/agent setup and .cursorignore (2026-02-06). **Merged to main** (commit 03c4243). Optional: delete branch and opo worktree when no longer needed. |
| **shopify-theme**                       | Remote only (created by sync-theme-branch.yml on push to main) | Workflow-created branch for Shopify GitHub App connection                                                                                               |
| **dependabot/npm_and_yarn/…**           | Remote only (transient)                                        | Dependabot PR branches; safe to ignore for inventory; merge/close via PR.                                                                               |
| **guru-finalization-20260206**         | Remote origin (optional local)                                 | Full system test run, Prettier pass, CONSOLIDATION_LOG and report. **Merged to main** (06eaa37). Optional: delete branch after merge.                    |

**Resolved (Track A)**: develop removed from all workflow triggers. Stale local branches (ao-guru-exec, finalization/consolidate-20260129, wip/finalization-team-20260129) deleted. Main-only strategy documented in CONSOLIDATION_LOG and workflow README. **Branch hygiene (2026-01-31)**: handoff-doc-permissions and cursor/main-project-setup-2bd1 documented as optional; operator may merge useful work to main and delete, or keep as reference (see NEXT_BEST_STEPS_20260131 Tier 2).

## Worktrees (Cursor and Git)

| Path                                                    | Branch/HEAD                      | Commit         | Notes                                                                                                          |
| ------------------------------------------------------- | -------------------------------- | -------------- | -------------------------------------------------------------------------------------------------------------- |
| `C:/Users/LegiT/against-the-odds`                       | main                             | (current HEAD) | **Primary repo** per IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md                                             |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/ewa` | detached HEAD                    | 505df09        | Same commit as main; may be used for cursor navigation or parallel work                                        |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/mhx` | handoff-doc-permissions-20260129 | b0a8f30        | Different commit; active worktree (current branch)                                                             |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/snq` | detached HEAD                    | 1c5ed2e        | Different commit; may be used for cursor navigation or parallel work                                           |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/uub` | detached HEAD                    | 16a8024        | Different commit; may be used for cursor navigation or parallel work                                           |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/opo` | cursor-agent-setup               | (branch HEAD)  | Cursor agent setup worktree; cursor-agent-setup already merged to main; repurpose or remove worktree as needed |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/qqa` | detached HEAD or guru-finalization-20260206 | 06eaa37        | Full system test / guru finalization worktree; work merged to main.                                            |

**Note**: [.cursor/worktrees.json](.cursor/worktrees.json) does not list ewa, mhx, snq, uub. Recommendation: extend worktrees.json or maintain this inventory doc as single source of truth.

**Usage**: All commands run from **repo root**; do not commit from worktrees without coordinating with main branch.

---

## Remote repository

- **origin**: <https://github.com/toodeceptive/against-the-odds.git> (fetch and push)

---

## Sign-off

Phase 0 inventory updated with current branch/worktree state, develop absence, stale locals, worktree discrepancy, and recommended resolution. Every branch and worktree is now documented. No critical branch or worktree is overlooked.
