# Expectations Checklist — 2026-01-30

**Purpose**: Document operator/owner needs and expectations and verify that workflow, runbook, and handoff support them (Phase 6 Full Project Guru Perfection Plan).

---

## Needs and expectations (from plan and prior docs)

1. **Single entry for agents**: One clear entry point (PLAN_AGENT_ENTRY → Phase 0) and decision tree for "full project perfection" and other flows.
2. **Run from repo root**: All tasks and scripts run from repo root; paths and docs reflect this.
3. **Shopify store ops**: Store URL aodrop.com; theme in `src/shopify/themes/aodrop-theme/`; product data in `data/products/*.json`; theme workflow (preview → QA → publish); deploy-log for every change; no secrets in repo.
4. **Credentials**: `.env.local` for local and scripts; never commit; OPERATOR_RUNBOOK and docs point to setup.
5. **Status and reports**: Single index at `docs/status/INDEX_REPORTS.md`; legacy reports in archive; only README, CHANGELOG, NEXT_STEPS, OPERATOR_RUNBOOK at root.
6. **Finalization**: Business plan and launch docs in `docs/business-plan/` and `docs/launch/`; finalization prompts in `prompts/`; FINALIZATION_RUNBOOK defines outputs and team.
7. **Quality gates**: Lint, format, tests (unit/integration/e2e) and health checks documented in OPERATOR_RUNBOOK and CI.

---

## Verification (workflow, runbook, handoff)

| Expectation          | Supported by                                                                                                                   |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Single agent entry   | `docs/status/PLAN_AGENT_ENTRY.md`, `docs/status/PHASE_0_FINALIZATION.md`, `docs/AGENT_PROMPT_DECISION_TREE.md`                 |
| Run from repo root   | `.cursor/tasks.json` (relative paths), OPERATOR_RUNBOOK, README                                                                |
| Shopify store ops    | OPERATOR_RUNBOOK, `docs/launch/03_shopify_store_ops.md`, `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`, `.cursor/context/shopify.md` |
| Credentials          | OPERATOR_RUNBOOK (Credentials), `.env.example`, `docs/CREDENTIALS_SETUP.md`, `.cursor/rules/env-credentials.mdc`               |
| Status and reports   | `docs/status/INDEX_REPORTS.md`, archive/2026-01-30, root limited to README, CHANGELOG, NEXT_STEPS, OPERATOR_RUNBOOK            |
| Finalization         | `docs/FINALIZATION_RUNBOOK.md`, `docs/launch/00_launch_checklist.md`, `prompts/finalization-*.md`                              |
| Quality gates        | OPERATOR_RUNBOOK (Daily Checks, Integration Checks), `.github/workflows/ci.yml`, `docs/FINALIZATION_RUNBOOK.md` (DoD)          |
| Handoff to new agent | `docs/HANDOFF_PROMPT_NEW_AGENT.md`, OPERATOR_RUNBOOK, INDEX_REPORTS, PLAN_AGENT_ENTRY                                          |

---

## Gaps vs expectations (if any)

- **Shopify connection test**: Requires user to set `SHOPIFY_STORE_DOMAIN` and `SHOPIFY_ACCESS_TOKEN` in `.env.local`; documented in OPERATOR_RUNBOOK. (Proceed summary archived in `archive/2026-01-30/status-legacy/`.)
- **Store readiness report**: `docs/launch/01_store_readiness.md` is a template; run Tech Release Manager prompt to populate with current results.

---

## Sign-off

Workflow, runbook, and handoff support the listed expectations. Gaps are documented and have clear next actions (credentials setup, run Tech Release Manager for store readiness).

**Phase 6 Expectations deliverable**: Complete.
