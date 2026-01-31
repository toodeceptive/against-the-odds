# Multi-Agent Synchronized Guru Expert Audit Report

**Date**: 2026-01-30  
**Scope**: Cursor agent workflows, trees, conversations, GitHub workflows, files, directories, environments, prompts, rules, plans, tasks. Cross-comparative progression tracking and issue/optimization identification.  
**Method**: Read `docs/status/PLAN_AGENT_ENTRY.md` and `prompts/PERFECT_EXECUTION_PROMPT.md`; catalog and audit all prompts, GitHub workflows, `.cursor` config, docs vs implementation, redundancies, bugs, optimization opportunities.

---

## 1. Executive Summary

| Area                              | Status                 | Critical issues                                                                     | Optimizations                                                           |
| --------------------------------- | ---------------------- | ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| **Plan entry & Phase 0**          | Aligned                | None                                                                                | Single entry point exists                                               |
| **Prompts (36 files)**            | Redundancy             | Multiple “master” prompts; unclear which to use when                                | Consolidate entry points; document decision tree                        |
| **GitHub workflows (8)**          | Overlap + placeholders | CI vs quality-check duplicate lint/Lighthouse; deploy/maintenance placeholders      | Consolidate or clearly separate; implement deploy/maintenance or remove |
| **.cursor (rules, plans, tasks)** | Aligned                | One task references path that may fail if cwd ≠ repo root                           | Document “run from repo root”                                           |
| **Docs vs implementation**        | Minor drift            | agent-context.md omits `src/shopify`; one doc ref (BROWSER_CREDENTIAL_FLOW) present | Update agent-context; keep refs                                         |
| **Root-level reports**            | Proliferation          | 15+ report/status MD files at root; overlap and confusion                           | Consolidate into `docs/status/` or `archive/` with index                |
| **Scripts**                       | Portable where checked | Some scripts hardcode repo path (portability risk)                                  | Prefer `PSScriptRoot` / repo-root detection                             |
| **WIP / TODO**                    | Clean                  | Only intentional TODO in `docs/launch/01_store_readiness.md`                        | None                                                                    |

**Overall**: The project is well-structured with clear Phase 0 gate, agent entry plan, and Shopify/Cursor/GitHub alignment. Main improvements: (1) reduce prompt and workflow redundancy, (2) consolidate root-level reports, (3) clarify “which prompt when” and (4) replace or remove placeholder workflows.

---

## 2. Prompts Audit (Before Running — Aligned With Request)

### 2.1 Catalog (36 prompts)

| Category                   | Files                                                                                                                                                                                     | Purpose                                                                                                                                                           |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Entry / Phase 0**        | `PERFECT_EXECUTION_PROMPT.md`, (referenced by `PLAN_AGENT_ENTRY`)                                                                                                                         | Mandatory Phase 0; gate for all other work                                                                                                                        |
| **Orchestrator / Master**  | `head-guru-orchestrator.md`, `MASTER_10_EXPERT_SYSTEM.md`, `AO_GURU_MULTI_SPECIALIST_MASTER_AGENT_PROMPT.md`, `ULTIMATE_MASTER_AGENT_PROMPT.md`, `ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md` | Multi-agent orchestration; audits; “master” behavior                                                                                                              |
| **Experts 1–10**           | `expert-01-security-secrets.md` … `expert-10-developer-experience.md`                                                                                                                     | Domain-specific audits (security, performance, code quality, testing, docs, CI/CD, integrations, frontend, database, DevEx)                                       |
| **Finalization team**      | `finalization-*-.md` (13 files)                                                                                                                                                           | Role-based finalization (analytics, business-plan, chief-of-staff, content, customer-support, finance, gtm, legal, ops, release, security, shopify, tech-release) |
| **Agents (classic)**       | `master-agent-prompt.md`, `debugging-agent.md`, `setup-agent.md`, `testing-agent.md`, `optimization-agent.md`                                                                             | Single-agent use cases                                                                                                                                            |
| **Context / capabilities** | `agent-context.md`, `agent-capabilities.md`                                                                                                                                               | Project context and capabilities                                                                                                                                  |

### 2.2 Issues and Redundancies

- **Multiple “master” prompts**: Five files claim orchestration/audit/master role (`head-guru-orchestrator`, `MASTER_10_EXPERT_SYSTEM`, `AO_GURU_MULTI_SPECIALIST_MASTER_AGENT_PROMPT`, `ULTIMATE_MASTER_AGENT_PROMPT`, `ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT`). Risk: agents or users pick different ones and behavior diverges.
- **Unclear “which prompt when”**: No single decision tree (e.g. “Phase 0 first → then head-guru vs MASTER_10 vs ULTIMATE_AUDIT”). PLAN_AGENT_ENTRY correctly points to Phase 0 only; post–Phase 0 flow is not codified.
- **Expert 1–10 vs finalization-\***: Both are specialist rosters; finalization-_ is launch/finalization-focused, expert-_ is domain-audit-focused. Overlap in “who does what” for docs, security, releases.

### 2.3 Recommendations

1. **Define a single post–Phase 0 entry** (e.g. “For full system audit use ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT; for orchestrated expert run use MASTER_10_EXPERT_SYSTEM or head-guru”) and add it to `docs/status/PLAN_AGENT_ENTRY.md` or a new `docs/AGENT_PROMPT_DECISION_TREE.md`.
2. **Consolidate or deprecate** at least one “master” prompt and point to the chosen canonical one from the others.
3. **Cross-reference experts and finalization** in one table (expert-01 ↔ finalization-security, etc.) to avoid duplicate work.

---

## 3. GitHub Workflows Audit

### 3.1 Inventory (8 workflows)

| Workflow                | Triggers                                                   | Jobs                                                               | Notes                                    |
| ----------------------- | ---------------------------------------------------------- | ------------------------------------------------------------------ | ---------------------------------------- |
| `ci.yml`                | push/PR main, develop                                      | test (lint, test, build, Trivy, secret-scan), quality (Lighthouse) | Lint + tests + security + Lighthouse     |
| `quality-check.yml`     | push/PR main, develop                                      | coverage, lint, format:check, npm audit, Lighthouse                | Overlaps with CI (lint, Lighthouse)      |
| `sync.yml`              | schedule + dispatch                                        | sync branches, conflict check                                      | OK                                       |
| `shopify-sync.yml`      | schedule, dispatch, push main (data/products, src/shopify) | sync-products, backup-store (placeholder)                          | backup-store is placeholder              |
| `sync-theme-branch.yml` | push main (src/shopify/themes/aodrop-theme)                | subtree split, push shopify-theme                                  | OK; depends on theme path existing       |
| `deploy.yml`            | push main/develop, dispatch                                | deploy-staging, deploy-production                                  | **Placeholder only** (echo “Deploying…”) |
| `maintenance.yml`       | schedule weekly, dispatch                                  | update-dependencies (PR), security-scan (Trivy)                    | Trivy duplicates ci.yml                  |

### 3.2 Issues and Redundancies

- **CI vs quality-check**: Both run on same push/PR to main and develop; both run lint; both run Lighthouse on `https://toodeceptive.github.io/against-the-odds/`. Doubles work and can double failure modes.
- **Trivy**: Run in both `ci.yml` (test job) and `maintenance.yml` (security-scan). Acceptable if CI = per-commit and maintenance = weekly; document intent or dedupe.
- **deploy.yml**: No real deployment; placeholder. Either implement (e.g. GitHub Pages or staging/prod steps) or remove/disable to avoid confusion.
- **shopify-sync backup-store**: Placeholder (“add script to export…”). Either implement or remove job.
- **Lighthouse URL**: Points to GitHub Pages URL; ensure that URL is the intended target and that branch/build aligns (e.g. main → gh-pages or docs/).

### 3.3 Recommendations

1. **Merge or clearly split CI and quality-check**: Option A: one workflow (e.g. CI) with lint, test, format, coverage, Trivy, Lighthouse. Option B: CI = fast gate (lint + test), quality-check = deeper (coverage, format, audit, Lighthouse) on same trigger but documented.
2. **Implement or remove deploy.yml**: If no deploy yet, add a comment at top “Placeholder – not yet implemented” and a link to OPERATOR_RUNBOOK or launch checklist; or remove the file.
3. **Implement or remove shopify-sync backup-store job**: Same as deploy – either add a real backup step (e.g. theme/product export to artifact) or remove the job.
4. **Document Trivy strategy**: “CI = every push; maintenance = weekly full scan” in `.github/workflows/README.md`.

---

## 4. .cursor Audit (Rules, Plans, Tasks)

### 4.1 Rules

| Rule                           | Purpose                                                | Status                                      |
| ------------------------------ | ------------------------------------------------------ | ------------------------------------------- |
| `ao-guru.rules.md`             | Execution principles, safety, quality gates, reporting | Aligned; MASTER_EXECUTION_REPORT referenced |
| `env-credentials.mdc`          | Credentials only in .env.local; never commit           | Aligned; alwaysApply                        |
| `shopify-preview-approval.mdc` | Preview before live Shopify changes; approval          | Aligned; alwaysApply                        |
| `use-user-browser.mdc`         | Use user’s browser when needed                         | Aligned                                     |

### 4.2 Plans

| Plan                                                       | Purpose                                                           | Status                                                                      |
| ---------------------------------------------------------- | ----------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `perfect_execution_prompt_aca26457.plan.md` (consolidated) | Phase 0 mandatory; PERFECT_EXECUTION_PROMPT                       | See .cursor/plans/README.md; single plan: FINAL_REPO_ORGANIZATION_AND_AUDIT |
| `cursor-github-shopify-pipeline.plan.md`                   | Cursor→GitHub→Shopify; theme branch; preview/approval; deploy log | Implemented; AGENT_WORKFLOW_CURSOR_SHOPIFY.md + rules                       |
| `expert_team_security_and_platform_plan_fbf7f611.plan.md`  | Security/platform (e.g. browser-first, no headless Shopify Admin) | Referenced in AGENT_WORKFLOW                                                |

### 4.3 Tasks (tasks.json)

- **Setup Environment**, **Verify Credentials**, **Test Shopify Connection**, **Run Tests**, **Run E2E**, **Lint**, **Format**, **Sync Products**, **Health Check**, **Shopify: Theme Dev** (preview + Live), **Open pending approval**.
- **Issue**: “Open pending approval” uses `Invoke-Item (Join-Path (Get-Location) 'docs/status/pending-approval.md')`. If cwd is not repo root, the path is wrong. Recommendation: document “Run tasks from repo root” in OPERATOR_RUNBOOK or use `$PSScriptRoot`/repo-root detection in a wrapper if feasible.

### 4.4 Context

- `context/github.md`, `context/shopify.md` present; used by handoff and agents. No issues found.

---

## 5. Docs vs Implementation Cross-Reference

### 5.1 Referenced and Present

- `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md` – exists; referenced by plan and rules.
- `docs/status/pending-approval.md` – exists.
- `docs/status/deploy-log.md` – exists.
- `docs/CREDENTIALS_SETUP.md` – referenced by env-credentials; exists.
- `docs/BROWSER_CREDENTIAL_FLOW.md` – referenced by env-credentials.mdc; exists.

### 5.2 Drift

- **agent-context.md** (prompts/): Project structure lists `src/browser-automation`, `src/desktop-automation` but not `src/shopify`. Repo has `src/shopify/themes/aodrop-theme/`. Recommendation: Add `src/shopify/` to the structure in agent-context.md.

### 5.3 Scripts Referenced in Docs/Workflows

- `scripts/shopify/sync-products.ps1` – exists; used in shopify-sync.yml and AGENT_WORKFLOW. Sync script does not load `.env.local` (relies on caller env); in Actions, secrets are injected. For local runs, run-runbook loads .env.local then runs other scripts; sync-products itself could load .env.local when present (like test-connection.ps1) for consistency.
- `scripts/shopify/theme-dev.ps1`, `scripts/shopify/update-theme.ps1` – referenced; exist.
- `scripts/debug/parse-all-ps1.ps1`, `scripts/run-everything-debug.ps1` – referenced in head-guru; exist.

---

## 6. Root-Level Reports and Proliferation

Root currently has many report/status-style markdown files, e.g.:

- AUDIT_REPORT.md, BUG_FIXES.md, CHANGELOG.md, CODE_REVIEW_SYNC.md, COMPLETION_REPORT.md, DESKTOP_AUTOMATION_IMPLEMENTATION.md, FINAL_IMPLEMENTATION_REPORT.md, FINAL_IMPLEMENTATION_SUMMARY.md, FINAL_VERIFICATION.md, FIXED_STATUS.md, FIXES_COMPLETE.md, IMPLEMENTATION_COMPLETE.md, IMPLEMENTATION_STATUS.md, MASTER_EXECUTION_REPORT.md, NEXT_STEPS.md, PHASE_1_AUDIT_SUMMARY.md, PHASE_1_EXECUTION_STATUS.md, REPOSITORY_STATUS.md (if present), SUB_ISSUES.md, SYSTEM_READY.md, ULTIMATE_MASTER_AGENT_EXECUTION_REPORT.md, etc.

**Issue**: Hard for new agents and humans to know which is current vs historical; overlaps with `docs/status/` and expert-analyses.

**Recommendation**: (1) Keep a small set at root (e.g. README.md, CHANGELOG.md, NEXT_STEPS.md, OPERATOR_RUNBOOK.md). (2) Move the rest to `docs/status/` or `archive/YYYY-MM-DD/` with an `ARCHIVE_NOTE.md` and a single `docs/status/INDEX_REPORTS.md` that lists and describes each report and its date. (3) In ao-guru.rules, “MASTER_EXECUTION_REPORT” could point to `docs/status/MASTER_EXECUTION_REPORT.md` after move.

---

## 7. Expert-Analyses vs Prompts

- **expert-analyses/**: 10 numbered audits (01_STRATEGIC_PLANNING … 10_MASTER_SYNTHESIS) plus README. These are past analysis deliverables.
- **prompts/expert-01-… expert-10-…**: Prompts to run experts for security, performance, code quality, etc.

Relationship: expert-analyses are outputs of past runs; expert prompts are the templates for future runs. No conflict; keep both. Optional: add a line in MASTER_10_EXPERT_SYSTEM or in docs pointing to `expert-analyses/` as “example outputs of expert runs.”

---

## 8. Bugs and Potential Problems

| Item                       | Severity | Description                                                                                                                                                                                                   |
| -------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **develop branch**         | Low      | CI, quality-check, deploy, sync reference `develop`; if repo is main-only, these branches never run or may fail. Confirm branch strategy and update workflows or add develop.                                 |
| **Lighthouse URL**         | Low      | Points to GitHub Pages; ensure that site is deployed from this repo and URL is correct.                                                                                                                       |
| **shopify-sync on Ubuntu** | Low      | Uses `pwsh` and `./scripts/shopify/sync-products.ps1`; script uses `$PSScriptRoot` for repo path. Should work; if not, use `scripts/shopify/sync-products.ps1` (no leading ./).                               |
| **sync-theme-branch**      | Low      | Depends on `src/shopify/themes/aodrop-theme/` existing with valid theme structure. Currently only README there; full theme must exist for Shopify connection. Document in launch checklist.                   |
| **Hardcoded repo path**    | Low      | Some scripts set `$repoPath = "C:\Users\LegiT\against-the-odds"` (e.g. test-connection.ps1 in some versions). Reduces portability; prefer `Split-Path -Parent (Split-Path -Parent $PSScriptRoot)` or similar. |

---

## 9. Cross-Comparative Progression Tracking

- **Phase 0**: Documented in PERFECT_EXECUTION_PROMPT; sign-off in `docs/status/PHASE_0_FINALIZATION.md` (“Phase 0 finalized; proceeding allowed.”). Progression: Phase 0 complete.
- **Launch**: `docs/launch/00_launch_checklist.md` and related launch docs define next steps; NEXT_STEPS.md and OPERATOR_RUNBOOK tie daily ops. No single “progress %” file; recommend one optional `docs/status/PROGRESS.md` with: Phase 0 (done), Launch checklist (items checked), Current focus (e.g. “Store readiness + theme + products”).
- **Agent runs**: HANDOFF*PROMPT_NEW_AGENT and system_finalization_report capture state for new agents; proceed*\*.md and status files in docs/status give recent execution notes. Aligned.

---

## 10. Prioritized Recommendations (Guru Task Management)

### P0 (Do first)

1. **Clarify post–Phase 0 prompt usage**: Add a short section to `docs/status/PLAN_AGENT_ENTRY.md` or create `docs/AGENT_PROMPT_DECISION_TREE.md`: “After Phase 0: for full audit use ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT; for 10-expert run use MASTER_10_EXPERT_SYSTEM; for finalization orchestration use head-guru-orchestrator.”
2. **CI vs quality-check**: Either merge into one workflow (lint, test, format, coverage, Trivy, Lighthouse) or document in `.github/workflows/README.md`: “CI = fast gate; quality-check = deep check; both run on same triggers.”

### P1 (High value)

3. **Consolidate root-level reports**: Move legacy reports to `docs/status/` or `archive/`; add `docs/status/INDEX_REPORTS.md`; keep only README, CHANGELOG, NEXT_STEPS, OPERATOR_RUNBOOK (and similar) at root.
4. **Deploy and backup-store**: Either implement deploy.yml and shopify-sync backup job or mark as placeholder and link to runbook/launch checklist.
5. **agent-context.md**: Add `src/shopify/` (and themes/aodrop-theme) to project structure.

### P2 (Nice to have)

6. **sync-products.ps1**: Load `.env.local` when present (same pattern as test-connection.ps1) for local runs.
7. **Tasks “Open pending approval”**: Document “run from repo root” or use repo-root detection so the path always resolves.
8. **Script portability**: Audit scripts for hardcoded `C:\Users\LegiT\against-the-odds`; replace with repo-root detection.

---

## 11. Summary Table: Alignment and Issues

| System                | Aligned   | Redundant / Unclear                             | Bugs / Risks                      |
| --------------------- | --------- | ----------------------------------------------- | --------------------------------- |
| Plan entry + Phase 0  | Yes       | —                                               | —                                 |
| Prompts               | Partially | Multiple masters; no decision tree              | —                                 |
| GitHub workflows      | Partially | CI vs quality-check; deploy/backup placeholders | develop branch; Lighthouse URL    |
| .cursor rules/plans   | Yes       | —                                               | Task cwd assumption               |
| Docs ↔ implementation | Mostly    | —                                               | agent-context missing src/shopify |
| Root reports          | —         | Proliferation                                   | —                                 |
| Scripts               | Yes       | —                                               | Hardcoded path in some            |

---

_End of audit. Execute P0/P1 recommendations with guru task management; re-run this audit after major changes to track progression._
