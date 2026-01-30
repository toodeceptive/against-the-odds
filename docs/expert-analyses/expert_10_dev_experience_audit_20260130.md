# Expert 10: Developer Experience & Tooling Audit — 2026-01-30

**Domain**: Development environment, tooling, IDE setup, developer productivity  
**Deliverable**: DevEx report and runbook/task updates (per Full Project Guru Perfection Plan Phase 5)

---

## 1. Development environment

- **Reproducibility**: README and OPERATOR_RUNBOOK describe clone, .env.local, npm install, Shopify CLI; scripts in `scripts/setup/` and `scripts/health/` support automation.
- **Validation**: `scripts/shopify/test-connection.ps1`, `scripts/setup/verify-credentials.ps1`, `scripts/health/comprehensive-check.ps1`; npm scripts: `lint`, `format`, `test`, `test:e2e`.
- **Run from repo root**: All `.cursor/tasks.json` tasks use paths relative to repo root (e.g. `scripts/setup/auto-configure-env.ps1`); no changes needed.

---

## 2. IDE / .cursor configuration

- **settings.json**: Format on save (Prettier), ESLint fix on save, file associations (ps1, yml), excludes (.git, node_modules, .env.local, dist, build), PowerShell/JS/TS/JSON/MD formatters, PowerShell script analysis, terminal PowerShell, git smart commit/autofetch, auto-save, extensions recommendations inline.
- **extensions.json**: Recommendations list; partially overlaps settings.json; some extras (Copilot, TypeScript, Tailwind, path-intellisense, GitLens). **Recommendation**: Treat `extensions.json` as canonical for extension recommendations; remove duplicate list from settings if desired to avoid drift (optional).
- **tasks.json**: Setup, Verify Credentials, Test Shopify Connection, Run Tests, Run E2E, Lint, Format, Sync Products, Health Check, Shopify theme-dev (preview/Live), Open pending approval. All invoke npm or PowerShell with repo-relative paths — **run from repo root** satisfied.

---

## 3. Linting and formatting

- ESLint and Prettier configured; CI runs lint; format on save and ESLint fix on save in .cursor/settings.json. Aligned with Phase 1 code quality.

---

## 4. Scripts and workflows

- **package.json**: test, test:unit, test:integration, test:e2e, test:shopify, test:coverage, lint, format, health, sync, etc. Clear and documented in README/OPERATOR_RUNBOOK.
- **PowerShell**: Scripts under `scripts/`; tasks.json and runbook reference them. Windows-first as per project rules.

---

## 5. Cursor-specific (in-repo)

- **.cursor/rules**: ao-guru.rules.md (execution, safety, quality gates, reporting); env-credentials, shopify-preview-approval, use-user-browser. Rule referencing legacy root report updated to docs/status/ and INDEX_REPORTS.
- **.cursor/context**: github.md, shopify.md — repo and store context for agents.
- **.cursor/plans**: Plan files; redundant or superseded plans can be pruned or documented (see CURSOR_WORKSPACE_AUDIT).
- **.cursor/worktrees.json**: setup-worktree includes `npm install`; documents worktree setup.

---

## 6. Success criteria (expert-10)

- Development environment is documented and scriptable; run from repo root.
- Tooling (ESLint, Prettier, Playwright, Vitest) is configured and used in tasks/CI.
- Developer workflows are efficient (tasks, runbook, npm scripts).
- Setup and onboarding are clear (README, OPERATOR_RUNBOOK, docs/guides).

**Phase 5 DevEx deliverable**: Complete. Cursor and workspace audit in `docs/status/CURSOR_WORKSPACE_AUDIT_20260130.md`.
