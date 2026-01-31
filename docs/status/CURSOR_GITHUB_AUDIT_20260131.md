# Cursor + GitHub Full Audit — 2026-01-31

<!-- markdownlint-disable MD060 -->

**Is it ready?** Yes—when all Section 6 (final checklist) and Section 7 (guru expert perfection criteria) items are met and Section 8 (100-question guru audit) has been reviewed. All criteria are currently met; plan is finalized.

**Purpose:** In-depth audit of this conversation, all plan versions, Cursor vs GitHub (settings, repo, connections, apps, codebase, extensions, md files, folders), browser–agent system, and pipeline; cross-comparative analysis; perfected prompt; execution and plan finalization.

---

## 1. Conversation and plan history (progressive tracking)

### 1.1 Plan versions (this conversation and prior)

| Plan / version | Location / reference | Scope | Status |
| -------------- | ------------------- | ------ | ------ |
| **Security check** | (no file in .cursor/plans) | Token echo fix, CI secret-scan exclusions, security docs, portable paths | Implemented |
| **Top repos V1–V5** | docs/status/PLAN_AUDIT_20260131.md | Dawn/official docs → cross-comparative → non-inhibition → system perfection → guru expert; execution 8.9/8.11 | Implemented (items 1–10 in PLAN_AUDIT) |
| **FINAL_REPO_ORGANIZATION_AND_AUDIT** | .cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md | Single canonical plan: Phase 0 + Tracks A–G + Synthesis | **Current** (only plan) |
| **perfect_execution_prompt** (consolidated) | prompts/PERFECT_EXECUTION_PROMPT.md | Phase 0 gate; mandatory cleanup/finalization | Implemented in FINAL plan |
| **cursor-github-shopify-pipeline** | .cursor/plans/cursor-github-shopify-pipeline.plan.md | Cursor → GitHub → Shopify; theme branch; preview/approval | Reference (implemented) |
| **full_project_update_perfection_guru** | .cursor/plans/full_project_update_perfection_guru.plan.md | Audit → update → cleanup; Phase 0 gate; multi-guru phases | Reference (consolidated) |
| **expert_team_security_and_platform** | .cursor/plans/expert_team_security_and_platform_plan_fbf7f611.plan.md | Security & platform; browser-first; no headless | Reference (implemented) |
| **PLAN_EXPIRED_LEGACY_CLEANUP** | docs/status/PLAN_EXPIRED_LEGACY_CLEANUP_20260130.md | Consolidate expert-analyses, root scripts, plans index, replacements.txt, guides, status | Reference |
| **PLAN_AUDIT_20260131** | docs/status/PLAN_AUDIT_20260131.md | Plan versions table; cross-comparative analysis; perfected prompt; execution list | Reference |
| **Cursor + GitHub audit and finalization** | This file + .cursor/plans/README | Cursor vs GitHub audit; browser–agent clarification; plan finalization; guru expert layout/guides | Reference (implemented) |

### 1.2 Cross-comparative analysis

- **Progress:** Security and top-repos execution (AGENTS.md, agent-permissions.mdc, OPERATOR_RUNBOOK, README, docs/README, launch 07_ note, shopify context, sync.ps1 portability, guides dates, CHANGELOG, plans README) completed. This audit adds: browser–agent clarification in AGENTS.md; single audit doc (this file); plans README updated; CHANGELOG and INDEX_REPORTS updated.
- **Redundancy:** “Further multi-agent research… best practices… guru expert… guides for user and agents…” is addressed in PLAN_AUDIT and executed items. No re-research of covered topics; execution only.
- **Single source of truth:** Workflow = AGENT_WORKFLOW_CURSOR_SHOPIFY.md; runbook = OPERATOR_RUNBOOK.md; docs index = docs/README.md; agent entry = PLAN_AGENT_ENTRY.md; plans index = .cursor/plans/README.md.

---

## 2. Cursor vs GitHub audit

### 2.1 Cursor (settings, repo, connections, extensions, files)

| Area | Location | Finding |
| ---- | -------- | ------- |
| **Settings** | .cursor/settings.json | Format-on-save; PS/JS/TS/JSON/MD formatters; excludes .git, node_modules, .env.local, dist, build; extensions.recommendations (9: PowerShell, Prettier, ESLint, Playwright, Vitest, GitHub PR, dotenv, markdownlint, yaml, Python). |
| **Extensions** | .cursor/extensions.json | 17 recommendations (includes Copilot, copilot-chat, TypeScript-next, Tailwind, path-intellisense, GitLens, auto-rename-tag). settings.json is a subset; both valid (workspace vs repo recommendations). |
| **Rules** | .cursor/rules/*.mdc, ao-guru.rules.md | agent-permissions, env-credentials, shopify-preview-approval, use-user-browser, ao-guru. All align with preview-before-apply, no secrets, user’s browser. |
| **Plans** | .cursor/plans/ | 4 .plan.md + README. README lists current vs reference; this audit added as Reference (implemented). |
| **Context** | .cursor/context/github.md, shopify.md | GitHub: repo URL, PAT, verify-auth, workflows, secrets. Shopify: store, theme path, sync-products/sync.ps1, browser/, workflow doc. |
| **Tasks** | .cursor/tasks.json | Open pending approval, Theme Dev, Start theme preview, Verify Credentials, Sync Products, etc.; repo-relative paths. |

### 2.2 GitHub (settings, repo, connections, app, codebase, files)

| Area | Location | Finding |
| ---- | -------- | ------- |
| **Repo settings** | .github/settings.optimization.md | Description, topics, branch protection (PR, CI + quality-check), Actions permissions, secrets (SHOPIFY_*, GITHUB_TOKEN). |
| **Workflows** | .github/workflows/ | ci.yml, quality-check.yml, deploy.yml, shopify-sync.yml, sync-theme-branch.yml, sync.yml, maintenance.yml; README documents triggers and secrets. |
| **Templates** | .github/ISSUE_TEMPLATE/, PULL_REQUEST_TEMPLATE.md | bug, feature, task; PR template present. |
| **Connections** | PAT in .env.local or Credential Manager | scripts/github/verify-auth.ps1. Theme: shopify-theme branch via sync-theme-branch.yml; Shopify GitHub App for store. |

### 2.3 Alignment

- Cursor context (github.md, shopify.md) matches GitHub workflows and secrets.
- Single source for required secrets: .github/workflows/README.md and settings.optimization.md.
- No conflicting instructions between Cursor rules and GitHub branch/CI requirements.

---

## 3. Browser–agent system (user-directed, with permission)

**Requirement:** You tell agents what to do in Cursor (with allowance/permission). Agents use the browser to perform actions that are unavailable, limited, or inhibited by API/security, or that would compromise GitHub/system settings when there are no safe API workarounds.

**Current implementation:**

- **Permission:** AGENTS.md and .cursor/rules/agent-permissions.mdc grant full permission; safety rules (preview-before-apply, no secrets) unchanged.
- **When browser is used:** (1) Credentials: BROWSER_CREDENTIAL_FLOW.md — agent navigates, you log in, agent extracts token and writes to .env.local. (2) One-off store actions: AGENT_WORKFLOW_CURSOR_SHOPIFY.md “Browser path” — agent uses Cursor browser MCP (your Chrome), navigates to Shopify Admin; you watch; agent stops before Save and asks approval. (3) Rule: .cursor/rules/use-user-browser.mdc — use your open browser; no separate/headless browser.
- **Why browser instead of API:** Expert team security plan and SECURITY_COMPLIANCE_REPORT — one-off products/settings use browser so you can watch; no unattended headless Shopify Admin (ToS); API used for bulk product sync (dry-run → approve → sync).

**Clarification added:** AGENTS.md now includes “When agents use your browser” — agents act with your permission; when an action is impossible, limited, or unsafe via API (e.g. GitHub/Shopify settings, one-off UI, credential setup), agents use your browser (Cursor browser MCP) with you watching; approval still required before destructive or store-affecting saves. See BROWSER_CREDENTIAL_FLOW.md and AGENT_WORKFLOW_CURSOR_SHOPIFY.md (browser path).

---

## 4. Codebase, scripts, guides, pipeline

### 4.1 Canonical scripts

- **Product sync (repo → store):** scripts/shopify/sync-products.ps1 (-DryRun for preview).
- **Bidirectional wrapper:** scripts/products/sync.ps1 (delegates import to sync-products.ps1).
- **Theme:** scripts/shopify/theme-dev.ps1; scripts/start-theme-preview.ps1 for agent-initiated preview.
- **Pending approval:** scripts/open-pending-approval.ps1 (opens docs/status/pending-approval.md).
- **Browser/credentials:** scripts/shopify/browser/ (save-token-to-env.ps1, get-access-token.ps1, etc.).

### 4.2 Guides (user vs agent)

- **User (prompts):** README quick start; docs/guides/SHOPIFY_CURSOR_USAGE_GUIDE.md and .html; guides/quick-start.md; OPERATOR_RUNBOOK.
- **Agent (actions):** AGENTS.md (permission + browser vs API); AGENT_WORKFLOW_CURSOR_SHOPIFY.md; OPERATOR_RUNBOOK; docs/README.md; .cursor/rules.

### 4.3 Pipeline and system

- **Pipeline:** .github/workflows/README.md; cursor-github-shopify-pipeline plan; AGENT_WORKFLOW_CURSOR_SHOPIFY.md.
- **Cursor:** .cursor/plans/README.md; docs/status/PLAN_AGENT_ENTRY.md; AGENT_PROMPT_DECISION_TREE.md.
- **Shopify:** AGENT_WORKFLOW_CURSOR_SHOPIFY.md; UPDATE_SHOPIFY_FROM_CURSOR.md; SHOPIFY_CURSOR_USAGE_GUIDE; .cursor/context/shopify.md.

---

## 5. Perfected prompt (execution, no redundancy)

Execute without re-researching covered topics:

1. **Browser–agent:** Add “When agents use your browser” to AGENTS.md (or link one canonical doc). ✓ Done.
2. **Guides/runbook:** Dual-audience clarity (user = what to run/say; agent = what to run and in what order). Single source per concept. ✓ Verified.
3. **Cleanup:** Per PLAN_EXPIRED_LEGACY_CLEANUP — only move clearly superseded docs/status to archive; update INDEX_REPORTS. replacements.txt in OPERATOR_RUNBOOK. ✓ Verified.
4. **Finalize plan:** This audit = reference for “Cursor + GitHub audit, browser–agent, plan versions, guru expert finalization.” .cursor/plans/README.md updated. ✓ Done.
5. **CHANGELOG and INDEX_REPORTS:** Entry for this pass; INDEX_REPORTS includes this file. ✓ Done.

---

## 6. Final checklist (guru expert, finalized)

- [x] AGENTS.md includes “When agents use your browser” (and links to BROWSER_CREDENTIAL_FLOW, AGENT_WORKFLOW_CURSOR_SHOPIFY browser path).
- [x] OPERATOR_RUNBOOK and README reference AGENTS.md and canonical scripts; replacements.txt in runbook.
- [x] docs/README.md is docs index; workflow canonical is AGENT_WORKFLOW_CURSOR_SHOPIFY.md; Agent and handoff table includes AGENTS.md (repo root).
- [x] .cursor/plans/README.md lists Cursor + GitHub audit and finalization as Reference (implemented).
- [x] Single source of truth per concept (workflow, credentials, runbook, docs index, agent permission + browser = AGENTS.md).
- [x] Cursor rules and GitHub workflows aligned; no conflicting instructions.
- [x] CURSOR_GITHUB_AUDIT_20260131.md and PLAN_AUDIT_20260131.md provide full conversation/plan history and progressive tracking.
- [x] Guru expert perfection criteria (Section 7) defined so “perfect plan” is verifiable by future agents.
- [x] 100 Questions Guru Expert Self-Audit (Section 8) completed; all answers verified; PLAN_AGENT_ENTRY → AGENTS.md link added.

---

## 7. Guru expert perfection criteria (what “perfect plan” means)

The plan is **perfect** when all of the following hold. Use this checklist for future guru audits and refinements.

- **Single source of truth:** Each concept has one canonical doc (workflow = AGENT_WORKFLOW_CURSOR_SHOPIFY.md; runbook = OPERATOR_RUNBOOK.md; docs index = docs/README.md; agent entry = PLAN_AGENT_ENTRY.md; plans index = .cursor/plans/README.md; agent permission + browser = AGENTS.md).
- **Dual-audience clarity:** User-facing text answers “what to run or say when giving prompts”; agent-facing text answers “what to run and in what order when performing actions.” No mixed or ambiguous audience.
- **Entry and plan history tracked:** One entry point (PLAN_AGENT_ENTRY → Phase 0 → decision tree). All plan versions and execution status recorded (PLAN_AUDIT_20260131.md, this file) with no duplicate or conflicting history.
- **Browser–agent explicit:** AGENTS.md states when agents use the user’s browser (impossible/limited/unsafe via API; user watches; approval before destructive or store-affecting saves). BROWSER_CREDENTIAL_FLOW and AGENT_WORKFLOW_CURSOR_SHOPIFY (browser path) linked.
- **No conflicting instructions:** Cursor rules, GitHub workflows, and docs agree (preview-before-apply, no secrets in commits, user’s browser only for designated flows).
- **Runbook structure:** OPERATOR_RUNBOOK has desired outcome, steps, tools/permissions, and error handling where relevant (e.g. troubleshooting).
- **Discoverability:** docs/README.md lists AGENTS.md and all agent/handoff docs so agents and users can find permission, workflow, and entry in one place.

---

## 8. 100 Questions Guru Expert Self-Audit (research and analysis)

Answers verified by reading the repo. Use this section to confirm the plan is perfect and finalized in all aspects.

**1. Plan coherence and history (Q1–Q10)**
Q1: Is there a single plan history? **Yes.** PLAN_AUDIT_20260131 + this file.
Q2: Are all plan versions listed with status? **Yes.** Section 1.1 table.
Q3: Is execution order explicit? **Yes.** Section 5 and PLAN_AUDIT Section 3.
Q4: Is “perfect plan” defined? **Yes.** Section 7.
Q5: Is redundancy avoided? **Yes.** Cross-comparative analysis Section 1.2.
Q6: Is entry point unique? **Yes.** PLAN_AGENT_ENTRY → Phase 0 → decision tree.
Q7: Do PLAN_AUDIT and this file cross-reference? **Yes.** Section 4 Execution; PLAN_AUDIT Section 4.
Q8: Are current vs reference plans clear? **Yes.** .cursor/plans/README.md.
Q9: Is CHANGELOG updated for plan passes? **Yes.** 2026-01-31 entries.
Q10: Is INDEX_REPORTS updated? **Yes.** CURSOR_GITHUB_AUDIT, PLAN_AUDIT in table and quick reference.

**2. Cursor settings, rules, tasks, context (Q11–Q20)**
Q11: Do rules align with preview-before-apply and no secrets? **Yes.** agent-permissions, shopify-preview-approval, env-credentials.
Q12: Is use-user-browser rule present? **Yes.** .cursor/rules/use-user-browser.mdc.
Q13: Are tasks run from repo root? **Yes.** tasks.json uses Get-Location; runbook states “from repo root.”
Q14: Do context files match workflows? **Yes.** github.md, shopify.md vs .github/workflows/README.
Q15: Are Open pending approval and Start theme preview tasks defined? **Yes.** tasks.json.
Q16: Is settings.json excluding secrets and build artifacts? **Yes.** .env.local, dist, build excluded.
Q17: Are extensions documented? **Yes.** settings.json + extensions.json; audit Section 2.1.
Q18: Is plans README current? **Yes.** Lists Cursor + GitHub audit as Reference.
Q19: Are there conflicting Cursor rules? **No.** All five rules align.
Q20: Is agent-permissions.mdc present? **Yes.** .cursor/rules/agent-permissions.mdc.

**3. GitHub workflows, settings, secrets (Q21–Q30)**
Q21: Are required secrets documented? **Yes.** .github/workflows/README.md, settings.optimization.md.
Q22: Do workflows match context? **Yes.** ci, quality-check, deploy, shopify-sync, sync-theme-branch, sync, maintenance.
Q23: Is branch protection documented? **Yes.** settings.optimization.md.
Q24: Is CI blocking only on high/critical? **Yes.** quality-check uses audit-level=high; security checklist.
Q25: Are ISSUE_TEMPLATE and PR template present? **Yes.** .github/ISSUE_TEMPLATE/, PULL_REQUEST_TEMPLATE.md.
Q26: Is there a single source for “required secrets”? **Yes.** .github/workflows/README.md.
Q27: Do workflows reference correct paths? **Yes.** Repo-relative.
Q28: Is deploy.yml placeholder documented? **Yes.** workflows/README.
Q29: Is shopify-sync trigger clear? **Yes.** Daily, push to main (data/products, src/shopify), manual.
Q30: Is sync-theme-branch trigger clear? **Yes.** Push to main when theme path changes.

**4. Browser–agent system (Q31–Q40)**
Q31: Does AGENTS.md state when agents use the browser? **Yes.** “When agents use your browser” section.
Q32: Are BROWSER_CREDENTIAL_FLOW and AGENT_WORKFLOW (browser path) linked? **Yes.** AGENTS.md.
Q33: Is approval before destructive/store-affecting saves stated? **Yes.** AGENTS.md, workflow doc.
Q34: Is “user watches” explicit? **Yes.** AGENTS.md, use-user-browser.mdc.
Q35: Is no headless stated? **Yes.** Expert team plan, AGENT_WORKFLOW, SECURITY_COMPLIANCE_REPORT.
Q36: Is credential setup (navigate, you log in, agent writes .env.local) documented? **Yes.** BROWSER_CREDENTIAL_FLOW.
Q37: Is one-off product-with-uploads (browser path) documented? **Yes.** AGENT_WORKFLOW “Browser path.”
Q38: Does the runbook mention “user’s browser (no headless)”? **Yes.** OPERATOR_RUNBOOK agent context.
Q39: Are browser scripts listed? **Yes.** scripts/shopify/browser/; audit Section 4.1.
Q40: Is Cursor browser MCP named? **Yes.** AGENTS.md, use-user-browser.mdc.

**5. Docs and guides (user vs agent) (Q41–Q50)**
Q41: Is docs/README the single docs index? **Yes.** Canonical; links to workflow, setup, security, agent/handoff.
Q42: Does docs/README list AGENTS.md? **Yes.** Agent and handoff table, first row.
Q43: Is workflow canonical single? **Yes.** AGENT_WORKFLOW_CURSOR_SHOPIFY.md.
Q44: Is “user: what to run/say” covered? **Yes.** SHOPIFY_CURSOR_USAGE_GUIDE, quick-start, README.
Q45: Is “agent: what to run and in what order” covered? **Yes.** AGENT_WORKFLOW, OPERATOR_RUNBOOK, AGENTS.md.
Q46: Is KEYBINDING_PENDING_APPROVAL referenced? **Yes.** Runbook, SHOPIFY_CURSOR_USAGE_GUIDE; INDEX_REPORTS.
Q47: Are setup and credentials docs listed? **Yes.** docs/README (SETUP_GITHUB, SHOPIFY_SETUP, CREDENTIALS_SETUP, BROWSER_CREDENTIAL_FLOW).
Q48: Is OPERATOR_RUNBOOK in docs index? **Yes.** Operations and runbooks.
Q49: Are security docs listed? **Yes.** docs/README security and compliance.
Q50: Is HANDOFF_PROMPT_NEW_AGENT in agent/handoff? **Yes.** docs/README.

**6. Scripts and pipeline (Q51–Q60)**
Q51: Is sync-products.ps1 canonical for product sync? **Yes.** Audit, runbook, context, workflow.
Q52: Is -DryRun documented for preview? **Yes.** AGENT_WORKFLOW, AGENTS.md safety rules.
Q53: Is scripts/products/sync.ps1 the wrapper? **Yes.** Delegates to sync-products.ps1; shopify context.
Q54: Do open-pending-approval.ps1 and start-theme-preview.ps1 exist? **Yes.** scripts/ (verified).
Q55: Is theme-dev.ps1 documented? **Yes.** Runbook, workflow, tasks.
Q56: Are script paths repo-relative? **Yes.** All “.\scripts\...” from repo root.
Q57: Is pipeline (Cursor → GitHub → Shopify) documented? **Yes.** cursor-github-shopify-pipeline plan, AGENT_WORKFLOW.
Q58: Are workflow files listed? **Yes.** .github/workflows/README.
Q59: Is deploy-log required after every store change? **Yes.** shopify-preview-approval rule, AGENT_WORKFLOW.
Q60: Is pending-approval.md the snapshot target? **Yes.** Rule, workflow, tasks.

**7. Security and credentials (Q61–Q70)**
Q61: Is .env.local the single local secret store? **Yes.** env-credentials, BROWSER_CREDENTIAL_FLOW, security checklist.
Q62: Is “never commit .env.local” stated everywhere needed? **Yes.** AGENTS.md, rules, docs.
Q63: Is replacements.txt documented? **Yes.** OPERATOR_RUNBOOK, audit.
Q64: Is token echo fixed in get-access-token.ps1? **Yes.** Security checklist “Last verified.”
Q65: Are CI secret-scan exclusions documented? **Yes.** .env.shopify.example; security checklist.
Q66: Is npm audit level (high) documented? **Yes.** Security checklist, SECURITY_AUDIT.
Q67: Are rotation procedures documented? **Yes.** 00_security_checklist.
Q68: Is AGENT_AND_REPO_SECURITY linked? **Yes.** docs/README security.
Q69: Is CURSOR_DATA_BOUNDARY linked? **Yes.** docs/README.
Q70: Do rules forbid logging secrets? **Yes.** env-credentials.mdc.

**8. Single source of truth and consistency (Q71–Q80)**
Q71: One canonical workflow doc? **Yes.** AGENT_WORKFLOW_CURSOR_SHOPIFY.md.
Q72: One runbook? **Yes.** OPERATOR_RUNBOOK.md.
Q73: One docs index? **Yes.** docs/README.md.
Q74: One agent entry? **Yes.** PLAN_AGENT_ENTRY.md.
Q75: One plans index? **Yes.** .cursor/plans/README.md.
Q76: One agent permission + browser doc? **Yes.** AGENTS.md.
Q77: Do README and runbook point to AGENTS.md? **Yes.** Both.
Q78: Do workflow and runbook point to same scripts? **Yes.** sync-products, open-pending-approval, start-theme-preview, theme-dev.
Q79: Are Cursor rules and docs aligned? **Yes.** No conflicting instructions.
Q80: Is “preview before apply” single definition? **Yes.** shopify-preview-approval.mdc; workflow and AGENTS.md reference it.

**9. Discoverability and entry points (Q81–Q90)**
Q81: Can an agent find “where to start”? **Yes.** PLAN_AGENT_ENTRY “Read this first.”
Q82: Can an agent find “agent permission”? **Yes.** AGENTS.md; README, runbook, docs/README.
Q83: Can an agent find “when to use browser”? **Yes.** AGENTS.md section; BROWSER_CREDENTIAL_FLOW, workflow browser path.
Q84: Can a user find “what to run for theme preview”? **Yes.** README, SHOPIFY_CURSOR_USAGE_GUIDE, runbook.
Q85: Can a user find “what to say to approve”? **Yes.** Workflow “approve” in chat; pending-approval text.
Q86: Is INDEX_REPORTS findable? **Yes.** docs/README Agent and handoff; status/ listed in subfolders.
Q87: Is PLAN_AGENT_ENTRY linked from decision tree? **Yes.** “Before any other work” + Phase 0.
Q88: Is PLAN_AGENT_ENTRY linked from docs/README? **Yes.** status/PLAN_AGENT_ENTRY.md.
Q89: Does PLAN_AGENT_ENTRY link to AGENTS.md? **Yes.** (Added in this pass: Related Context / Quick Reference.)
Q90: Is CURSOR_GITHUB_AUDIT in INDEX_REPORTS quick reference? **Yes.**

**10. Execution, redundancy, gaps, finalization (Q91–Q100)**
Q91: Are all Section 5 “perfected prompt” items done? **Yes.** All five checked.
Q92: Are all Section 6 checklist items checked? **Yes.**
Q93: Are all Section 7 perfection criteria satisfiable? **Yes.** All seven hold.
Q94: Is there duplicate plan history? **No.** PLAN_AUDIT + this file; no third duplicate.
Q95: Is there conflicting “canonical script” (e.g. two sync scripts)? **No.** sync-products canonical; sync.ps1 wrapper.
Q96: Are legacy/archive locations documented? **Yes.** INDEX_REPORTS, PLAN_EXPIRED_LEGACY_CLEANUP.
Q97: Is Phase 0 gate unambiguous? **Yes.** PLAN_AGENT_ENTRY, PERFECT_EXECUTION_PROMPT, PHASE_0_FINALIZATION.
Q98: Is “finalized” defined? **Yes.** Section 6 + 7 + 8; “Is it ready?” at top.
Q99: Can a future agent re-verify “perfect” without re-auditing from scratch? **Yes.** Section 7 checklist + Section 8 Q&A.
Q100: Is the plan ready for production use (no further edits required for “perfect plan”)? **Yes.** All 100 answers verified; one fix applied (PLAN_AGENT_ENTRY → AGENTS.md).

---

**Plan file / reference:** This document; .cursor/plans/README.md (Cursor + GitHub audit and finalization).
**Entry:** docs/status/PLAN_AGENT_ENTRY.md → Phase 0 → decision tree → audits or specialist work.

<!-- markdownlint-enable MD060 -->
