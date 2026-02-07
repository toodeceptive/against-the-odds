# Full system-wide test and improvement prompt (new agent team)

**Purpose**: One prompt for a **new team of agents** using the **new Cursor agent system** to run a full, system-wide series of tests and improvements across the Against The Odds repo and local environment. Use this to validate and optimize every layer: code, files, folders, functions, tools, extensions, repo, local, pipeline, codebase, scripts, GitHub Actions, and the Cursor agent system itself.

**Prerequisites**:

- Read `docs/status/PLAN_AGENT_ENTRY.md` first. If Phase 0 is already signed off (`docs/status/PHASE_0_FINALIZATION.md` contains "Phase 0 finalized; proceeding allowed."), do **not** re-run Phase 0; proceed with this prompt per `docs/status/EXECUTIVE_DECISION_WORK_PRINCIPLES.md` (incremental work only).
- If Phase 0 is not signed off, complete Phase 0 per `prompts/PERFECT_EXECUTION_PROMPT.md` before using this prompt.
- Primary worktree: `C:\Users\LegiT\against-the-odds` (branch **main**). Pull `origin main` before starting.

**Cursor system to use**:

- **Default rule**: Prodigy Protocol (PP) runs as baseline (`.cursor/rules/pp-basis.mdc`). Optionally invoke skills: `prodigy-protocol` (alias `pp`), `prodigy-phantasm`, `universal-godmode`, `agentic-performance` (see `.cursor/skills/README.md`).
- **Commands**: Use **/review** for lint, format check, and tests (report only). Use **/pr** to commit, push, and open a PR when changes are ready.
- **Verifier subagent**: Delegate to `.cursor/agents/verifier.md` for an independent verification pass (lint, tests, build report) after making changes.
- **Safety**: Store-affecting changes require preview and user approval; no secrets in commits (see `AGENTS.md`).

---

## Mission

Run a **full, system-wide** series of tests and improvements across the following dimensions. For each dimension, **test** (run checks, scripts, workflows), **record** (pass/fail, errors, gaps), and **improve** (fixes, cleanup, optimizations, enhancements, performance) as needed. Commit and document outcomes; use PRs for feature branches when appropriate.

---

## 1. Code

- **Lint**: Run `npm run lint` (ESLint). Fix all errors; document or fix warnings.
- **Format**: Run `npm run format:check`; if failures, run `npm run format` and commit.
- **Unit tests**: Run `npm run test:unit`. Fix failing tests or document skip reasons.
- **Integration tests**: Run integration tests if present (e.g. `tests/integration/`). Report and fix failures.
- **E2E**: If applicable, run E2E (e.g. `npm run test:e2e` or Playwright). Note environment requirements (Shopify credentials, browsers).
- **Types**: If TypeScript or JSDoc types exist, ensure no type errors in build or type-check script.

**Deliverable**: All lint/format/unit (and optionally integration) passing; failures documented or fixed.

---

## 2. Files and folders

- **Structure**: Review repo tree; ensure no loose or misplaced files; align with `docs/status/ROOT_FILES_INVENTORY.md` and `scripts/README.md`, `config/README.md`, `data/README.md`.
- **Naming**: Consistent naming (no odd casing, spaces, or legacy suffixes) in key dirs: `src/`, `tests/`, `scripts/`, `docs/`, `.cursor/`.
- **Duplicates**: Identify duplicate or redundant files; consolidate or archive with rationale.
- **Cleanup**: Remove obsolete temp files, stray backups, or unused assets; keep `.gitignore` and `.cursorignore` aligned with what should be excluded.

**Deliverable**: Structure and naming consistent; duplicates removed or documented; cleanup committed.

---

## 3. Functions and modules

- **Entry points**: Verify `src/` entry points (e.g. desktop-automation, browser-automation, shopify) export and run correctly.
- **Dependencies**: No broken or unused imports; `npm install` and require/import paths valid.
- **Critical paths**: Scripts and code paths used by GitHub Actions or runbooks (e.g. `scripts/shopify/`, `scripts/github/`) run without errors when invoked from repo root.

**Deliverable**: No broken imports or runtime errors in core paths; fixes committed.

---

## 4. Tools and extensions

- **Node/npm**: `node` and `npm` available; `package.json` scripts runnable (lint, format, test:unit, test:integration, etc.).
- **PowerShell**: Scripts in `scripts/` run in PowerShell; path resolution from repo root (e.g. `PSScriptRoot`) correct.
- **Cursor extensions**: `.cursor/extensions.json` is the single source for recommendations; no duplicate extension lists elsewhere. Document any recommended extensions for this project.
- **Other tools**: Shopify CLI, Playwright, Git — document version or install requirements in `docs/` or README if missing.

**Deliverable**: Tool and extension list accurate; doc updates if needed.

---

## 5. Repo (Git)

- **Branches**: Align with `docs/status/BRANCH_INVENTORY.md`. Main-only strategy; no stale local branches unless documented.
- **Worktrees**: Per `docs/status/BRANCH_INVENTORY.md` / `docs/status/WORKTREE_INVENTORY.md`; no conflicting state.
- **.gitignore**: Covers secrets, build artifacts, node_modules, logs, coverage, local env; no committed secrets.
- **.cursorignore**: Present at repo root; reduces indexing of env, node_modules, dist, build, logs (see `docs/status/CURSOR_AND_AGENT_OPTIMIZATION.md`).

**Deliverable**: Branch/worktree state consistent with inventory; .gitignore/.cursorignore correct; no secrets in history.

---

## 6. Local environment

- **Env**: `.env.example` or `.env.shopify.example` document required vars; `.env.local` gitignored and never committed.
- **Paths**: Scripts assume repo root; Windows paths and worktree paths documented where relevant (e.g. OPERATOR_RUNBOOK, HANDOFF).
- **Credentials**: Shopify, GitHub tokens only in `.env.local` or GitHub Secrets; no hardcoded secrets.

**Deliverable**: Env docs up to date; no credential leaks.

---

## 7. Pipeline (GitHub Actions)

- **Workflows**: Under `.github/workflows/` — `ci.yml`, `codeql.yml`, `maintenance.yml`, `shopify-sync.yml`, `sync-theme-branch.yml`, `sync.yml`. Trigger on **main**; no references to removed branches (e.g. develop).
- **Run locally**: Use `scripts/verify-pipeline.ps1` (or equivalent) to run workflow scripts locally where possible; run `npm run lint`, `npm run format:check`, `npm run test:unit` to mirror CI.
- **Secrets**: Workflows use GitHub Secrets for tokens; no secrets in workflow YAML. Shopify sync/sync-theme-branch may skip when secrets missing (documented).
- **Status checks**: Branch protection and required status checks aligned with workflow names (see `scripts/github/update-branch-protection-status-checks.js` if used).

**Deliverable**: All workflows valid; CI passes or failures documented with cause; no secret leakage.

---

## 8. Codebase (src, tests, config)

- **Source**: `src/shopify/themes/`, `src/browser-automation/`, `src/desktop-automation/` — build/lint/test as applicable.
- **Tests**: `tests/unit/`, `tests/integration/`, `tests/e2e/`, `tests/desktop-automation/`, `tests/shopify-admin/` — all runnable; gates (e.g. Windows-only, credential-gated) documented.
- **Config**: `eslint.config.mjs`, `vitest.config.js`, `playwright.config.js`, `playwright.shopify.config.js`, `.prettierrc.json` — consistent and used by npm scripts.

**Deliverable**: Codebase categories tested and documented; configs consistent.

---

## 9. Scripts

- **PowerShell**: `scripts/shopify/`, `scripts/products/`, `scripts/github/`, `scripts/monitoring/`, `scripts/maintenance/`, `scripts/docs/`, `scripts/manufacturing/` — listed in `scripts/README.md`; each runnable from repo root or documented otherwise.
- **npm**: `package.json` scripts (lint, format, test:unit, test:integration, test:e2e, etc.) all work.
- **Critical**: Theme pull, theme dev, sync-products, finish-setup, verify-pipeline — run or document why skipped (e.g. SSL/theme pull blocker per HANDOFF).

**Deliverable**: Script index accurate; critical scripts run or blockers documented.

---

## 10. Cursor agent system

- **Rules**: `.cursor/rules/` — `pp-basis.mdc` (always on); `ao-guru.rules.md` (globs); shopify-preview-approval, env-credentials, use-user-browser as applicable.
- **Skills**: `.cursor/skills/` — prodigy-protocol, prodigy-phantasm, universal-godmode, agentic-performance; README and alias `pp` clear.
- **Agents**: `.cursor/agents/verifier.md` — verification pass only; no conflict with main agent.
- **Commands**: `.cursor/commands/review/`, `.cursor/commands/pr/` — /review and /pr work as documented.
- **Context**: `.cursor/context/` — shopify, github, node-and-automation current.
- **Settings**: `.cursor/settings.json` — worktrees, UI; extensions via `.cursor/extensions.json` only.
- **Worktrees**: `.cursor/worktrees.json` — setup scripts and env copy for new worktrees; inventory doc aligned.

**Deliverable**: Cursor config consistent; docs (README "Cursor and agent", AGENTS.md, CURSOR_AND_AGENT_OPTIMIZATION) accurate.

---

## 11. Against-the-odds project end-to-end

- **Store**: Shopify store (aodrop.com) — theme source in `src/shopify/themes/aodrop-theme`; sync and theme-dev scripts documented; known blockers (e.g. theme pull SSL) in HANDOFF.
- **Runbook**: `OPERATOR_RUNBOOK.md` — daily checks, Shopify flow, credentials; up to date.
- **Docs**: `docs/README.md` index; `docs/status/INDEX_REPORTS.md`; CONSOLIDATION_LOG, BRANCH_INVENTORY, ROOT_FILES_INVENTORY current.
- **Changelog**: `CHANGELOG.md` [Unreleased] updated for substantive changes.

**Deliverable**: Project docs and runbook current; store/workflow blockers documented.

---

## Execution order (recommended)

1. **Repo + local**: Pull main; confirm worktree and env (sections 5, 6).
2. **Code + codebase**: Lint, format, unit tests (sections 1, 8).
3. **Pipeline**: Run verify-pipeline and npm scripts; confirm GitHub Actions (section 7).
4. **Files/folders + scripts**: Structure and script index (sections 2, 9).
5. **Functions/tools**: Entry points and tools (sections 3, 4).
6. **Cursor agent system**: Rules, skills, commands, Verifier (section 10).
7. **Project e2e**: Runbook, docs, store notes (section 11).

Use **Verifier** subagent after batches of changes for an independent lint/test/build report.

---

## Outputs and sign-off

- **Fixes**: Commit with clear messages (e.g. `fix: ...`, `chore: ...`). Use `/pr` or manual push for PR when on a feature branch.
- **Docs**: Update CONSOLIDATION_LOG with a dated entry for "Full system test and improvement run" and list deliverables (e.g. lint/format/test pass, inventory updates, Cursor config check).
- **Changelog**: Add [Unreleased] line in CHANGELOG.md if substantive user-facing or project-wide changes.
- **Report** (optional): Short summary in `docs/status/` (e.g. `FULL_SYSTEM_TEST_REPORT_YYYYMMDD.md`) with: what was tested, what passed/failed, what was fixed or deferred and why.

**Success**: All test dimensions executed; failures either fixed or documented with next steps; repo and Cursor system consistent and optimized.
