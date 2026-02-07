# Guru PP execution roster — 20 teams × 10 phases (2026-02-07)

**Purpose**: Map the 20 guru expert teams to the 10 phases of the 100-step multiphase PP cycles. Lead agent uses this for phase ownership and guru review.

**Reference**: [GURU_100_STEP_MULTIPHASE_PP_CYCLES_20260207.md](GURU_100_STEP_MULTIPHASE_PP_CYCLES_20260207.md), [GURU_20_TEAMS_60_SPECIALTIES.md](GURU_20_TEAMS_60_SPECIALTIES.md), [MASTER_FULL_SCALE_GURU_PP_PROMPT.md](../../prompts/MASTER_FULL_SCALE_GURU_PP_PROMPT.md).

---

## Phase → Lead team(s) and support

| Phase  | Steps  | Lead team(s)                                        | Support teams                               | Primary checks                                                                           |
| ------ | ------ | --------------------------------------------------- | ------------------------------------------- | ---------------------------------------------------------------------------------------- |
| **1**  | 1–10   | **13 Repo & Git**                                   | 9 Security & secrets                        | git pull, branch main, worktree list, .gitignore, origin, BRANCH_INVENTORY, primary path |
| **2**  | 11–20  | **14 Quality gates**                                | 11 Testing                                  | npm run format, format:check, lint, test:unit, quality; eslint/prettier configs          |
| **3**  | 21–30  | **1 Pipeline & CI**                                 | 2 Runbook & Ops, 4 Commerce, 19 Performance | verify-pipeline.ps1 -SkipRunbook; 74 scripts, 6 workflows; cred-gated steps              |
| **4**  | 31–40  | **5 Cursor & agents**                               | 6 Plans & orchestration                     | .cursor extensions, settings, rules, skills, agents, commands                            |
| **5**  | 41–50  | **9 Security & secrets**                            | 17 Integration                              | verify-auth.ps1, verify-secrets.ps1; docs; no secrets in repo                            |
| **6**  | 51–60  | **3 Shopify & theme**                               | 4 Commerce & products                       | Theme path, .env.local, scripts, OPERATOR_RUNBOOK, workflows, deploy-log                 |
| **7**  | 61–70  | **11 Testing**, **8 Desktop**                       | 7 Browser & E2E                             | test:unit, test:integration, desktop 13/13, E2E; configs and scripts                     |
| **8**  | 71–80  | **10 Documentation**, **15 Handoff**, **16 Status** | —                                           | CONSOLIDATION_LOG, INDEX_REPORTS, WORKTREE/BRANCH_INVENTORY, HANDOFF, cross-refs         |
| **9**  | 81–90  | **12 Developer experience**                         | 19 Performance, 18 Resilience               | Dead code, script portability, .cursorignore, package.json, npm audit, quality           |
| **10** | 91–100 | **20 Finalization**                                 | All teams (guru review)                     | Review, fixes, stage, commit, pull, push, CONSOLIDATION_LOG, INDEX_REPORTS               |

---

## Execution notes

- **Primary repo only**: All commits and pushes from `C:/Users/LegiT/against-the-odds`. See WORKTREE_INVENTORY.md and CONSOLIDATION_LOG path note.
- **After each phase**: Multi-faceted guru expert team review; apply fixes/updates; then proceed.
- **Fix-if-fail**: Per MASTER_FULL_SCALE_GURU_PP_PROMPT §3; re-verify before proceeding.

---

_Added 2026-02-07 for full-scale guru PP run; referenced in CONSOLIDATION_LOG._
