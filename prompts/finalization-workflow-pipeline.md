# Finalization Workflow and Pipeline — Orchestrator Prompt

**Purpose**: Run a single coordinated pass of seven experts to finalize the entire workflow and pipeline end-to-end. Produces a "Pipeline finalized" sign-off in `docs/status/`.

**When to use**: After Phase 0 is signed off (see `docs/status/PLAN_AGENT_ENTRY.md`). Use when you need to lock in security, CI/CD, docs, integrations, store ops, orchestration, and DevEx in one pass.

---

## Execution order (do not skip)

Run these prompts/steps **in this order**. Each step updates docs or config and produces a short deliverable. Do not redo Phase 0 or unrelated full audits.

| Step | Expert / prompt                             | Focus for finalization                                                                      | Output                                                                      |
| ---- | ------------------------------------------- | ------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| 1    | `prompts/expert-01-security-secrets.md`     | Secrets, .env.local, no secrets in repo/chat; Shopify/GitHub ToS                            | Security checklist and any one-off fixes                                    |
| 2    | `prompts/expert-06-cicd-devops.md`          | CI, quality-check, sync-theme-branch, shopify-sync; no duplicate jobs                       | Workflow consolidation and .github/workflows/README                         |
| 3    | `prompts/expert-05-documentation.md`        | One workflow doc, handoff, runbook, "product with PC files" and "update store to X"         | Updated AGENT_WORKFLOW + OPERATOR_RUNBOOK + optional agent-permissions note |
| 4    | `prompts/expert-07-integrations-api.md`     | Shopify API (products, images, theme), rate limits, browser vs API                          | Integration notes and script alignment                                      |
| 5    | `prompts/finalization-shopify-store-ops.md` | Store ops: product-with-uploads (JSON + browser), theme updates, deploy-log                 | Store-ops runbook section and workflow steps                                |
| 6    | `prompts/head-guru-orchestrator.md`         | Tie expert outputs together; verify one entry point (PLAN_AGENT_ENTRY → Phase 0 → workflow) | Final orchestration report and "how to run an agent" summary                |
| 7    | `prompts/expert-10-developer-experience.md` | Cursor tasks, "run from repo root," agent context, prompts decision tree                    | DevEx note and task/docs tweaks                                             |

---

## Sign-off

After step 7, write or update a short file in `docs/status/` (e.g. `docs/status/PIPELINE_FINALIZED.md`) containing:

- **Title**: Pipeline finalized
- **Date**: (today)
- **Summary**: One coordinated pass completed: Security → CI/CD → Documentation → Integrations → Finalization Shopify Store Ops → Head Guru Orchestrator → DevEx. Workflow and pipeline are finalized end-to-end per `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md` and `.cursor/plans/multi-agent_finalization_and_pipeline_764dc368.plan.md`.
- **Entry for future agents**: Read `docs/status/PLAN_AGENT_ENTRY.md` first; then `docs/AGENT_PROMPT_DECISION_TREE.md`; for store updates see `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`.

---

## Reference

- Plan: `.cursor/plans/multi-agent_finalization_and_pipeline_764dc368.plan.md`
- Decision tree: `docs/AGENT_PROMPT_DECISION_TREE.md`
- Workflow: `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`
