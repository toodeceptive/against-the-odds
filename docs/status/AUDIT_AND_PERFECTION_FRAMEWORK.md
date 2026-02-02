# Best Ways to Audit, Identify, and Perfect the Entire Repo with the Guru Expert Team

**Purpose**: Single reference for (A) best ways to audit, review, analyze, debug, and identify every file and folder in the repo, and (B) best ways to fix, update, optimize, clean, consolidate, improve, enhance, and perfect the entire system using the massive guru expert team (28 roles). See also [GURU_TEAM_ASSIGNMENTS.md](GURU_TEAM_ASSIGNMENTS.md) and [.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md](../../.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md).

---

## Context

The repo has a **canonical plan** ([.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md](../../.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md)) and a **massive guru team** (10 domain experts + 14 finalization leads + 4 orchestration/audit = 28 roles) in [GURU_TEAM_ASSIGNMENTS.md](GURU_TEAM_ASSIGNMENTS.md). This document ties "best ways to audit and identify" and "best ways to fix and perfect" into that structure.

---

## Part A: Best Ways to Audit, Review, Analyze, Debug, and Identify (All Files, Folders, Components)

### A.1 Automated pipeline and scripts (identification and sanity checks)

| Mechanism                                                                            | What it identifies/validates                                                                        | When to run                                                   |
| ------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| [scripts/verify-pipeline.ps1](../../scripts/verify-pipeline.ps1)                     | All PowerShell scripts (parse), all workflow files (exist), product sync dry-run, ESLint            | After any workflow or script change; gate before deploy       |
| [scripts/debug/parse-all-ps1.ps1](../../scripts/debug/parse-all-ps1.ps1)             | Every `.ps1` under repo (excl. node_modules, .git); parse validity                                  | Part of verify-pipeline; run standalone for script-only audit |
| [scripts/run-everything-debug.ps1](../../scripts/run-everything-debug.ps1)           | Parse check, Node/npm, lint, unit tests; writes docs/status/debug*sweep*\*.log                      | Full debug sweep; comprehensive local check                   |
| [scripts/maintenance/security-scan.ps1](../../scripts/maintenance/security-scan.ps1) | npm audit (dependency vulnerabilities)                                                              | Before push; CI also runs secret-scan in workflows            |
| CI (ci.yml, quality-check.yml)                                                       | Lint, format check, unit tests, Trivy, secret-scan, Lighthouse (quality-check: coverage, npm audit) | Every push/PR to main                                         |

**Best practice**: Run `.\scripts\verify-pipeline.ps1` and `npm run lint` / `npm run test:unit` as the minimal "identify broken or inconsistent parts" pass. Use `run-everything-debug.ps1` for a full local audit with a timestamped log.

### A.2 Inventories and status docs (explicit identification of areas)

| Document                                                                                        | What it identifies                                                                                                      | Owner / source                                                                                             |
| ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| [BRANCH_INVENTORY.md](BRANCH_INVENTORY.md)                                                      | Every branch (local/remote), default, workflow-created                                                                  | Track A; Expert 6, Release Branch Manager                                                                  |
| [WORKTREE_INVENTORY.md](WORKTREE_INVENTORY.md)                                                  | Every worktree path, branch/HEAD, purpose                                                                               | Phase 0 + Track A                                                                                          |
| [ROOT_FILES_INVENTORY.md](ROOT_FILES_INVENTORY.md)                                              | Every root-level file (replacements.txt, .png, configs, etc.)                                                           | Phase 0; Track F for .png                                                                                  |
| [ENVIRONMENTS_AND_SECRETS_INVENTORY.md](ENVIRONMENTS_AND_SECRETS_INVENTORY.md)                  | .env.\*, CI secrets, GitHub Environments (or "none")                                                                    | Phase 0; Expert 1                                                                                          |
| [INDEX_REPORTS.md](INDEX_REPORTS.md)                                                            | All status/report files (current vs legacy); "where to find what"                                                       | Track D; Expert 5                                                                                          |
| Plan "Repository file inventory" table                                                          | Counts by area (root, .cursor, .github, archive, assets, config, data, docs, docs/status, prompts, scripts, src, tests) | [FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md](../../.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md) |
| [FULL_SYSTEM_FILE_AUDIT_20260130.md](FULL_SYSTEM_FILE_AUDIT_20260130.md) (and newer if present) | Codebase layout, scripts, tests, unupdated/irrelevant files                                                             | Track G style; Expert 3, Ultimate Audit                                                                    |
| [CODEBASE_AUDIT_20260131.md](CODEBASE_AUDIT_20260131.md)                                        | src/, tests/, dependencies, lint/test status, recommendations                                                           | Track G deliverable                                                                                        |

**Best practice**: Use INDEX_REPORTS as the single index of "what exists and where." Keep BRANCH_INVENTORY, WORKTREE_INVENTORY, ROOT_FILES_INVENTORY, and ENVIRONMENTS_AND_SECRETS_INVENTORY up to date.

### A.3 Expert-driven audit (systematic review and analysis)

| Method                                | What it audits                                                                                                                                     | How to run                                                                                                                                                                                            |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT   | Any single component (file, dir, integration, workflow): discovery → analysis → optimization                                                       | Apply [prompts/ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md](../../prompts/ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md) to one target at a time                                                                  |
| MASTER_10_EXPERT_SYSTEM               | Whole repo in 10 sequential passes (Security → … → DevEx); cross-validation and synthesis                                                          | Run [prompts/MASTER_10_EXPERT_SYSTEM.md](../../prompts/MASTER_10_EXPERT_SYSTEM.md)                                                                                                                    |
| Canonical plan (Phase 0 + Tracks A–G) | Branches, worktrees, files, env, handoff; then repo structure, workflows, agents, docs, scripts, assets, codebase                                  | Execute [.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md](../../.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md); use [GURU_TEAM_ASSIGNMENTS.md](GURU_TEAM_ASSIGNMENTS.md) for owners |
| Guru pass 2                           | "Unidentified/unexamined/ignored" items: replacements.txt, .cursor/settings, pre-commit, archive, prompts refs, docs/launch, spec-pack, .gitignore | Final step of plan; Head Guru + Chief of Staff; append to CONSOLIDATION_LOG                                                                                                                           |
| Single-domain deep dive               | One dimension only (e.g. security, testing, docs)                                                                                                  | Use [docs/AGENT_PROMPT_DECISION_TREE.md](../AGENT_PROMPT_DECISION_TREE.md); run expert-01 through expert-10 as needed                                                                                 |

**Best practice**: For "identify everything and find issues," run Phase 0 then Tracks A–G with the guru team. For a quick full-system pass, use MASTER_10_EXPERT_SYSTEM. For a single area, use ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT or the matching expert prompt.

### A.4 Decision flow (which audit when)

- **Phase 0 not signed off**: Run inventories and verify-pipeline; complete Phase 0 and sign off in PHASE_0_FINALIZATION.md before tracks.
- **Full repo perfection**: Execute the canonical plan (Phase 0 → Tracks A–G → Synthesis → Addendum → Guru pass 2) with the guru team per GURU_TEAM_ASSIGNMENTS.
- **Sequential 10-domain audit**: MASTER_10_EXPERT_SYSTEM.
- **One component**: ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT on that component.
- **One domain**: Expert 1–10 as in the decision tree.
- **Quick check**: verify-pipeline + lint + test; ensure inventories (branch, worktree, root, env) are current.

---

## Part B: Best Ways to Fix, Update, Optimize, Clean, Consolidate, Improve, Enhance, and Perfect (Using the Guru Team)

### B.1 Ownership and validation

- **Assignment matrix**: [GURU_TEAM_ASSIGNMENTS.md](GURU_TEAM_ASSIGNMENTS.md) — Phase 0, Tracks A–G, Synthesis, Addendum, Guru pass 2 vs primary owner(s) and reviewers.
- **Cross-cutting dimensions**: Same doc — Security, Legal, Performance, Code quality, Testing, Documentation, CI/CD, Integrations, Frontend, Data, DevEx, Store ops, Manufacturing, Business, Orchestration each have an **owner guru**.

**Best practice**: Assign any fix to the track (or dimension) that owns that area. Primary owner implements; reviewers sign off when the change touches their dimension (e.g. security, legal, store ops before Synthesis).

### B.2 Execution order (plan-driven perfection)

1. **Phase 0** — Inventory and sign-off; gate before tracks.
2. **Tracks A–G** — Execute in parallel after Phase 0; each track produces a deliverable and a CONSOLIDATION_LOG entry.
3. **Synthesis** — CONSOLIDATION_LOG, handoff, INDEX_REPORTS, resolved-issues summary.
4. **Addendum** — Hardcoded paths, index.html, docs/README, HOOKS, decision tree, tasks, node-and-automation.
5. **Guru pass 2** — Unidentified/unexamined items; append to CONSOLIDATION_LOG.

**Handoff rule**: Deliverables that touch **security, legal, or store ops** must be reviewed by Expert 1 / Legal/Risk Lead / Shopify Store Ops before Synthesis.

### B.3 Types of fixes (per plan and resolutions)

| Fix type                | Examples                                                                                    |
| ----------------------- | ------------------------------------------------------------------------------------------- |
| **Document**            | LICENSE or UNLICENSED in runbook; workflow README; replacements.txt in OPERATOR_RUNBOOK     |
| **Implement or remove** | deploy.yml placeholder; shopify-sync backup-store                                           |
| **Relocate**            | Root .png → assets/brand; replacements.txt → config/ (optional)                             |
| **Consolidate**         | INDEX_REPORTS as master index; version/update table; archive legacy; single plan file       |
| **Update**              | head-guru from BRANCH_INVENTORY and HANDOFF; decision tree; AGENTS.md Playwright/desktop    |
| **Clean**               | Stale branches; develop refs removed from workflows; Prettier/lint fixes                    |
| **Optimize**            | Scripts use PSScriptRoot; package lint without --ext; performance-report.json in .gitignore |

**Best practice**: Resolve the 10 must-resolve issues (and addendum items) per the plan; record each resolution in CONSOLIDATION_LOG.

### B.4 Ensuring "every file, folder, and aspect" is covered

- **By area**: Plan inventory table + INDEX_REPORTS + BRANCH_INVENTORY, WORKTREE_INVENTORY, ROOT_FILES_INVENTORY, ENVIRONMENTS_AND_SECRETS_INVENTORY. Tracks A–G assign an owner to repo structure, workflows, agents, docs, scripts, assets, codebase.
- **By dimension**: The 15 cross-cutting dimensions in GURU_TEAM_ASSIGNMENTS each have an owner guru who validates that dimension.
- **Guru pass 2**: Audits "unidentified/unexamined/ignored" items so nothing is assumed done without check.

---

## Summary: Best Practices

| Objective                                               | Best approach                                                                                                                                                                                 |
| ------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Identify all files/folders**                          | Keep BRANCH_INVENTORY, WORKTREE_INVENTORY, ROOT_FILES_INVENTORY, ENVIRONMENTS_AND_SECRETS_INVENTORY current; use plan inventory table + INDEX_REPORTS; run verify-pipeline and parse-all-ps1. |
| **Audit and analyze**                                   | Phase 0 + Tracks A–G with guru team; or MASTER_10_EXPERT_SYSTEM; or ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT for a single component.                                                               |
| **Debug**                                               | run-everything-debug.ps1 (full sweep + log); verify-pipeline + lint + test:unit (fast gate); CI.                                                                                              |
| **Fix, optimize, clean, consolidate, improve, perfect** | Execute the canonical plan in order; assign work to track owners and reviewers per GURU_TEAM_ASSIGNMENTS; apply handoff rule; record resolutions in CONSOLIDATION_LOG; run Guru pass 2.       |

No new tools or roles are required: the **canonical plan**, **GURU_TEAM_ASSIGNMENTS**, **existing scripts**, **inventories**, and **expert/orchestration prompts** already form the best-practice framework.
