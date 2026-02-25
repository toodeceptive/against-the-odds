# Guru Expert Team — Step-by-Step Execution Task List (2026-02-07)

**Purpose**: User-approved full-team execution: find all issues, fix all issues, optimize all aspects, finalize/perfect, commits/pulls/pushes after comprehensive review; finish all unfinished work, tasks, automation setups. Execute until all work is complete.

**Reference**: [GURU_20_TEAMS_60_SPECIALTIES.md](GURU_20_TEAMS_60_SPECIALTIES.md), [MASTER_GURU_E2E_PERFECTION_RUN.plan.md](../../.cursor/plans/MASTER_GURU_E2E_PERFECTION_RUN.plan.md).

---

## Execution task list (by team)

| Step | Team(s) | Task                                                                    | Verification                            |
| ---- | ------- | ----------------------------------------------------------------------- | --------------------------------------- |
| 1    | 13, 20  | Pull latest; ensure clean baseline                                      | git status, git pull                    |
| 2    | 9       | Security: .env.local gitignored; no secrets in commits                  | .gitignore; git diff                    |
| 3    | 14, 11  | Quality gates: format, lint, test:unit                                  | npm run quality                         |
| 4    | 1, 4    | Pipeline: all scripts parse; workflows valid                            | verify-pipeline.ps1 -SkipRunbook        |
| 5    | 8       | Desktop automation tests                                                | npx vitest run tests/desktop-automation |
| 6    | 10, 15  | Docs: stale refs, broken links; HANDOFF/CONSOLIDATION_LOG/INDEX_REPORTS | grep; spot-check                        |
| 7    | 12, 6   | Unfinished work: NEXT_STEPS, plans, automation setup                    | NEXT_STEPS.md; .cursor/plans            |
| 8    | All     | Fix all found issues; optimize (format, refs, clarity)                  | Re-run steps 3–5                        |
| 9    | 20      | Finalize: commit, push, CONSOLIDATION_LOG                               | git add, commit, push                   |

---

## Completion criteria

- All quality gates and pipeline steps pass.
- No outstanding issues from team audits.
- All commits made; pushed to origin.
- CONSOLIDATION_LOG entry added; task list marked complete.

---

## Execution result (2026-02-07)

| Step         | Result                                                                                                                                                   |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 Pull       | Deferred (unstaged changes); committed first then pull/push.                                                                                             |
| 2 Security   | .env.local in .gitignore; no secrets in commits.                                                                                                         |
| 3 Quality    | npm run quality pass (format, format:check, lint, test:unit).                                                                                            |
| 4 Pipeline   | verify-pipeline.ps1 -SkipRunbook: 74/74 parse, 6 workflows OK.                                                                                           |
| 5 Desktop    | npx vitest run tests/desktop-automation: 13/13 pass.                                                                                                     |
| 6 Docs       | No stale refs requiring fix; HANDOFF, CONSOLIDATION_LOG, INDEX_REPORTS current.                                                                          |
| 7 Unfinished | NEXT_STEPS and plans documented; config/shopify .shopify-cli.yml TODO is intentional (user sets application_url). Automation setup per OPERATOR_RUNBOOK. |
| 8 Fixes      | Table alignment (Prettier) in BRANCH_INVENTORY, INDEX_REPORTS, WORKTREE_INVENTORY; task list + INDEX_REPORTS + CONSOLIDATION_LOG.                        |
| 9 Finalize   | Commit, pull (if any), push; CONSOLIDATION_LOG entry.                                                                                                    |

**Issues found**: None blocking. **Optimizations**: Format applied project-wide. **All work complete per task list.**

---

_Execution started 2026-02-07; completed 2026-02-07._
