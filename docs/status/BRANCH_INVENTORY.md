# Branch and Worktree Inventory

**Purpose**: Single source of truth so nothing is overlooked during reorganization.

**Last updated**: 2026-02-07 (worktree cleanup; merged branches guru-finalization-20260206, cursor-agent-setup deleted locally)

---

## Branches (local and remote)

| Branch                                  | Location                                                       | Notes                                                                                                                           |
| --------------------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **main**                                | local (current), remote origin                                 | Default branch; workflow triggers are main-only (develop removed).                                                              |
| **develop**                             | Not present (local or remote)                                  | Main-only; deploy.yml and quality-check.yml deleted (CI consolidated into ci.yml).                                              |
| **feature/ao-brand-shopify-automation** | local, remote origin                                           | Optional: merge useful work to main and delete, or keep as reference. Main is canonical.                                        |
| **cursor/main-project-setup-2bd1**      | local, remote origin                                           | Optional: merge useful work to main and delete, or keep as reference. Main is canonical.                                        |
| **handoff-doc-permissions-20260129**    | local only (+ worktree mhx)                                    | Optional: handoff/permissions work reflected in main (AGENTS.md, handoff docs). Merge or delete when worktree no longer needed. |
| **cursor-agent-setup**                  | Remote origin only (local deleted 2026-02-07)                  | **Merged to main**; local branch deleted after merge.                                                                           |
| **shopify-theme**                       | Remote only (created by sync-theme-branch.yml on push to main) | Workflow-created branch for Shopify GitHub App connection                                                                       |
| **dependabot/npm_and_yarn/…**           | Remote only (transient)                                        | Dependabot PR branches; safe to ignore for inventory; merge/close via PR.                                                       |
| **guru-finalization-20260206**          | Remote origin only (local deleted 2026-02-07)                  | **Merged to main**; local branch deleted after merge.                                                                           |
| **mlf-main**                            | local, remote origin                                           | Theme backup branch; **36 commits behind main**. Update with `git merge main` or delete when no longer needed.                  |

**CI**: Workflow `ci.yml` runs on push/PR to **main** only. `format:check`, `lint`, `test:unit` must pass. Dependabot PR branches (e.g. eslint-10, @types/node) may need dependency/version alignment before merge.

**Resolved (Track A)**: develop removed from all workflow triggers. Stale local branches (ao-guru-exec, finalization/consolidate-20260129, wip/finalization-team-20260129) deleted. Main-only strategy documented in CONSOLIDATION_LOG and workflow README. **Branch hygiene (2026-01-31)**: handoff-doc-permissions and cursor/main-project-setup-2bd1 documented as optional; operator may merge useful work to main and delete, or keep as reference (see NEXT_BEST_STEPS_20260131 Tier 2).

## Worktrees (Cursor and Git)

| Path                                                    | Branch/HEAD                      | Commit  | Notes                                                              |
| ------------------------------------------------------- | -------------------------------- | ------- | ------------------------------------------------------------------ |
| `C:/Users/LegiT/against-the-odds`                       | main                             | (HEAD)  | **Primary repo** per IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/mhx` | handoff-doc-permissions-20260129 | b0a8f30 | Active worktree on feature branch (user)                           |

**Removed (2026-02-07)**: ewa, snq, uub removed via `git worktree remove`. opo, qqa no longer worktrees. See WORKTREE_INVENTORY.md for details.

**Usage**: All commands run from **repo root**; do not commit from worktrees without coordinating with main branch.

---

## Remote repository

- **origin**: <https://github.com/toodeceptive/against-the-odds.git> (fetch and push)

---

## Sign-off

Phase 0 inventory updated with current branch/worktree state, develop absence, stale locals, worktree discrepancy, and recommended resolution. Every branch and worktree is now documented. No critical branch or worktree is overlooked.
