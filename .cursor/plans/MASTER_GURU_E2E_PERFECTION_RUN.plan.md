# Master Guru E2E System Perfection — Execution Plan (2026-02-07)

**Purpose**: Step-by-step plan for executing the [MASTER_GURU_E2E_SYSTEM_PERFECTION_PROMPT](../prompts/MASTER_GURU_E2E_SYSTEM_PERFECTION_PROMPT.md). Lead agent coordinates via this plan and `docs/status/`.

**Reference**: [docs/GURU_PP_OPERATOR_GUIDE.md](../../docs/GURU_PP_OPERATOR_GUIDE.md), [OPERATOR_RUNBOOK.md](../../OPERATOR_RUNBOOK.md).

---

## Steps (execute in order; verify each before proceeding)

| #   | Step                                                  | Verification                                                                    | Status  |
| --- | ----------------------------------------------------- | ------------------------------------------------------------------------------- | ------- |
| 1   | Perfect and persist the master prompt                 | Prompt saved to `prompts/MASTER_GURU_E2E_SYSTEM_PERFECTION_PROMPT.md`           | Done    |
| 2   | Run quality gates                                     | `npm run quality` (format, format:check, lint, test:unit)                       | Done    |
| 3   | Run pipeline verification                             | `.\scripts\verify-pipeline.ps1` (or -SkipRunbook if no .env.local)              | Done (runbook cred-gated) |
| 4   | Run runbook (if credentials set)                      | `.\scripts\run-runbook.ps1`                                                     | Done (cred-gated) |
| 5   | Verify E2E/Playwright and desktop automation          | `npm run test:e2e` and desktop tests per node-and-automation context            | Done (desktop 13/13; E2E env-dep) |
| 6   | Update status and consolidation log                   | Append to docs/status/CONSOLIDATION_LOG.md; update WORKTREE_INVENTORY if needed | Done    |
| 7   | Finalize: commit, push, clear pending-approval if N/A | All changes committed and pushed; deploy-log if store-affecting                 | Done    |

---

## Completion criteria

- All steps 2–5 pass or failures are documented with next steps.
- Progress logged in CONSOLIDATION_LOG.
- If work stops short: assign new guru expert teams per the master prompt; re-run from step 2.

---

## Worktree coordination

- **Lead**: Execute from primary repo or igt worktree; read/write `docs/status/`, `.cursor/plans/`.
- **Apply**: When done in a worktree, merge changes back to main per repo workflow (PR or direct push per branch strategy).
