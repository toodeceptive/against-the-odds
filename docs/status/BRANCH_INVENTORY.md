# Branch and Worktree Inventory

**Purpose**: Single source of truth so nothing is overlooked during reorganization.

**Last updated**: 2026-01-31 (executing final plan)

---

## Branches (local and remote)

| Branch                                | Location                                                                                                    | Notes                                                                                  |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| **main**                              | local (current), remote origin                                                                              | Default branch; HEAD at 505df09                                                        |
| **develop**                           | Not present (local or remote)                                                                               | Referenced in ci.yml, quality-check.yml, deploy.yml — will remove from triggers        |
| **ao-guru-exec**                      | local only                                                                                                  | Stale feature branch; recommend delete after review                                    |
| **cursor/main-project-setup-2bd1**    | local, remote origin                                                                                        | Feature branch; may keep until merged or delete                                        |
| **finalization/consolidate-20260129** | local only                                                                                                  | Stale feature branch; recommend delete after review                                    |
| **handoff-doc-permissions-20260129**  | local only                                                                                                  | Recent feature branch; may keep until merged or delete                                 |
| **wip/finalization-team-20260129**    | local only                                                                                                  | Stale feature branch; recommend delete after review                                    |
| **shopify-theme**                     | Remote only (created by sync-theme-branch.yml on push to main)                                              | Workflow-created branch for Shopify GitHub App connection                              |

**Decision**: Remove **develop** from workflow triggers and document **main-only** strategy. Review and delete stale local branches.

## Worktrees (Cursor and Git)

| Path                                                    | Branch/HEAD                                | Commit         | Notes                                                                                 |
| ------------------------------------------------------- | ------------------------------------------ | -------------- | ------------------------------------------------------------------------------------- |
| `C:/Users/LegiT/against-the-odds`                       | main                                       | 505df09        | **Primary repo** per IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md                   |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/ewa` | detached HEAD                              | 505df09        | Same commit as main; may be used for cursor navigation or parallel work              |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/mhx` | handoff-doc-permissions-20260129           | b0a8f30        | Different commit; active worktree (current branch)                                   |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/snq` | detached HEAD                              | 1c5ed2e        | Different commit; may be used for cursor navigation or parallel work                 |

**Note**: [.cursor/worktrees.json](.cursor/worktrees.json) does not list ewa, mhx, snq. Recommendation: extend worktrees.json or maintain this inventory doc as single source of truth.

**Usage**: All commands run from **repo root**; do not commit from worktrees without coordinating with main branch.

---

## Remote repository

- **origin**: https://github.com/toodeceptive/against-the-odds.git (fetch and push)

---

## Sign-off

Phase 0 inventory updated with current branch/worktree state, develop absence, stale locals, worktree discrepancy, and recommended resolution. Every branch and worktree is now documented. No critical branch or worktree is overlooked.