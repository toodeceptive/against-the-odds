# Next Best Steps — Guru Expert Analysis (2026-01-31)

**Purpose**: In-depth review of all work completed; prioritized next steps for operators and agents.  
**Basis**: CONSOLIDATION_LOG (Phase 0 + Tracks A–G + Synthesis), CODEBASE_AUDIT_20260131, OPERATOR_RUNBOOK, NEXT_STEPS.md, launch checklist, plan success criteria.

---

## Current state (summary)

- **Organization and audit**: Complete. Phase 0 + Tracks A–G + Synthesis done; all 10 plan issues resolved; CONSOLIDATION_LOG and inventories current.
- **Branch**: `main` pushed; workflows main-only; deploy-staging disabled; no pending store changes (pending-approval.md clear).
- **Docs**: INDEX_REPORTS, PLAN_AGENT_ENTRY, AGENTS.md, OPERATOR_RUNBOOK, scripts/README, config/README, data/README, HOOKS.md, ROOT_FILES_INVENTORY, CODEBASE_AUDIT current.
- **Security**: Token echo removed; secret-scan exclusions set; .env.local only; npm audit 6 moderate, 0 high/critical.
- **Remaining branches**: `cursor/main-project-setup-2bd1` (local + remote), `handoff-doc-permissions-20260129` (local + worktree mhx).

---

## Recommended next steps (prioritized)

### Tier 1 — Operational (do first)

| #   | Action                 | Why                                                                   | Where                                                                                                      |
| --- | ---------------------- | --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| 1   | **Run daily checks**   | Confirm lint, format, unit tests pass after all changes.              | OPERATOR_RUNBOOK § Daily Checks: `npm run lint`, `npm run format:check`, `npm run test:unit`               |
| 2   | **Verify credentials** | Ensure .env.local is populated and Shopify/GitHub connectivity works. | `.\scripts\run-runbook.ps1` or `.\scripts\shopify\test-connection.ps1`, `.\scripts\github\verify-auth.ps1` |

**Rationale**: Ensures the repo is healthy and credentials work before any feature or launch work. (NEXT_STEPS.md already updated to reflect audit completion and to link here.)

---

### Tier 2 — Branch and worktree hygiene (recommended)

| #   | Action                        | Why                                                                                                                                                                          | Where                                |
| --- | ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| 4   | **Decide remaining branches** | `handoff-doc-permissions-20260129` and `cursor/main-project-setup-2bd1` are still present; merge useful work to main and delete, or document as long-lived feature branches. | BRANCH_INVENTORY.md; `git branch -a` |
| 5   | **Update BRANCH_INVENTORY**   | After branch decisions, refresh the table so the next agent sees current state.                                                                                              | docs/status/BRANCH_INVENTORY.md      |

**Rationale**: Reduces confusion and keeps a single source of truth for what’s active vs archived.

---

### Tier 3 — Business and launch (when ready)

| #   | Action                            | Why                                                                                               | Where                                                                                                                       |
| --- | --------------------------------- | ------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| 6   | **Work through launch checklist** | Store readiness, policies, checkout, email, analytics per launch plan.                            | [docs/launch/00_launch_checklist.md](../launch/00_launch_checklist.md)                                                      |
| 7   | **Store readiness report**        | Populate store readiness and run Tech Release Manager / finalization prompts if used.             | [docs/launch/01_store_readiness.md](../launch/01_store_readiness.md); prompts/finalization-tech-release-manager.md          |
| 8   | **Product and theme flow**        | When making store changes: preview → snapshot to pending-approval → approve → apply → deploy-log. | [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](../AGENT_WORKFLOW_CURSOR_SHOPIFY.md); OPERATOR_RUNBOOK § Update Shopify from Cursor |

**Rationale**: Moves from “repo and pipeline ready” to “store and launch ready.”

---

### Tier 4 — Optional technical follow-up (no urgency)

| #   | Action                                     | Why                                                                                                                   | Where                                                                                                               |
| --- | ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| 9   | **Coverage remediation**                   | Raise test coverage toward 90%; thresholds in vitest.config.js are at baseline.                                       | [docs/status/COVERAGE_REMEDIATION_PLAN.md](COVERAGE_REMEDIATION_PLAN.md); CODEBASE_AUDIT_20260131 § Recommendations |
| 10  | **deploy.yml / shopify-sync backup-store** | Implement real deploy or backup-store job, or remove placeholders; already documented as placeholder.                 | .github/workflows/README.md; ci.yml, shopify-sync.yml                                                               |
| 11  | **LICENSE file**                           | Add a LICENSE file or explicitly document "UNLICENSED" in runbook (already in package.json and ROOT_FILES_INVENTORY). | OPERATOR_RUNBOOK or root LICENSE                                                                                    |
| 12  | **Desktop automation deps**                | If contributors use robotjs/node-window-manager, document native build in README or OPERATOR_RUNBOOK.                 | CODEBASE_AUDIT_20260131 § Recommendations                                                                           |

**Rationale**: Improves quality and clarity over time; not blocking.

---

## What not to do (unless intended)

- **Do not** re-run full organization/audit tracks; they are complete and logged.
- **Do not** create a new canonical plan; FINAL_REPO_ORGANIZATION_AND_AUDIT is the single plan.
- **Do not** commit secrets or bypass preview-before-apply for store changes (see AGENTS.md and shopify-preview-approval.mdc).

---

## Quick reference

| Need           | Document                                 |
| -------------- | ---------------------------------------- |
| Daily ops      | OPERATOR_RUNBOOK.md                      |
| Store workflow | docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md    |
| What’s done    | docs/status/CONSOLIDATION_LOG.md         |
| Reports index  | docs/status/INDEX_REPORTS.md             |
| Agent entry    | docs/status/PLAN_AGENT_ENTRY.md          |
| Launch         | docs/launch/00_launch_checklist.md       |
| Coverage       | docs/status/COVERAGE_REMEDIATION_PLAN.md |

---

_Generated from guru expert analysis of CONSOLIDATION_LOG, CODEBASE_AUDIT_20260131, OPERATOR_RUNBOOK, NEXT_STEPS, and launch docs. 2026-01-31._
