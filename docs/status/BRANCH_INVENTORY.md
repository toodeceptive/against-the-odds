# Branch and Worktree Inventory

**Purpose**: Single source of truth so nothing is overlooked during reorganization.

**Last updated**: 2026-02-27 (aligned with current `git branch -vv` and `git worktree list`)

---

## Organization labels (worktrees · pipeline · project · GitHub · branches · repos)

| Scope           | Label / description                                                                                                                                                                                                                                                                                                  |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Worktrees**   | **Primary**: `C:/Users/LegiT/against-the-odds` (currently on `main`). **Also**: mhx (handoff-doc-permissions-20260129), bjm, bri, cpd, ghd, igt, ltt, olu, osd (see WORKTREE_INVENTORY.md). Stale (remove from Cursor if shown): hal, hvf.                                                                           |
| **Pipeline**    | **CI**: ci.yml (main only); **verify**: `.\scripts\verify-pipeline.ps1`; **runbook**: `.\scripts\run-runbook.ps1`. 81 PowerShell scripts, 6 workflows.                                                                                                                                                               |
| **Project**     | **Repo**: against-the-odds. **Root**: OPERATOR_RUNBOOK, AGENTS.md, .cursor/plans, docs/status. **Canonical**: main.                                                                                                                                                                                                  |
| **GitHub repo** | **origin**: <https://github.com/toodeceptive/against-the-odds.git> (fetch/push). **Default branch**: main.                                                                                                                                                                                                           |
| **Branches**    | **main** (default, local+remote). **Current checkout**: `main`. **Optional/local**: chore/script-paths-utilities-gitignore, feature/ao-brand-shopify-automation, cursor/main-project-setup-2bd1, guru-pp-run-20260207, handoff-doc-permissions-20260129, mlf-main. **Remote-only**: shopify-theme and dependabot/\*. |
| **Repos**       | **Primary repo** = main worktree. **Worktree mhx** = secondary checkout on handoff branch.                                                                                                                                                                                                                           |

---

## Branches (local and remote)

| Branch                                     | Location                                                       | Notes                                                                   |
| ------------------------------------------ | -------------------------------------------------------------- | ----------------------------------------------------------------------- |
| **main**                                   | local, remote origin                                           | Default branch; workflow triggers are main-only.                        |
| **cursor/structural-integrity-audit-18a1** | local, remote origin                                           | Optional branch; primary repo is on main.                               |
| **chore/script-paths-utilities-gitignore** | local only                                                     | Optional local branch.                                                  |
| **feature/ao-brand-shopify-automation**    | local, remote origin                                           | Optional: merge useful work to main and delete, or keep as reference.   |
| **cursor/main-project-setup-2bd1**         | local, remote origin                                           | Optional: merge useful work to main and delete, or keep as reference.   |
| **guru-pp-run-20260207**                   | local, remote origin                                           | Historical guru run branch; keep/delete per hygiene policy.             |
| **handoff-doc-permissions-20260129**       | local only (+ worktree mhx)                                    | Optional handoff branch.                                                |
| **mlf-main**                               | local, remote origin                                           | Backup branch; significantly behind `origin/main`, reconcile or remove. |
| **shopify-theme**                          | Remote only (created by sync-theme-branch.yml on push to main) | Workflow-created branch for Shopify GitHub App connection.              |
| **dependabot/npm_and_yarn/…**              | Remote only (transient)                                        | Dependabot PR branches; safe to ignore for inventory.                   |

**CI**: Workflow `ci.yml` runs on push/PR to **main** only. `format:check`, `lint`, `test:unit` must pass. Dependabot PR branches (e.g. eslint-10, @types/node) may need dependency/version alignment before merge.

**Resolved (Track A)**: develop removed from all workflow triggers. Stale local branches (ao-guru-exec, finalization/consolidate-20260129, wip/finalization-team-20260129) deleted. Main-only strategy documented in CONSOLIDATION_LOG and workflow README. **Branch hygiene (2026-01-31)**: handoff-doc-permissions and cursor/main-project-setup-2bd1 documented as optional; operator may merge useful work to main and delete, or keep as reference (see NEXT_BEST_STEPS_20260131 Tier 2).

## Worktrees (Cursor and Git)

| Path                                                    | Branch/HEAD                      | Commit  | Notes                                                              |
| ------------------------------------------------------- | -------------------------------- | ------- | ------------------------------------------------------------------ |
| `C:/Users/LegiT/against-the-odds`                       | main                             | 3f25a20 | **Primary repo** per IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/mhx` | handoff-doc-permissions-20260129 | b0a8f30 | Active worktree on feature branch (user)                           |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/bjm` | (detached HEAD)                  | 6e73084 | Worktree                                                           |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/bri` | (detached HEAD)                  | c26bfe3 | Worktree                                                           |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/cpd` | (detached HEAD)                  | 6e73084 | Worktree                                                           |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/ghd` | (detached HEAD)                  | eabaf83 | Worktree                                                           |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/igt` | (detached HEAD)                  | 6e73084 | Worktree                                                           |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/ltt` | (detached HEAD)                  | ad98d32 | Worktree                                                           |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/olu` | (detached HEAD)                  | cdcc0ae | Worktree                                                           |
| `C:/Users/LegiT/.cursor/worktrees/against-the-odds/osd` | (detached HEAD)                  | 6e73084 | Worktree                                                           |

**Removed (2026-02-07)**: ewa, snq, uub removed via `git worktree remove`. opo, qqa no longer worktrees. **Stale (not in `git worktree list`)**: **hal**, **hvf** — remove from Cursor workspace/worktree list if shown; "Failed to apply worktree" for hvf/hal is due to these paths not existing. See WORKTREE_INVENTORY.md for details.

**Usage**: All commands run from **repo root**; do not commit from worktrees without coordinating with main branch.

---

## Remote repository

- **origin**: <https://github.com/toodeceptive/against-the-odds.git> (fetch and push)

---

## Sign-off

Phase 0 inventory updated with current branch/worktree state, develop absence, stale locals, worktree discrepancy, and recommended resolution. Every branch and worktree is now documented. No critical branch or worktree is overlooked.
