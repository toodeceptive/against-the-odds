# Finalization Audit — 2026-01-31

**Purpose**: Guru-level identification of unfinished work, issues, and improvements so the repo is fully ready for the user and future agents in real-world scenarios.

**Scope**: Entry points, docs, scripts, workflows, pipeline, worktrees, naming, READMEs, agent handoff, and execution clarity.

---

## 1. Executive summary

- **Critical (fix now)**: Broken plan references — multiple docs link to `.cursor/plans/cursor-github-shopify-pipeline.plan.md` and `.cursor/plans/expert_team_security_and_platform_plan_fbf7f611.plan.md`, which **do not exist** (plans consolidated into FINAL_REPO_ORGANIZATION_AND_AUDIT). Fix by pointing to `.cursor/plans/README.md` and implemented rules/docs.
- **High (clarify for agents)**: PLAN_AGENT_ENTRY mandates Phase 0 before any work; Phase 0 + Tracks A–G are **already complete** (CONSOLIDATION_LOG). New agents should skip re-execution and go to NEXT_BEST_STEPS / decision tree. Add one sentence to PLAN_AGENT_ENTRY.
- **Medium (content accuracy)**: NEXT_STEPS.md says "logo catalog in the root directory" and "assets/designs/" — logos are in **assets/brand**; assets/designs may not exist. Update NEXT_STEPS and optionally docs/MANUFACTURING.md.
- **Low / optional**: README env vars could list SHOPIFY_ACCESS_TOKEN and SHOPIFY_STORE_DOMAIN as primary for scripts; docs/README could add PROJECT_MANAGEMENT.md to Other; OPERATOR_RUNBOOK could add one line for run-runbook.ps1 under Integration Checks; NEXT_BEST_STEPS Tier 4 item 11 (LICENSE) is done — mark complete.

---

## 2. Broken references (critical)

| Doc                                                       | Current reference                                                     | Issue        | Fix                                                                                      |
| --------------------------------------------------------- | --------------------------------------------------------------------- | ------------ | ---------------------------------------------------------------------------------------- |
| docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md                     | .cursor/plans/cursor-github-shopify-pipeline.plan.md                  | File missing | Point to .cursor/plans/README.md and this workflow doc                                   |
| docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md                     | .cursor/plans/expert_team_security_and_platform_plan_fbf7f611.plan.md | File missing | Point to .cursor/rules/use-user-browser.mdc, shopify-preview-approval.mdc, docs/security |
| docs/status/IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md | expert_team_security_and_platform_plan_fbf7f611.plan.md               | File missing | Point to .cursor/plans/README.md and FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md           |
| docs/guides/SHOPIFY_CURSOR_USAGE_GUIDE.md                 | cursor-github-shopify-pipeline.plan.md                                | File missing | Point to .cursor/plans/README.md or AGENT_WORKFLOW                                       |
| docs/status/SECURITY_AUDIT_20260130.md                    | expert_team_security_and_platform_plan_fbf7f611.plan.md               | File missing | Point to .cursor/rules and docs/security                                                 |
| docs/HANDOFF_PROMPT_NEW_AGENT.md                          | expert_team_security_and_platform_plan_fbf7f611.plan.md               | File missing | Point to PLAN_AGENT_ENTRY and .cursor/plans/README.md                                    |
| docs/status/PLAN_HANDOFF_FOR_NEXT_AGENT.md                | expert_team... plan                                                   | File missing | Note "plan consolidated; see .cursor/plans/README.md"                                    |

**Canonical state**: `.cursor/plans/` contains only **FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md** and **README.md**. Pipeline and security behavior are implemented in AGENT_WORKFLOW_CURSOR_SHOPIFY.md, .cursor/rules, and docs/security.

---

## 3. Agent entry and Phase 0 (high)

- **PLAN_AGENT_ENTRY.md** instructs every new agent to execute Phase 0 and record sign-off before any other work. **CONSOLIDATION_LOG** and **PHASE_0_FINALIZATION** show Phase 0 + Tracks A–G are already complete. A new agent re-running Phase 0 from scratch is redundant and can cause confusion.
- **Recommendation**: In PLAN_AGENT_ENTRY §1 or §2, add: **"If Phase 0 is already signed off (see docs/status/PHASE_0_FINALIZATION.md and docs/status/CONSOLIDATION_LOG.md), skip to docs/status/NEXT_BEST_STEPS_20260131.md and docs/AGENT_PROMPT_DECISION_TREE.md for ongoing work."**

---

## 4. Stale content (medium)

| Location                                   | Issue                                                | Fix                                                                                                            |
| ------------------------------------------ | ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| NEXT_STEPS.md                              | "Use the logo catalog in the root directory"         | Logos are in **assets/brand** (see assets/brand/README.md). Change to "Use the logo catalog in assets/brand/". |
| NEXT_STEPS.md                              | "Save designs to assets/designs/ (create if needed)" | Keep; add "Logos and brand art: assets/brand/."                                                                |
| docs/MANUFACTURING.md                      | "Review brand guidelines and logo catalog"           | Add "Logo catalog: assets/brand/ (see assets/brand/README.md)."                                                |
| NEXT_BEST_STEPS_20260131.md Tier 4 item 11 | "Add a LICENSE file"                                 | LICENSE (UNLICENSED) already at root. Mark as done or remove from Tier 4.                                      |

---

## 5. Optional improvements (low)

| Area                                  | Suggestion                                                                                                       |
| ------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| README § Environment Variables        | Add SHOPIFY_ACCESS_TOKEN and SHOPIFY_STORE_DOMAIN as primary for scripts (they are in .env.example and runbook). |
| docs/README § Other                   | Add PROJECT_MANAGEMENT.md to the Other table (NEXT_STEPS references it).                                         |
| OPERATOR_RUNBOOK § Integration Checks | Add: "Or run .\scripts\run-runbook.ps1 to run both Shopify and GitHub checks."                                   |
| README § Workflows                    | Deploy is a placeholder; consider: "Deploy: Placeholder (main-only; see .github/workflows/README.md)."           |

---

## 6. Unfinished work (from NEXT_BEST_STEPS)

- **Tier 1**: Run daily checks; verify credentials when .env.local is ready. (Ongoing.)
- **Tier 2**: Decide remaining branches (handoff-doc-permissions-20260129, cursor/main-project-setup-2bd1); update BRANCH_INVENTORY after decision. (User/agent when ready.)
- **Tier 3**: Launch checklist (docs/launch/00_launch_checklist.md); store readiness; product/theme flow when making store changes. (When store is ready.)
- **Tier 4**: Coverage remediation; deploy/backup-store implementation (optional); LICENSE done; desktop automation docs in OPERATOR_RUNBOOK done.

---

## 7. Pipeline, workflow, worktree (verified)

- **Pipeline**: verify-pipeline.ps1 checks all 7 workflows; 61 scripts parse; lint and product dry-run pass. Runbook is credential-gated. No action needed.
- **Workflows**: main-only; deploy-staging disabled; README documents placeholders. No action needed.
- **Worktrees**: ewa, mhx, snq documented in WORKTREE_INVENTORY; .cursor/worktrees.json does not list them — doc is single source of truth. No action needed unless user removes worktrees.

---

## 8. Naming, categorization, labels

- **scripts/README.md**: Domains (Shopify, products, git, GitHub, health, maintenance, etc.) and npm map are clear. No change needed.
- **docs/status/INDEX_REPORTS.md**: Quick reference and version table are current. No change needed.
- **docs/README.md**: Sections (workflow, setup, operations, security, agent, subfolders) are clear. Add PROJECT_MANAGEMENT to Other for consistency.

---

## 9. Summary of fixes to apply

1. **AGENT_WORKFLOW_CURSOR_SHOPIFY.md**: Replace references to cursor-github-shopify-pipeline.plan.md and expert_team_security_and_platform_plan_fbf7f611.plan.md with .cursor/plans/README.md and .cursor/rules / docs/security.
2. **IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md**: Replace expert_team plan with .cursor/plans/README.md and FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md.
3. **SHOPIFY_CURSOR_USAGE_GUIDE.md**: Replace cursor-github-shopify-pipeline.plan.md reference with .cursor/plans/README.md or AGENT_WORKFLOW.
4. **SECURITY_AUDIT_20260130.md**: Replace expert_team plan link with .cursor/rules and docs/security.
5. **HANDOFF_PROMPT_NEW_AGENT.md**: Replace expert_team plan with PLAN_AGENT_ENTRY and .cursor/plans/README.md.
6. **PLAN_HANDOFF_FOR_NEXT_AGENT.md**: Add note that Expert Team plan was consolidated; see .cursor/plans/README.md.
7. **PLAN_AGENT_ENTRY.md**: Add sentence: if Phase 0 already signed off, skip to NEXT_BEST_STEPS and AGENT_PROMPT_DECISION_TREE.
8. **NEXT_STEPS.md**: "logo catalog in the root directory" → "assets/brand/"; add note for assets/brand for logos.
9. **NEXT_BEST_STEPS_20260131.md**: Mark Tier 4 item 11 (LICENSE) as done or remove.
10. **docs/MANUFACTURING.md**: Add logo catalog location (assets/brand).
11. **docs/README.md**: Add PROJECT_MANAGEMENT.md to Other table (optional).

---

_Generated from guru-level audit of entry points, docs, scripts, workflows, and agent readiness. 2026-01-31._
