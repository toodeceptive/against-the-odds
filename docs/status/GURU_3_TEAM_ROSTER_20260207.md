# Guru 3-team execution roster (2026-02-07)

**Purpose**: Defines the three specialist guru teams and their domains for the from-scratch full-scale PP run. No dependency on existing 20-team or 100-step docs.

**Reference**: [GURU_3_TEAM_PROPOSALS_20260207.md](GURU_3_TEAM_PROPOSALS_20260207.md), plan `3-team_guru_pp_from_scratch_74befe0e.plan.md`.

---

## Teams and domains

| Team        | Specialty                             | Domain                                                                                                                                                                                                                              |
| ----------- | ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Cursor**  | Cursor, agents, automations           | `.cursor/` (rules, skills, agents, commands, plans, settings, extensions, worktrees.json), AGENTS.md, desktop automation (`src/desktop-automation/`, `tests/desktop-automation/`), browser-automation, Cursor tasks and keybindings |
| **GitHub**  | GitHub, repos, automations, agents    | `.github/` (workflows, dependabot, ISSUE_TEMPLATE, PULL_REQUEST_TEMPLATE), repo/branch/worktree state, `scripts/` (74 PowerShell scripts, verify-pipeline.ps1), `scripts/github/`, CI/CD and pipeline hygiene                       |
| **Shopify** | Shopify, themes, updates, automations | `src/shopify/themes/`, `scripts/shopify/`, OPERATOR_RUNBOOK theme/store flow, shopify-sync.yml, sync-theme-branch.yml, credentials and deploy-log discipline                                                                        |

---

## Phase ownership (5-phase flow)

- **Phase 1**: All teams — Discovery and analysis; output proposals.
- **Phase 2**: Lead agent — Collate proposals into one document.
- **Phase 3**: Lead agent — Cross-comparative review; finalized decisions (Accept/Reject/Defer).
- **Phase 4**: Lead agent — Apply accepted changes; run quality and verify-pipeline.
- **Phase 5**: Lead agent — CONSOLIDATION_LOG, INDEX_REPORTS, commit and push from primary.

---

_Added 2026-02-07 for 3-team guru PP from-scratch run._
