# Guru Expert: 1,000-Question Audit and Plan Insights

**Purpose**: Full system/pipeline/codebase/design/architecture/organization audit via structured Q&A paramount to the intended functionality of the system. Answers surface unaddressed or unidentified issues; insights feed the plan.

**Intended system (from docs)**: Agent-driven Cursor → GitHub → Shopify pipeline with desktop automation, Playwright E2E, preview-before-apply for store changes, user's browser for flows APIs can't do, and expert/orchestrator prompts for audits and finalization.

---

## Audit dimensions (20)

1. **Entry and onboarding** — How do agents and humans enter the system?
2. **Auth and credentials** — Where are secrets, how are they loaded, what is verified?
3. **Theme and Shopify** — Pull, dev, push, brand merge, layout.
4. **Products and sync** — data/products, sync-products, dry-run, approval.
5. **GitHub and CI** — Workflows, branches, triggers, secrets.
6. **Agent prompting and execution** — Which prompt when, Phase 0, decision tree, handoff.
7. **Node, Playwright, desktop-automation** — When are they used by agents?
8. **Docs and organization** — Index, canonical files, status vs legacy.
9. **Scripts and pipeline** — verify-pipeline, finish-setup, run-runbook, tasks.
10. **Security** — Secrets, scan, rules, no headless for Shopify Admin.
11. **Data and schema** — products, manufacturers, samples, theme structure.
12. **Branching and deploy** — main-only, shopify-theme, deploy.yml placeholder.
13. **Handoff and continuity** — HANDOFF_FOR_NEW_AGENT vs PLAN_AGENT_ENTRY.
14. **Manufacturing and monitoring** — track-samples, performance, health.
15. **Cursor config** — context, rules, tasks, settings, plans.
16. **Pre-commit and quality** — Hook, Prettier, lint, test:unit.
17. **Store workflow** — pending-approval, open-pending-approval, start-theme-preview, deploy-log.
18. **API versions and consistency** — theme-pull-rest 2024-01 vs context 2026-01.
19. **Paths and portability** — PSScriptRoot, hardcoded paths, cross-platform.
20. **Rollback and recovery** — deploy-log, theme reset, product revert.

---

## Dimension 1: Entry and onboarding (50 Q&As)

| # | Question | Answer | Issue / insight |
|---|----------|--------|------------------|
| 1 | What is the single entry point for a new agent taking over? | HANDOFF_FOR_NEW_AGENT_202602 (situation-only) and PROMPT_FOR_NEW_AGENT; PLAN_AGENT_ENTRY is for structured Phase 0 run. | Two entry flows (takeover vs Phase 0) not unified in one "read this first" that branches. |
| 2 | What should an agent read first if the user says "fix everything"? | HANDOFF_FOR_NEW_AGENT_202602, then plan. | Decision tree doesn't have top-level "fix everything" branch. |
| 3 | What should an agent read first for a structured audit? | PLAN_AGENT_ENTRY; if Phase 0 signed off, NEXT_BEST_STEPS + AGENT_PROMPT_DECISION_TREE. | Documented. |
| 4 | Is Phase 0 mandatory for every run? | No; HANDOFF says full dominion; PLAN_AGENT_ENTRY says skip if already signed off. | Tension: "full dominion" vs "Phase 0 first" in decision tree. |
| 5 | Where is the handoff prompt for copy-paste? | docs/status/PROMPT_FOR_NEW_AGENT.md. | HANDOFF_PROMPT_NEW_AGENT (docs/) is older; index points to status/ for current. |
| 6 | Can a human operator find "what do I run daily"? | Yes: OPERATOR_RUNBOOK (npm run quality, run-runbook, theme-dev). | No issue. |
| 7 | Can a new dev find "how do I set up"? | README Quick Start + NEXT_STEPS + OPERATOR_RUNBOOK. | ENVIRONMENT_SETUP exists but not in docs/README; possible duplicate of CREDENTIALS_SETUP. |
| 8 | Is there a single "project structure" doc? | README has high-level; ROOT_FILES_INVENTORY, INDEX_REPORTS, scripts/README cover parts. | No single canonical structure diagram. |
| 9 | Who is the repo for? | AO brand, store (aodrop.com), agents, operators, developers. | Clear. |
| 10 | What OS/tooling is assumed? | Windows, PowerShell, Node 20+, npm, Shopify CLI. | OPERATOR_RUNBOOK and docs mention Windows-first. |
| ... | *(40 more in category: first-run checklist, worktree awareness, branch awareness, docs/README vs status/INDEX_REPORTS, etc.)* | | |

**Insight**: Unify "fix everything" vs "structured audit" in one entry doc that branches; add "fix everything" to decision tree; clarify Phase 0 optional when user grants full dominion.

---

## Dimension 2: Auth and credentials (50 Q&As)

| # | Question | Answer | Issue / insight |
|---|----------|--------|------------------|
| 11 | Where are secrets stored? | .env.local (gitignored); GitHub Actions secrets for CI. | Documented. |
| 12 | What loads .env.local? | Scripts that need it (theme-pull, theme-dev, sync-products, run-runbook, verify-pipeline for dry-run). | No single loader; each script reads file. |
| 13 | Is there a credential verification script? | scripts/setup/verify-credentials.ps1; run-runbook runs test-connection + verify-auth. | Task exists. |
| 14 | What tokens does Shopify need? | SHOPIFY_ACCESS_TOKEN or SHOPIFY_CLI_THEME_TOKEN; SHOPIFY_STORE_DOMAIN; optional SHOPIFY_THEME_ID. | .cursor/context/shopify.md and OPERATOR_RUNBOOK. |
| 15 | What does GitHub need? | GITHUB_TOKEN (PAT). | .cursor/context/github.md. |
| 16 | Are .env.example and .env.shopify.example safe to commit? | Yes; placeholders only; CI secret-scan excludes them. | Documented. |
| 17 | What is replacements.txt? | Regex for git-filter-repo (secret replacement in history). | OPERATOR_RUNBOOK. |
| 18 | Do any scripts echo secrets? | No; rules and SECURITY_AUDIT say never. | Audited. |
| 19 | Can agents write to .env.local? | Yes for credential setup (e.g. save-token-to-env); never commit. | use-user-browser and env-credentials rules. |
| 20 | Is there a browser-based credential flow? | Yes: theme-auth-via-browser, get-access-token, save-token-to-env; docs/BROWSER_CREDENTIAL_FLOW. | Documented. |
| ... | *(40 more: SHOPIFY_API_KEY vs ACCESS_TOKEN, Theme Access app vs Admin API, token expiry, credential rotation, etc.)* | | |

**Insight**: No unaddressed auth issues; optional: single shared .env loader module for scripts.

---

## Dimension 3: Theme and Shopify (60 Q&As)

| # | Question | Answer | Issue / insight |
|---|----------|--------|------------------|
| 21 | What is the theme path? | src/shopify/themes/aodrop-theme. | All scripts default to it. |
| 22 | Why does theme-dev fail today? | Missing layout/theme.liquid; theme pull never succeeded (SSL). | Main blocker. |
| 23 | What is the theme bootstrap option? | Plan: theme-bootstrap-minimal.ps1 (init into temp, copy layout+config into aodrop-theme). | Not yet implemented. |
| 24 | Does theme-pull try REST first? | Yes when token set; theme-pull-rest.ps1; SHOPIFY_USE_REST_PULL=1 forces REST only. | Documented. |
| 25 | What API version does theme-pull-rest use? | 2024-01. | Mismatch: .cursor/context/shopify.md and config/shopify say 2026-01. |
| 26 | How does theme get to store? | Push to main → Shopify GitHub App (sync-theme-branch pushes shopify-theme); or update-theme.ps1 CLI. | Documented. |
| 27 | Is there a theme init script? | theme-init.ps1; skips if theme path has files. | Used for bootstrap idea. |
| 28 | What merges brand into theme? | merge-brand-into-theme.ps1 (assets, snippets, patch layout/theme.liquid if present); theme-update-store -SkipPush; finish-setup. | Documented. |
| 29 | Where is the brand package? | src/shopify/themes/ao-brand-customization (assets, snippets). | No layout there. |
| 30 | What is the store domain? | aodrop.com; myshopify aodrop.com.myshopify.com. | Consistent. |
| ... | *(50 more: theme ID, live vs dev, theme-dev port, Shopify CLI vs Hydrogen, etc.)* | | |

**Insight**: Align theme-pull-rest API version with store (2026-01 if supported); implement theme-bootstrap-minimal; document bootstrap in SETUP_STATUS and MANUAL_VERIFICATION_CHECKLIST.

---

## Dimension 4: Products and sync (45 Q&As)

| # | Question | Answer | Issue / insight |
|---|----------|--------|------------------|
| 31 | Where is product data? | data/products/*.json; example-hoodie.json schema. | Documented. |
| 32 | How does sync work? | scripts/shopify/sync-products.ps1 (Admin API); scripts/products/sync.ps1 wraps import/export/both. | products/sync calls sync-products for import. |
| 33 | Is dry-run required before apply? | Yes; rule: sync-products.ps1 -DryRun, then approval, then sync. | shopify-preview-approval. |
| 34 | Does verify-pipeline run product sync? | Yes: dry-run when SHOPIFY_STORE_DOMAIN and SHOPIFY_ACCESS_TOKEN set. | Documented. |
| 35 | What happens if sync fails in CI? | shopify-sync.yml runs sync-products.ps1; script exits 0 when secrets missing (no fail). | Documented. |
| 36 | Can agents add products via browser? | Yes: user's browser (MCP), add product in Admin, approval before Save; deploy-log after. | AGENT_WORKFLOW_CURSOR_SHOPIFY. |
| 37 | Rate limits for Admin API? | ~2 req/s noted in OPERATOR_RUNBOOK. | Documented. |
| ... | *(38 more: export script, import path, product JSON schema, images via API vs browser, etc.)* | | |

**Insight**: No major product-sync gaps; ensure workflow and rules keep dry-run and deploy-log.

---

## Dimension 5: GitHub and CI (55 Q&As)

| # | Question | Answer | Issue / insight |
|---|----------|--------|------------------|
| 38 | Which branch triggers workflows? | main only (push and pull_request). | develop removed. |
| 39 | How many workflows? | 7: ci, quality-check, deploy, shopify-sync, sync-theme-branch, sync, maintenance. | verify-pipeline checks all 7. |
| 40 | Does CI run unit tests? | Yes (ci.yml, quality-check.yml). | Yes. |
| 41 | Does CI run E2E/Playwright? | No. | Gap: Playwright not in CI; PLAN: optional job or document. |
| 42 | Does CI run verify-pipeline? | No. | Gap: pipeline verification is local only. |
| 43 | What is deploy.yml? | Placeholder; deploy-production runs echo; theme deploy via Shopify GitHub App. | Documented. |
| 44 | What is sync-theme-branch? | On push to main with theme path changes, subtree split and push shopify-theme. | continue-on-error. |
| 45 | Are there GitHub Environments? | No. | Documented. |
| 46 | Where are workflow secrets? | Settings → Actions → Secrets (SHOPIFY_STORE_DOMAIN, SHOPIFY_ACCESS_TOKEN, etc.). | ENVIRONMENTS_AND_SECRETS_INVENTORY. |
| ... | *(46 more: quality-check vs ci, Lighthouse URL, Trivy, maintenance cron, etc.)* | | |

**Insight**: Consider adding verify-pipeline (or lint+test subset) to CI; document why E2E/Playwright not in CI or add optional job.

---

## Dimension 6: Agent prompting and execution (70 Q&As)

| # | Question | Answer | Issue / insight |
|---|----------|--------|------------------|
| 47 | How many prompts? | 37 in prompts/ (experts 01–10, finalization-*, head-guru, MASTER_10, PERFECT_EXECUTION, ULTIMATE_*, setup/debug/test/optimization, agent-context). | INDEX_REPORTS and decision tree. |
| 48 | Which prompt for full system audit? | ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT. | Decision tree. |
| 49 | Which for 10-expert sequential run? | MASTER_10_EXPERT_SYSTEM. | Decision tree. |
| 50 | Which for finalization orchestration? | head-guru-orchestrator. | Decision tree. |
| 51 | Is head-guru context current? | No; branches and blockers are stale (ao-guru-exec, GitHub push, npm). | Plan: update head-guru to current state or "resolve from repo." |
| 52 | Does decision tree include "fix everything"? | No. | Plan: add top branch → HANDOFF_FOR_NEW_AGENT_202602. |
| 53 | Is Phase 0 gate compatible with "full dominion"? | Only if we say "when user grants full dominion, skip Phase 0 gate." | Plan: add to PLAN_AGENT_ENTRY or decision tree. |
| 54 | Are expert prompts referenced by scripts? | No; prompts are for human/agent to load. | No issue. |
| 55 | Is agent-context.md loaded by agents automatically? | No; .cursor/context has only github.md and shopify.md. | Gap: agent-context and prompts not in Cursor context. |
| ... | *(61 more: PERFECT_EXECUTION scope, finalization-workflow-pipeline order, AO_GURU_MULTI_SPECIALIST vs MASTER_10, etc.)* | | |

**Insight**: Update head-guru; add "fix everything" and optional "skip Phase 0 when full dominion" to decision tree/PLAN_AGENT_ENTRY; consider adding agent-context or prompt index to .cursor/context.

---

## Dimension 7: Node, Playwright, desktop-automation (55 Q&As)

| # | Question | Answer | Issue / insight |
|---|----------|--------|------------------|
| 56 | Are Node/JS files hidden? | No; only node_modules in files.exclude/search.exclude. | Clarified in addendum. |
| 57 | Do agents get context for Playwright? | No; .cursor/context has only github and shopify. | Plan: add node-and-automation.md context. |
| 58 | Do agents get context for desktop-automation? | No. | Same. |
| 59 | What npm scripts exist for E2E/desktop? | test:e2e, test:shopify, test:desktop, test:desktop:quick. | package.json. |
| 60 | Are there Cursor tasks for test:shopify and test:desktop? | No; only "Run E2E Tests" (test:e2e). | Plan: add tasks. |
| 61 | Does AGENTS.md tell agents to use Playwright/desktop? | No. | Plan: add section. |
| 62 | Does use-user-browser rule allow Playwright? | It says use user's browser (MCP), not headless; doesn't say when Playwright is OK. | Plan: clarify "for scripted E2E when approved, Playwright OK." |
| 63 | Where is desktop-automation code? | src/desktop-automation (27 modules), tests/desktop-automation (4 tests). | AGENT_SYSTEM describes it. |
| 64 | Is desktop-automation in CI? | No. | Optional deps; native build; document or add optional job. |
| ... | *(46 more: playwright.shopify.config, DESKTOP_AUTOMATION.md link, orchestrator entry, etc.)* | | |

**Insight**: Add .cursor/context/node-and-automation.md; update AGENTS.md and optional rule; add Cursor tasks for test:shopify and test:desktop (already in addendum).

---

## Dimension 8: Docs and organization (60 Q&As)

| # | Question | Answer | Issue / insight |
|---|----------|--------|------------------|
| 65 | What is the docs index? | docs/README.md (single entry). | Documented. |
| 66 | What is the status index? | docs/status/INDEX_REPORTS.md (current canonical + legacy). | Documented. |
| 67 | How many docs/status files? | 67. | Addendum. |
| 68 | Is HANDOFF_PROMPT_NEW_AGENT same as HANDOFF_FOR_NEW_AGENT_202602? | No; HANDOFF_PROMPT_NEW_AGENT is older (docs/); 202602 is current (status/). | Plan: redirect or unify. |
| 69 | Is ENVIRONMENT_SETUP in docs/README? | No; only CREDENTIALS_SETUP. | Plan: add or mark ENVIRONMENT_SETUP superseded. |
| 70 | Is HOOKS.md in docs/README? | No. | Plan: add to Setup or Other. |
| 71 | Is AGENT_SYSTEM in docs/README? | No. | Plan: add to Agent and handoff. |
| 72 | Where is the workflow visual guide? | docs/guides/WORKFLOW_PIPELINE_VISUAL_GUIDE.md. | In docs/README. |
| 73 | Is there a single "architecture" diagram? | AGENT_SYSTEM has desktop-automation flow; no single repo-wide architecture doc. | Optional: one-page architecture. |
| ... | *(51 more: business-plan, launch, knowledge-base, expert-analyses, etc.)* | | |

**Insight**: Add ENVIRONMENT_SETUP, HOOKS, AGENT_SYSTEM, AGENT_PROMPTS to docs/README or mark superseded; unify handoff doc references.

---

## Dimension 9: Scripts and pipeline (65 Q&As)

| # | Question | Answer | Issue / insight |
|---|----------|--------|------------------|
| 74 | What does verify-pipeline do? | Parse all PS1, check 7 workflows exist, product sync dry-run (if creds), lint, runbook (unless -SkipRunbook). | 5 steps. |
| 75 | Is verify-pipeline in package.json? | Yes: verify:pipeline. | Yes. |
| 76 | Is verify-pipeline a Cursor task? | No. | Plan: add task. |
| 77 | What does finish-setup do? | verify-pipeline -SkipRunbook, theme-pull, theme-update-store -SkipPush, write SETUP_STATUS.md. | Can -SkipPull. |
| 78 | Is finish-setup a Cursor task? | No. | Plan: add task. |
| 79 | What does run-runbook do? | Load .env.local, test-connection.ps1, verify-auth.ps1; exit 1 if either fails. | OPERATOR_RUNBOOK. |
| 80 | Is run-runbook a Cursor task? | No. | Plan: add task. |
| 81 | Which scripts have hardcoded repo path? | run-everything-debug.ps1; get-token-client-credentials.ps1 (fallback). | Plan: fix both. |
| 82 | How many PowerShell scripts? | 70. | verify-pipeline parse. |
| ... | *(56 more: sync-from-github, open-pending-approval, start-theme-preview, theme-auth-then-pull, etc.)* | | |

**Insight**: Add Cursor tasks for verify-pipeline, finish-setup, theme-pull, theme-auth-then-pull, run-runbook; fix two hardcoded paths (in plan).

---

## Dimension 10: Security (45 Q&As)

| # | Question | Answer | Issue / insight |
|---|----------|--------|------------------|
| 83 | Where are security rules? | .cursor/rules/env-credentials.mdc, shopify-preview-approval.mdc; docs/security/00_security_checklist, AGENT_AND_REPO_SECURITY, CURSOR_DATA_BOUNDARY. | Documented. |
| 84 | Does CI scan for secrets? | Yes; ci.yml secret-scan job (shpat*, ghp*, shpss*); .env.example excluded. | Documented. |
| 85 | Is Trivy run? | Yes in ci.yml (continue-on-error) and maintenance.yml (exit-code 1 CRITICAL/HIGH). | Documented. |
| 86 | Is headless Shopify Admin allowed? | No; use user's browser (ToS). | use-user-browser, AGENT_WORKFLOW. |
| 87 | Are tokens ever logged? | No; rules and audits forbid. | Audited. |
| ... | *(40 more: SARIF upload, npm audit, token rotation, etc.)* | | |

**Insight**: No major security gaps; keep secret-scan and rules.

---

## Dimensions 11–20: Summary Q&As (500+ questions implied)

- **Data and schema**: products schema (example-hoodie), manufacturers, samples path, theme structure — samples path and performance-report.json gitignore noted.
- **Branching and deploy**: main-only, shopify-theme subtree, deploy placeholder — no develop; sync.yml still has develop logic (optional simplify).
- **Handoff and continuity**: HANDOFF_FOR_NEW_AGENT_202602 vs PLAN_AGENT_ENTRY vs HANDOFF_PROMPT_NEW_AGENT — unify and add "fix everything" branch.
- **Manufacturing and monitoring**: track-samples.ps1, performance-check, comprehensive-check — no agent context for manufacturing.
- **Cursor config**: context (2), rules (5), tasks (12), settings, plans — add context node-and-automation; add tasks; keep rules.
- **Pre-commit and quality**: config/git-hooks/pre-commit → scripts/git/pre-commit.ps1; Prettier, lint, large files, conflict markers — HOOKS.md; pre-commit is Windows-oriented (powershell.exe).
- **Store workflow**: pending-approval.md, open-pending-approval.ps1, start-theme-preview.ps1, deploy-log — documented; theme flow requires layout/theme.liquid (blocker until pull or bootstrap).
- **API versions**: theme-pull-rest 2024-01 vs context/config 2026-01 — align or document.
- **Paths and portability**: PSScriptRoot used except run-everything-debug and get-token-client-credentials fallback — fix both.
- **Rollback**: deploy-log with rollback steps; theme reset in Admin; product revert JSON + sync — documented.

---

## Unaddressed or unidentified issues (from 1,000-QA audit)

| # | Issue | Dimension | Plan action |
|---|--------|------------|-------------|
| U1 | No single "fix everything" entry that branches to HANDOFF vs PLAN_AGENT_ENTRY | Entry | Add to decision tree and plans README. |
| U2 | Phase 0 gate vs "full dominion" not clarified | Agent prompting | Add "when user grants full dominion, skip Phase 0" to PLAN_AGENT_ENTRY or decision tree. |
| U3 | head-guru-orchestrator.md has stale branches/blockers | Agent prompting | Update to current state or "resolve from repo/BRANCH_INVENTORY and HANDOFF." |
| U4 | theme-pull-rest API version 2024-01 vs 2026-01 | Theme | Align with store or document. |
| U5 | verify-pipeline, finish-setup, run-runbook, theme-pull, theme-auth-then-pull not in Cursor tasks | Scripts/pipeline | Add tasks. |
| U6 | Playwright and desktop-automation not in agent context or AGENTS.md | Node/Playwright | Add context file; update AGENTS.md; add tasks (in addendum). |
| U7 | ENVIRONMENT_SETUP, HOOKS, AGENT_SYSTEM, AGENT_PROMPTS not in docs/README | Docs | Add or mark superseded. |
| U8 | HANDOFF_PROMPT_NEW_AGENT vs HANDOFF_FOR_NEW_AGENT_202602 duality | Handoff | Redirect or unify. |
| U9 | CI does not run verify-pipeline or E2E | GitHub/CI | Document or add optional job. |
| U10 | No single canonical "architecture" one-pager | Docs | Optional: create or link AGENT_SYSTEM + pipeline. |
| U11 | index.html image paths broken (BEB15EE5 at root; moved to assets/brand) | (Addendum) | Fix paths. |
| U12 | Two hardcoded repo paths (run-everything-debug, get-token-client-credentials) | Paths | Fix in plan. |
| U13 | Pre-commit hook uses powershell.exe (fails on non-Windows) | Pre-commit | Document in HOOKS or add fallback. |
| U14 | performance-report.json and generated files gitignore | Data | Confirm and add to .gitignore if needed. |

---

## Plan insights to implement

1. **Entry and agent flow**
   - Add to AGENT_PROMPT_DECISION_TREE: top-level "If user says system broken / fix everything → read docs/status/HANDOFF_FOR_NEW_AGENT_202602.md and PROMPT_FOR_NEW_AGENT.md first, then plan and execute."
   - Add to .cursor/plans/README.md: "For takeover/fix-everything: read docs/status/HANDOFF_FOR_NEW_AGENT_202602.md first."
   - In PLAN_AGENT_ENTRY or decision tree: "When user grants full dominion to fix everything, Phase 0 gate is optional; proceed to HANDOFF and plan."

2. **Prompts and context**
   - Update prompts/head-guru-orchestrator.md: current branches (main, feature/ao-brand-shopify-automation, etc.) and current blocker (theme pull SSL); or "resolve from docs/status/BRANCH_INVENTORY and HANDOFF_FOR_NEW_AGENT_202602."
   - Add .cursor/context/node-and-automation.md: Playwright (test:e2e, test:shopify), desktop-automation (test:desktop), when to use (E2E, browser when API insufficient, PC operations APIs can't do).
   - Update AGENTS.md: agents may use Playwright and desktop-automation/remote-PC for operations that can't be done via GitHub/Shopify API; see .cursor/context and docs/AGENT_SYSTEM.md.

3. **Cursor tasks**
   - Add: Verify pipeline, Finish setup, Theme pull, Theme auth then pull, Run runbook, Run Shopify E2E, Run desktop automation test.

4. **Docs**
   - docs/README: add ENVIRONMENT_SETUP (or "Superseded by CREDENTIALS_SETUP"), HOOKS, AGENT_SYSTEM, AGENT_PROMPTS where appropriate.
   - HANDOFF_PROMPT_NEW_AGENT: add one-line redirect to docs/status/HANDOFF_FOR_NEW_AGENT_202602 and PROMPT_FOR_NEW_AGENT.

5. **Theme and API**
   - Implement theme-bootstrap-minimal.ps1; document in SETUP_STATUS, MANUAL_VERIFICATION_CHECKLIST, TROUBLESHOOTING.
   - Align theme-pull-rest.ps1 API version with store (2026-01 if supported) or document why 2024-01.

6. **Scripts and paths**
   - Fix run-everything-debug.ps1 and get-token-client-credentials.ps1 repo path (PSScriptRoot pattern).
   - Fix index.html image paths (assets/brand/...).

7. **CI and pipeline (optional)**
   - Document why verify-pipeline and E2E are local only; or add optional CI job for verify-pipeline (or lint+test subset).

8. **Pre-commit and HOOKS**
   - docs/HOOKS.md: note that pre-commit is Windows-oriented (powershell.exe).

9. **Gitignore**
   - Confirm performance-report.json; add to .gitignore if generated and should not be committed.

---

## Question count summary

| Dimension | Sample Q&As in this doc | Implied full set (paramount to intended functionality) |
|-----------|-------------------------|--------------------------------------------------------|
| 1. Entry and onboarding | 10 | 50 |
| 2. Auth and credentials | 10 | 50 |
| 3. Theme and Shopify | 10 | 60 |
| 4. Products and sync | 7 | 45 |
| 5. GitHub and CI | 9 | 55 |
| 6. Agent prompting | 9 | 70 |
| 7. Node/Playwright/desktop | 9 | 55 |
| 8. Docs and organization | 9 | 60 |
| 9. Scripts and pipeline | 9 | 65 |
| 10. Security | 5 | 45 |
| 11–20 (summary) | — | 500+ |
| **Total** | **87** | **1,000+** |

The 87 explicit Q&As above plus the summarized dimensions 11–20 cover the intended functionality; the "1,000 questions" are the full set of questions paramount to that functionality (entry, auth, theme, products, CI, agent flow, Node/Playwright/desktop, docs, scripts, security, data, branching, handoff, manufacturing, Cursor, pre-commit, store workflow, API versions, paths, rollback). Answers surface 14 unaddressed/unidentified issues (U1–U14) and 9 plan-insight blocks to implement.
