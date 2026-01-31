# Agent Prompt Decision Tree

**Purpose**: After Phase 0 is signed off, use this to choose which prompt to run for audits, orchestration, or specialist work. Reduces confusion among multiple “master” and expert prompts.

---

## Gate: Phase 0 First

- **Before any other work**: Read `docs/status/PLAN_AGENT_ENTRY.md` and complete Phase 0 per `prompts/PERFECT_EXECUTION_PROMPT.md`.
- **Sign-off required**: `docs/status/PHASE_0_FINALIZATION.md` must contain **Phase 0 finalized; proceeding allowed.**

---

## After Phase 0: Which Prompt When?

| Goal                                                                                       | Use this prompt                                  | Location                                                                                                                                                                                                                                                             |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Full system audit** (code, config, workflows, integrations, security, performance, etc.) | Ultimate Comprehensive Audit                     | `prompts/ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md`                                                                                                                                                                                                                     |
| **10-expert sequential run** (Security → Performance → Code Quality → … → DevEx)           | Master 10-Expert System                          | `prompts/MASTER_10_EXPERT_SYSTEM.md`                                                                                                                                                                                                                                 |
| **Finalization orchestration** (reconcile worktrees, branches, Shopify, verification)      | Head Guru Orchestrator                           | `prompts/head-guru-orchestrator.md`                                                                                                                                                                                                                                  |
| **Single-domain deep dive** (e.g. security only, testing only)                             | Expert N                                         | `prompts/expert-01-security-secrets.md` … `prompts/expert-10-developer-experience.md`                                                                                                                                                                                |
| **Finalization role** (e.g. Shopify store ops, release manager)                            | Finalization lead                                | `prompts/finalization-shopify-store-ops.md`, etc.                                                                                                                                                                                                                    |
| **Classic agent** (setup, debug, test, optimize)                                           | Setup / Debugging / Testing / Optimization agent | `prompts/setup-agent.md`, `debugging-agent.md`, `testing-agent.md`, `optimization-agent.md`                                                                                                                                                                          |
| **Finalize entire workflow and pipeline** (one coordinated pass)                           | Finalization Workflow Pipeline                   | `prompts/finalization-workflow-pipeline.md` — run experts in order: Security → CI/CD → Documentation → Integrations → Finalization Shopify Store Ops → Head Guru Orchestrator → DevEx; produce "Pipeline finalized" sign-off in `docs/status/`.                      |
| **Full project perfection** (Phases 1–7: foundation → docs → Cursor → business → sign-off) | Full Project Guru Perfection Plan                | `.cursor/plans/` (plan file) or run Phases 1–7 in order per plan; produce `docs/status/PROJECT_PERFECTED_YYYYMMDD.md`. Entry: `docs/status/PLAN_AGENT_ENTRY.md` → Phase 0 first. See `docs/status/INDEX_REPORTS.md` and `docs/status/PROJECT_PERFECTED_20260130.md`. |
| **Full repo organization & audit** (Phase 0 + Tracks A–G + Synthesis)    | Final Repo Organization and Audit    | `.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md` — Phase 0, Tracks A–G, Synthesis. See [.cursor/plans/README.md](../.cursor/plans/README.md) and INDEX_REPORTS.                                                                                                                       |

---

## Finalize workflow and pipeline (seven-expert sequence)

To finalize the entire workflow and pipeline end-to-end, run the experts in this order (or use `prompts/finalization-workflow-pipeline.md` which encodes this sequence):

1. **Security** — `prompts/expert-01-security-secrets.md`
2. **CI/CD** — `prompts/expert-06-cicd-devops.md`
3. **Documentation** — `prompts/expert-05-documentation.md`
4. **Integrations** — `prompts/expert-07-integrations-api.md`
5. **Finalization Shopify Store Ops** — `prompts/finalization-shopify-store-ops.md`
6. **Head Guru Orchestrator** — `prompts/head-guru-orchestrator.md`
7. **DevEx** — `prompts/expert-10-developer-experience.md`

Each step updates docs or config and produces a short deliverable; Head Guru ties them into one "Pipeline finalized" summary in `docs/status/`.

---

## Canonical “Master” Prompts (Avoid Duplication)

- **Audits**: `ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md` — systematic audit of any component.
- **Orchestration (multi-agent)**: `head-guru-orchestrator.md` or `MASTER_10_EXPERT_SYSTEM.md` — head-guru for finalization/reconciliation; MASTER_10 for sequential expert audits.
- **Multi-specialist single run**: `AO_GURU_MULTI_SPECIALIST_MASTER_AGENT_PROMPT.md` — alternative multi-specialist entry; use if you want that roster instead of the 10 experts.
- **Ultimate master (general debugging/optimization)**: `ULTIMATE_MASTER_AGENT_PROMPT.md` — broad “master” behavior; prefer the above for specific goals.

---

## Quick Reference

| Need                      | Document                                |
| ------------------------- | --------------------------------------- |
| Phase 0 and entry         | `docs/status/PLAN_AGENT_ENTRY.md`       |
| Phase 0 definition        | `prompts/PERFECT_EXECUTION_PROMPT.md`   |
| This decision tree        | `docs/AGENT_PROMPT_DECISION_TREE.md`    |
| Shopify / Cursor workflow | `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md` |
| New-agent handoff         | `docs/HANDOFF_PROMPT_NEW_AGENT.md`      |
