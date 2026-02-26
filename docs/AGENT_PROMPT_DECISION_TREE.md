# Agent Prompt Decision Tree

**Purpose**: After Phase 0 is signed off, use this to choose which prompt to run for audits, orchestration, or specialist work. Reduces confusion among multiple “master” and expert prompts.

---

## Gate: Phase 0 First

- **Before any other work**: Read `docs/status/PLAN_AGENT_ENTRY.md` and complete Phase 0 per `prompts/PERFECT_EXECUTION_PROMPT.md`.
- **Sign-off required**: `docs/status/PHASE_0_FINALIZATION.md` must contain **Phase 0 finalized; proceeding allowed.**

**Exception — Fix everything / takeover**: If the user has granted **full dominion** to fix the entire project and the system is broken, read **`docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`** first. Then execute the canonical plan (`.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md`). All audit content is consolidated in that plan. Phase 0 may be satisfied by existing inventory/sign-off; proceed through tracks and addendum fixes.

---

## After Phase 0: Which Prompt When?

| Goal                                                                                                                                                              | Use this prompt                               | Location                                                                                                                                                                                                                                                          |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Full system audit** (code, config, workflows, integrations, security, performance, etc.)                                                                        | Master 10-Expert System                       | `prompts/MASTER_10_EXPERT_SYSTEM.md`                                                                                                                                                                                                                              |
| **10-expert sequential run** (Security → Performance → Code Quality → … → DevEx)                                                                                  | Master 10-Expert System                       | `prompts/MASTER_10_EXPERT_SYSTEM.md`                                                                                                                                                                                                                              |
| **Finalization orchestration** (reconcile worktrees, branches, Shopify, verification)                                                                             | Head Guru Orchestrator                        | `prompts/head-guru-orchestrator.md`                                                                                                                                                                                                                               |
| **Single-domain deep dive** (e.g. security only, testing only)                                                                                                    | Expert N                                      | `prompts/expert-01-security-secrets.md` … `prompts/expert-10-developer-experience.md`                                                                                                                                                                             |
| **Finalization role** (e.g. Shopify store ops, release manager)                                                                                                   | Finalization lead                             | `prompts/finalization-shopify-store-ops.md`, etc.                                                                                                                                                                                                                 |
| **Finalize entire workflow and pipeline** (one coordinated pass)                                                                                                  | Finalization Workflow Pipeline                | `prompts/finalization-workflow-pipeline.md` — run experts in order: Security → CI/CD → Documentation → Integrations → Finalization Shopify Store Ops → Head Guru Orchestrator → DevEx; produce "Pipeline finalized" sign-off in `docs/status/`.                   |
| **Full project perfection** (Phases 1–7: foundation → docs → Cursor → business → sign-off)                                                                        | Full Project Guru Perfection Plan             | `.cursor/plans/` (plan file) or run Phases 1–7 in order per plan. Entry: `docs/status/PLAN_AGENT_ENTRY.md` → Phase 0 first. See `docs/status/INDEX_REPORTS.md`.                                                                                                   |
| **Full project update & perfection** (audit + new system + cleanup + update everything)                                                                           | Full Project Update & Perfection (multi-guru) | **Consolidated** into the single canonical plan: `.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md` (open in Cursor and use Build). See `docs/status/INDEX_REPORTS.md`.                                                                                    |
| **Execute plan with full guru team** (per-phase owners and reviewers)                                                                                             | Canonical plan + guru assignments             | `.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md` — open in Cursor and use Build; see plan section "Guru expert team" and `docs/status/GURU_TEAM_ASSIGNMENTS.md` for roster, assignment matrix, and perfection dimensions.                                |
| **Full system-wide test and improvement** (new agent team; code, repo, pipeline, Cursor system, AO project)                                                       | Full System Test and Improvement              | `prompts/FULL_SYSTEM_TEST_AND_IMPROVEMENT_PROMPT.md` — test all aspects (code, files, functions, tools, extensions, repo, local, pipeline, scripts, GitHub Actions, Cursor agent system); fixes, cleanup, optimizations, performance. Use /review, /pr, Verifier. |
| **Full-system overhaul and unified agent execution** (any request → plan → PC + APIs → preview/approve/apply; Phase 0 audit; conditional APIs vs PC; 100-step PP) | Master Full-System Overhaul Unified Guru PP   | `prompts/MASTER_FULL_SYSTEM_OVERHAUL_UNIFIED_GURU_PP_PROMPT.md` — full-system overhaul, audit, unified vision; decision tree and credentials matrix; reference master prompt for fix-if-fail and commit.                                                          |
| **Audit and perfection framework** (best ways to audit and perfect entire repo)                                                                                   | Reference doc                                 | `docs/status/AUDIT_AND_PERFECTION_FRAMEWORK.md` — scripts, inventories, expert-driven audit, decision flow, fix types, guru ownership; links to GURU_TEAM_ASSIGNMENTS and canonical plan.                                                                         |

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

- **Audits**: `MASTER_10_EXPERT_SYSTEM.md` — systematic audit of any component (10-expert sequential run).
- **Orchestration (multi-agent)**: `head-guru-orchestrator.md` or `MASTER_10_EXPERT_SYSTEM.md` — head-guru for finalization/reconciliation; MASTER_10 for sequential expert audits.

---

## Quick Reference

| Need                                   | Document                                                             |
| -------------------------------------- | -------------------------------------------------------------------- |
| Phase 0 and entry                      | `docs/status/PLAN_AGENT_ENTRY.md`                                    |
| Fix everything / takeover              | `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`                        |
| Local main finalization (closure)      | `prompts/LOCAL_MAIN_GURU_FINALIZATION_PROMPT_V5.md`                  |
| Local-main cloud/local escalation pack | `docs/status/LOCAL_MAIN_CLOUD_ESCALATION_EXECUTION_PACK_20260226.md` |
| Full system test + improvement run     | `prompts/FULL_SYSTEM_TEST_AND_IMPROVEMENT_PROMPT.md`                 |
| Full-system overhaul + unified vision  | `prompts/MASTER_FULL_SYSTEM_OVERHAUL_UNIFIED_GURU_PP_PROMPT.md`      |
| Phase 0 definition                     | `prompts/PERFECT_EXECUTION_PROMPT.md`                                |
| This decision tree                     | `docs/AGENT_PROMPT_DECISION_TREE.md`                                 |
| Shopify / Cursor workflow              | `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`                              |
| New-agent handoff                      | `docs/HANDOFF_PROMPT_NEW_AGENT.md`                                   |
