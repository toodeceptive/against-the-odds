# Full System Audit and Fix — Addendum (No Stone Unturned)

**Purpose**: Exhaustive inventory and every identified issue so the plan addresses every file, folder, and directory. Merge this with the main plan when executing.

**Related**: [GURU_1000_QA_AUDIT_AND_INSIGHTS.md](GURU_1000_QA_AUDIT_AND_INSIGHTS.md) — guru expert 1,000-question audit (20 dimensions, Q&As paramount to intended functionality); unaddressed issues U1–U14 and plan insights derived from answers. Implement those insights together with this addendum.

---

## 1. Complete directory and file inventory

### Root (every file/dir)

| Item | Purpose / note |
|------|----------------|
| `.cursor/` | context (2), plans (2), rules (5), tasks.json, settings.json, worktrees.json, extensions.json |
| `.editorconfig` | Editor defaults |
| `.env.example` | Env template |
| `.env.shopify.example` | Shopify env template |
| `.github/` | ISSUE_TEMPLATE (3), PULL_REQUEST_TEMPLATE, settings.optimization, workflows (7 + README) |
| `.gitignore` | Ignores node_modules, .env.local, dist, etc.; package-lock.json committed |
| `.prettierrc.json` | Prettier config |
| `AGENTS.md` | Agent permission, browser use |
| `archive/` | 2026-01-30 (expert-analyses-legacy 11, status-legacy 8, + many reports); ARCHIVE_LOG |
| `assets/` | brand (7 PNG + README), drop01 (artwork, exports, mockups, spec-pack, READMEs) |
| `CHANGELOG.md` | Version history |
| `config/` | git-hooks/pre-commit, github-auth.md, shopify/.shopify-cli.yml, README |
| `data/` | products (.gitkeep, example-hoodie.json), manufacturers (.gitkeep, example-manufacturer.json), samples (.gitkeep), README |
| `docs/` | **141 files total**: root-level (AGENT_*, SETUP_*, TROUBLESHOOTING, etc.), business-plan (3+), decisions (1), expert-analyses (2), guides (6), knowledge-base (8), launch (10), security (3), **status (77)**, screenshots/README |
| `eslint.config.mjs` | ESLint 9 flat config |
| `index.html` | Root HTML; references styles.css, BEB15EE5...png (see issues) |
| `LICENSE` | UNLICENSED |
| `NEXT_STEPS.md` | Next steps |
| `OPERATOR_RUNBOOK.md` | Daily checks, Shopify, credentials |
| `package.json` | npm scripts, deps |
| `package-lock.json` | Committed for CI |
| `playwright.config.js` | Playwright default |
| `playwright.shopify.config.js` | Shopify E2E |
| `prompts/` | 37 files (experts 01–10, finalization-*, head-guru, MASTER_10, PERFECT_EXECUTION, ULTIMATE_*, setup/debug/testing/optimization, agent-context, agent-capabilities) |
| `README.md` | Project overview |
| `replacements.txt` | git-filter-repo regex; documented in OPERATOR_RUNBOOK |
| `scripts/` | 70 PS1 + README (see scripts inventory below) |
| `src/` | browser-automation (2), desktop-automation (27 modules), shopify/themes (ao-brand-customization, aodrop-theme) |
| `styles.css` | Root CSS (used by index.html) |
| `tests/` | unit (1), integration (2), e2e (2), shopify-admin (1), desktop-automation (4) |
| `vitest.config.js` | Vitest |

### scripts/ (every script)

- **Root**: open-pending-approval.ps1, run-everything-debug.ps1, run-runbook.ps1, start-theme-preview.ps1, sync-from-github.ps1, verify-pipeline.ps1, setup-env.ps1
- **archive/root-scripts-legacy**: create-and-push.ps1, create-repo.ps1, sync-repository.ps1
- **debug**: parse-all-ps1.ps1
- **desktop-automation**: test-system.ps1
- **docs**: auto-generate.ps1
- **git**: auto-commit.ps1, auto-push.ps1, pre-commit.ps1, sync-repo.ps1
- **github**: optimize-repo.ps1, test-push-pull.ps1, verify-auth.ps1, verify-secrets.ps1
- **health**: alert-on-issues.ps1, auto-repair.ps1, comprehensive-check.ps1, generate-report.ps1, monitor-continuously.ps1
- **maintenance**: security-scan.ps1, update-dependencies.ps1
- **manufacturing**: track-samples.ps1
- **monitoring**: performance-check.ps1
- **pm**: create-task.ps1, update-status.ps1
- **products**: export.ps1, import.ps1, sync.ps1
- **quality**: check-all.ps1
- **reporting**: generate-status.ps1
- **setup**: auto-configure-env.ps1, verify-credentials.ps1
- **shared**: utilities.ps1
- **shopify**: copy-brand-images-to-theme.ps1, Ensure-ShopifyCli.ps1, fetch-store-data.ps1, finish-setup.ps1, merge-brand-into-theme.ps1, sync-products.ps1, test-connection.ps1, theme-auth-then-pull.ps1, theme-auth-via-browser.ps1, theme-dev.ps1, theme-init.ps1, theme-pull-and-preview.ps1, theme-pull-rest.ps1, theme-pull.ps1, theme-update-store.ps1, update-theme.ps1; **shopify/browser**: backup-store-settings.ps1, check-app-installation.ps1, extract-theme-info.ps1, get-access-token.ps1, get-theme-id.ps1, get-token-client-credentials.ps1, launch-chrome-for-agent.ps1, save-token-to-env.ps1, verify-store-setup.ps1
- **sync**: auto-fix.ps1, health-check.ps1, sync-all.ps1, verify-all.ps1
- **test**: run-all.ps1

### docs/status/ (77 files)

ARCHITECTURE_CODE_QUALITY_REPORT, AUDIT_CODE_CONFIG_20260130, AUDIT_CURSOR_WORKSPACE_20260130, AUDIT_DOCS_ORGANIZATION_20260130, AUDIT_PROMPTS_AGENTS_20260130, AUDIT_SCRIPTS_20260130, AUDIT_WORKFLOWS_20260130, blocker_resolution_commands_20260129, BRANCH_INVENTORY, BRAND_THEME_CUSTOMIZATION_20260201, CLEANUP_LOG_20260130, CODE_QUALITY_PHASE1_20260130, CODEBASE_AUDIT_20260131, CONSOLIDATION_LOG, CONVERSATION_AUDIT, COVERAGE_REMEDIATION_PLAN, CURSOR_GITHUB_AUDIT_20260131, CURSOR_WORKSPACE_AUDIT_20260130, deploy-log, E2E_REPORT, ENVIRONMENTS_AND_SECRETS_INVENTORY, EXPECTATIONS_CHECKLIST, FINALIZATION_AUDIT_20260131, FINALIZATION_COMPLETE_20260201, FINALIZATION_THEME_FLOW_20260201, FULL_SYSTEM_ANALYSIS, FULL_SYSTEM_AUDIT_20260201, FULL_SYSTEM_FILE_AUDIT_20260130, GURU_COMPLETION_SUMMARY, GURU_EXPERT_ANALYSIS_20260131, GURU_MULTI_AGENT_AUDIT_REPORT_20260130, GURU_PRETTIER_AUTOMATION_20260201, GURU_REVIEW_THEME_CUSTOMIZATION_20260201, HANDOFF_FOR_NEW_AGENT_202602, IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY, INDEX_REPORTS, LOCAL_PC_SPECS, MANUAL_VERIFICATION_CHECKLIST, MASTER_SYNTHESIS_REPORT_20260130, MULTI_AGENT_PERFECTION_RUN_20260130, NEXT_BEST_STEPS_20260131, OPTIMIZATION_REPORT, pending-approval, PERFORMANCE_NOTES_20260130, performance-report.json, PHASE_0_FINALIZATION, PHASE2_DELIVERABLES_20260130, PHASE3_DELIVERABLES_20260130, PIPELINE_FINALIZED, PLAN_AGENT_ENTRY, PLAN_AUDIT_20260131, PLAN_EXPIRED_LEGACY_CLEANUP_20260130, PLAN_HANDOFF_FOR_NEXT_AGENT, PROJECT_AUDIT_20260130, PROJECT_PERFECTED_20260130, PROJECT_UPDATE_PERFECTION_20260130, PROMPT_FOR_NEW_AGENT, PUSH_APPROVAL_20260201, ROOT_FILES_INVENTORY, SECURITY_AUDIT_20260130, SECURITY_COMPLIANCE_REPORT, SETUP_STATUS, SHOPIFY_ADMIN_CHECKLIST, system_finalization_report_20260129, TEST_COVERAGE_REPORT, THEME_UPDATE_PROOF, UPDATE_CHECKLIST_20260130, VERIFICATION_REPORT_20260130, VERSION_UPDATE_TABLE, WORKFLOW_OPS_AUDIT_REPORT, WORKTREE_INVENTORY.

### Missing from earlier inventory (gitignored or generated)

| Item | Purpose / note |
|------|----------------|
| `coverage/` | **41 files** — Vitest/coverage output; **gitignored**. |
| `playwright-report/` | Playwright HTML report; **gitignored**. |
| `test-results/` | Playwright test results; **gitignored**. |
| `.vscode/` | 2 files (if present); **gitignored**. |

### Total file count (on disk, excluding .git and node_modules)

**~476 files.** Tracked (excluding gitignored coverage, playwright-report, test-results, .vscode): **~431 files.** Root: 22 files. .cursor: 16. .github: 13. archive: 47. assets: 19. config: 4. data: 6. docs: 141. prompts: 37. scripts: 71. src: 45. tests: 10.

### .github/workflows/

ci.yml, deploy.yml, maintenance.yml, quality-check.yml, shopify-sync.yml, sync-theme-branch.yml, sync.yml, README.md.

### config/

git-hooks/pre-commit (shell wrapper → scripts/git/pre-commit.ps1), github-auth.md, shopify/.shopify-cli.yml (store aodrop.com, API 2026-01), README.md.

### .cursor/

context/github.md, shopify.md; plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md, README.md; rules/agent-permissions.mdc, ao-guru.rules.md, env-credentials.mdc, shopify-preview-approval.mdc, use-user-browser.mdc; settings.json, tasks.json, worktrees.json, extensions.json.

---

## 2. All additional problems (beyond main plan)

| # | Problem | Location | Fix |
|---|--------|----------|-----|
| 13 | **Hardcoded repo path** | scripts/shopify/browser/get-token-client-credentials.ps1 line 5: `else { "C:\Users\LegiT\against-the-odds" }` | Derive repo from PSScriptRoot (e.g. Resolve-Path Join-Path $PSScriptRoot "..\..\..") when $PSScriptRoot; only use fallback Get-Location or exit) |
| 14 | **index.html broken image paths** | index.html lines 18, 30, 52: BEB15EE5-E630-4BD8-9AC7-49DC8FB6E076.png at root; PNGs moved to assets/brand/ | Update src and og/twitter URLs to assets/brand/BEB15EE5-E630-4BD8-9AC7-49DC8FB6E076.png (or keep copy at root for GitHub Pages and document) |
| 15 | **docs/README missing entries** | docs/README.md does not list ENVIRONMENT_SETUP.md, HOOKS.md, AGENT_SYSTEM.md, AGENT_PROMPTS.md | Add to "Setup and credentials" or "Other" (or mark ENVIRONMENT_SETUP as superseded by CREDENTIALS_SETUP); add HOOKS, AGENT_SYSTEM, AGENT_PROMPTS where appropriate |
| 16 | **Pre-commit hook cross-platform** | config/git-hooks/pre-commit calls powershell.exe; fails on non-Windows (e.g. WSL without pwsh) | Document in docs/HOOKS.md that hook is Windows-oriented; or add branch for Unix (invoke pwsh or skip if not Windows) |
| 17 | **ENVIRONMENT_SETUP vs CREDENTIALS_SETUP** | docs/ENVIRONMENT_SETUP.md exists; docs/README only links CREDENTIALS_SETUP | Decide canonical: either add ENVIRONMENT_SETUP to docs/README or add one line in ENVIRONMENT_SETUP: "Superseded by CREDENTIALS_SETUP.md" and link |
| 18 | **sync.yml develop logic** | sync.yml still has steps that checkout/merge develop (with "if develop exists") | No bug; documented main-only. Optional: simplify by removing develop steps entirely for clarity |
| 19 | **maintenance.yml Trivy exit-code** | maintenance.yml security-scan job: exit-code: '1' on CRITICAL,HIGH — fails PRs | Document or continue-on-error if desired for weekly run |
| 20 | **package-lock.json** | .gitignore comment says "package-lock.json is committed" — list_dir shows it at root | No change; verify it is not in .gitignore so CI npm ci works |
| 21 | **docs/status/performance-report.json** | Gitignored pattern docs/screenshots/*.png; performance-report.json in status/ not gitignored | Confirm whether performance-report.json should be gitignored (generated); add to .gitignore if yes |
| 22 | **.cursor/extensions.json vs settings.json** | extensions.json has more recommendations (Copilot, etc.) than settings.json extensions.recommendations | Already documented in .cursor/plans/README; no change unless consolidating |
| 23 | **Playwright / Vitest configs** | playwright.config.js, playwright.shopify.config.js, vitest.config.js at root | No issue; referenced by npm scripts and CI |
| 24 | **data/samples** | data/samples has only .gitkeep; NEXT_STEPS says "samples.json (auto-managed)" | Confirm samples.json path (e.g. data/samples/samples.json) and ensure scripts use it consistently |
| 25 | **assets/drop01** | spec-pack, READMEs, .gitkeep in artwork/exports/mockups | No issue; manufacturing/spec pack structure documented |
| 26 | **archive/2026-01-30** | expert-analyses-legacy (11), status-legacy (8), many reports | No change; keep as-is per INDEX_REPORTS and ARCHIVE_LOG |
| 27 | **AGENT_PROMPT_DECISION_TREE "New-agent handoff"** | Points to docs/HANDOFF_PROMPT_NEW_AGENT.md; current entry is HANDOFF_FOR_NEW_AGENT_202602 | Add "If system broken / fix everything" branch → HANDOFF_FOR_NEW_AGENT_202602 + PROMPT_FOR_NEW_AGENT; align "New-agent handoff" row with status/ handoff |
| 28 | **.cursor/plans/README** | Entry is PLAN_AGENT_ENTRY → Phase 0; no mention of HANDOFF_FOR_NEW_AGENT_202602 for takeover | Add one line: "For takeover/fix-everything: read docs/status/HANDOFF_FOR_NEW_AGENT_202602.md first." |
| 29 | **verify-pipeline.ps1 repo path** | Uses (Resolve-Path (Join-Path $PSScriptRoot "..")).Path — PSScriptRoot is scripts/, so .. is repo | Correct. No change. |
| 30 | **run-runbook.ps1 repo path** | $repoRoot = Split-Path -Parent $PSScriptRoot (scripts/ → repo) | Correct. No change. |

---

## 3. Cross-reference and link checks

- **docs/README** links: OPERATOR_RUNBOOK (../), AGENTS (../), CREDENTIALS_SETUP, BROWSER_CREDENTIAL_FLOW, SETUP_GITHUB, SHOPIFY_SETUP, guides, launch, status, security, knowledge-base, business-plan, decisions, expert-analyses, screenshots, TROUBLESHOOTING, CODING_STANDARDS, CODE_REVIEW_PROCESS, MANUFACTURING, MONITORING, PROJECT_MANAGEMENT — all targets exist.
- **config/README** links: CREDENTIALS_SETUP, OPERATOR_RUNBOOK, HOOKS.md, data/README, scripts/README, FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md — all exist.
- **OPERATOR_RUNBOOK** links: AGENTS.md, docs/HOOKS.md, docs/status/deploy-log, docs/AGENT_WORKFLOW_CURSOR_SHOPIFY, docs/UPDATE_SHOPIFY_FROM_CURSOR, .cursor/context/shopify.md — all exist.
- **PLAN_AGENT_ENTRY** links: PHASE_0_FINALIZATION, CONSOLIDATION_LOG, NEXT_BEST_STEPS_20260131, AGENT_PROMPT_DECISION_TREE, PERFECT_EXECUTION_PROMPT, HANDOFF_PROMPT_NEW_AGENT (docs/), system_finalization_report — HANDOFF_PROMPT_NEW_AGENT is at docs/HANDOFF_PROMPT_NEW_AGENT.md (exists). All exist.
- **AGENT_PROMPT_DECISION_TREE** "New-agent handoff" → docs/HANDOFF_PROMPT_NEW_AGENT.md exists; add branch for HANDOFF_FOR_NEW_AGENT_202602.

---

## 4. Summary: every area addressed

| Area | Addressed in main plan | Addressed in addendum |
|------|------------------------|------------------------|
| Root files/dirs | Yes | Full list; index.html, styles.css, replacements.txt |
| .cursor/ | Yes | Full list; plans README handoff line |
| scripts/ | Yes | Full inventory; run-everything-debug + get-token-client-credentials paths |
| docs/ | Yes | **141 files**; **status 77 files**; README missing entries (fixed); coverage/ 41 gitignored |
| prompts/ | Yes | 37 files; head-guru stale; decision tree handoff branch |
| src/ | Yes | Listed |
| tests/ | Yes | Listed |
| config/ | Yes | pre-commit cross-platform note |
| data/ | Yes | samples.json path note |
| assets/ | Yes | brand, drop01; index.html image paths |
| archive/ | Yes | 2026-01-30 full structure |
| .github/ | Yes | Workflows path refs; sync develop logic; maintenance Trivy |
| package.json / npm | Yes | lint script; all script paths exist |
| Git hooks | Yes | docs/HOOKS.md; pre-commit behavior |
| Agent entry / handoff | Yes | HANDOFF_FOR_NEW_AGENT_202602 vs HANDOFF_PROMPT_NEW_AGENT; PLAN_AGENT_ENTRY; decision tree |
| Theme / Shopify | Yes | theme-pull-rest API version; theme bootstrap |
| API version | Yes | theme-pull-rest 2024-01 vs context 2026-01 |

---

## 5. Execution: add these to main plan

1. Fix **get-token-client-credentials.ps1** repo path (same pattern as run-everything-debug).
2. Fix **index.html** image paths: use assets/brand/BEB15EE5-E630-4BD8-9AC7-49DC8FB6E076.png (and update og/twitter URLs if deploying from root).
3. Update **docs/README**: add ENVIRONMENT_SETUP and/or HOOKS, AGENT_SYSTEM, AGENT_PROMPTS; or mark ENVIRONMENT_SETUP superseded.
4. **docs/HOOKS.md**: add note that pre-commit is Windows-oriented (powershell.exe).
5. **AGENT_PROMPT_DECISION_TREE**: add "If system broken / fix everything" → HANDOFF_FOR_NEW_AGENT_202602 + PROMPT_FOR_NEW_AGENT; align New-agent handoff row.
6. **.cursor/plans/README.md**: add one line for takeover → HANDOFF_FOR_NEW_AGENT_202602.
7. Optional: **sync.yml** simplify by removing develop steps; **maintenance.yml** document or continue-on-error for Trivy; **performance-report.json** add to .gitignore if generated.
8. **ENVIRONMENT_SETUP.md**: add one-line "Superseded by CREDENTIALS_SETUP" or add to docs/README.

No file or folder is left unaddressed; every directory and critical file is inventoried and either marked OK or given a concrete fix.

---

## 6. Why node files are hidden — and Node/Playwright/remote-PC not used by agents

### Ask: Why are node files hidden?

**What is actually hidden**

- In **`.cursor/settings.json`**, `files.exclude` and `search.exclude` both set **`"**/node_modules": true`**. So **node_modules** (installed npm packages) are hidden from the file tree and from search. That is standard to reduce noise; it does **not** hide your own code.
- Your **project** Node/JS files are **not** hidden: `src/*.js`, `tests/*.js`, `playwright.config.js`, `playwright.shopify.config.js`, `package.json`, etc. are all visible and searchable.

**Why key features feel “hidden”**

- The features you care about — **Playwright** (E2E/browser) and **remote access to your PC** (desktop-automation, operations that can’t be done via GitHub/Shopify API) — live in:
  - **package.json**: `test:e2e`, `test:shopify`, `test:desktop`, `test:desktop:quick`
  - **src/browser-automation/**, **src/desktop-automation/** (27 modules)
  - **tests/e2e/**, **tests/shopify-admin/**, **tests/desktop-automation/**
- **AGENTS.md** and **`.cursor/context/`** do **not** tell agents to use these automatically. Context today is only **github.md** and **shopify.md**. There is no context file for Node, Playwright, or desktop/remote-PC.
- **.cursor/rules/use-user-browser.mdc** says “use the user’s browser (MCP)” and “do not use headless” for credential/setup flows; it does **not** say when to use Playwright for E2E or desktop-automation for PC-level operations.
- So agents are never instructed or given context to **automatically** use Playwright or remote-PC for “operations that can’t be performed through GitHub/Shopify API.”

**Conclusion**

- **“Node files”** in the sense of **node_modules** are hidden by design (editor settings).
- **“Node files”** in the sense of **key features not being used by agents** is accurate: Playwright and desktop/remote-PC are in the repo but not surfaced in agent instructions or context, so agents don’t use them automatically.

### Plan: Surface Playwright and remote-PC for automatic agent use

| # | Action | Purpose |
|---|--------|--------|
| 1 | **Add `.cursor/context/node-and-automation.md`** (or similar name) | Single context file agents load: lists Playwright (npm run test:e2e, test:shopify), desktop-automation (src/desktop-automation, npm run test:desktop), when to use them (E2E, browser flows when API insufficient, PC operations APIs can’t do). Point to docs/AGENT_SYSTEM.md and package.json scripts. |
| 2 | **Update AGENTS.md** | Add a short section: agents may use **Playwright** for E2E/browser automation and **desktop-automation / remote-PC** for operations that cannot be performed via GitHub/Shopify API; see .cursor/context and docs/AGENT_SYSTEM.md. Keep existing “use your browser (MCP)” for interactive flows; add “for scripted E2E or PC-level operations, use Playwright/desktop-automation when appropriate.” |
| 3 | **Add Cursor tasks** | “Run Shopify E2E” → npm run test:shopify; “Run desktop automation test” → npm run test:desktop (and optionally test:desktop:quick). So these are one-click and visible in the task list. |
| 4 | **Optional: .cursor/rules** | In use-user-browser or a new rule: when user approves, agents may use Playwright for automated E2E/scripted browser flows and desktop-automation for PC-level operations (screens, windows, input); document in OPERATOR_RUNBOOK or docs. |
| 5 | **Optional: node_modules visibility** | Do **not** unhide node_modules in files.exclude/search.exclude (noise). If desired, add a note in docs/README or OPERATOR_RUNBOOK: “Key Node features (Playwright, desktop-automation) are in package.json and src/tests; see .cursor/context/node-and-automation.md.” |

These changes make Node/Playwright/remote-PC **visible to agents by default** (context + AGENTS.md + tasks) so they are used automatically for operations that can’t be done via GitHub/Shopify API.

---

## 7. Guru 1,000-QA audit: unaddressed issues and plan insights

From [GURU_1000_QA_AUDIT_AND_INSIGHTS.md](GURU_1000_QA_AUDIT_AND_INSIGHTS.md) (20 dimensions, 1,000+ Q&As paramount to intended functionality):

### Unaddressed / unidentified issues (U1–U14)

| ID | Issue | Where |
|----|--------|-------|
| U1 | No single "fix everything" entry that branches to HANDOFF vs PLAN_AGENT_ENTRY | Entry / decision tree |
| U2 | Phase 0 gate vs "full dominion" not clarified | PLAN_AGENT_ENTRY / decision tree |
| U3 | head-guru-orchestrator.md has stale branches/blockers | prompts/ |
| U4 | theme-pull-rest API version 2024-01 vs 2026-01 | scripts/shopify/theme-pull-rest.ps1 |
| U5 | verify-pipeline, finish-setup, run-runbook, theme-pull, theme-auth not in Cursor tasks | .cursor/tasks.json |
| U6 | Playwright and desktop-automation not in agent context or AGENTS.md | .cursor/context, AGENTS.md (see §6 above) |
| U7 | ENVIRONMENT_SETUP, HOOKS, AGENT_SYSTEM, AGENT_PROMPTS not in docs/README | docs/README.md |
| U8 | HANDOFF_PROMPT_NEW_AGENT vs HANDOFF_FOR_NEW_AGENT_202602 duality | docs/ vs docs/status/ |
| U9 | CI does not run verify-pipeline or E2E | .github/workflows/ |
| U10 | No single canonical "architecture" one-pager | docs/ (optional) |
| U11 | index.html image paths broken (BEB15EE5 at root; moved to assets/brand) | index.html |
| U12 | Two hardcoded repo paths | run-everything-debug.ps1, get-token-client-credentials.ps1 |
| U13 | Pre-commit hook uses powershell.exe (fails on non-Windows) | config/git-hooks/pre-commit, docs/HOOKS.md |
| U14 | performance-report.json and generated files gitignore | .gitignore |

### Plan insights to implement (from 1,000-QA answers)

1. **Entry**: Add "fix everything" branch to decision tree and plans README; clarify "full dominion" → skip Phase 0 optional.
2. **Prompts**: Update head-guru to current state; add node-and-automation context; update AGENTS.md for Playwright/desktop (see §6).
3. **Tasks**: Add verify-pipeline, finish-setup, theme-pull, theme-auth-then-pull, run-runbook, test:shopify, test:desktop.
4. **Docs**: Add ENVIRONMENT_SETUP, HOOKS, AGENT_SYSTEM, AGENT_PROMPTS to docs/README or mark superseded; redirect HANDOFF_PROMPT_NEW_AGENT.
5. **Theme**: theme-bootstrap-minimal.ps1; align theme-pull-rest API version or document.
6. **Scripts/paths**: Fix two hardcoded paths; fix index.html image paths.
7. **CI (optional)**: Document or add optional job for verify-pipeline / E2E.
8. **HOOKS**: Document pre-commit Windows-oriented.
9. **.gitignore**: Confirm performance-report.json.
