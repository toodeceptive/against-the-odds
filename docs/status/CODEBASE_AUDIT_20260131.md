# Codebase Audit — 2026-01-31

**Purpose**: Track G deliverable — code layout, dependencies, lint/test status, strings and env approach, schemas, and recommendations. Builds on [FULL_SYSTEM_FILE_AUDIT_20260130.md](FULL_SYSTEM_FILE_AUDIT_20260130.md).

---

## 1. Codebase layout (src/)

| Path | Purpose |
|------|---------|
| **src/shopify/themes/aodrop-theme/** | Shopify theme workspace; README describes theme-dev, theme-pull, update-theme. Theme files (layout, sections, assets) added or synced per workflow. |
| **src/browser-automation/** | helpers.js, shopify-admin.js; browser automation for Shopify admin (user's browser; no headless). Screenshots to docs/screenshots/. |
| **src/desktop-automation/** | 27 modules; orchestrator, solution-engine, issue-detector, screen-analyzer, screen-capture, etc. Uses screenshot-desktop, tesseract.js, sharp; optional robotjs/node-window-manager. ES modules; coherent dependency graph. |

**Entry points**: Theme dev via scripts/shopify/theme-dev.ps1; browser automation via tests/ or scripts; desktop automation via scripts/desktop-automation/test-system.ps1 and npm run test:desktop.

**Language**: JavaScript (ES modules); no TypeScript in src (optional ts in tests per config).

---

## 2. Tests (tests/)

| Directory | Purpose | CI |
|-----------|---------|-----|
| **tests/unit/** | Vitest (example.test.js; 2 tests) | ci.yml, quality-check.yml |
| **tests/integration/** | github-api.test.js, shopify-api.test.js (credential-gated) | CI when env present |
| **tests/e2e/** | example.spec.js, shopify-admin.spec.js (Playwright) | Optional |
| **tests/shopify-admin/** | extract-credentials.spec.js | Shopify E2E config |
| **tests/desktop-automation/** | issue-detection, mouse-keyboard, screen-capture, window-management | npm run test:desktop |

**Coverage**: Vitest v8; thresholds in vitest.config.js (lines/functions/branches/statements); baseline per COVERAGE_REMEDIATION_PLAN.md. Coverage report: npm run test:coverage.

---

## 3. Dependencies and libraries

| Source | Content |
|--------|---------|
| **package.json** | Vitest, Playwright, ESLint, Prettier; screenshot-desktop, tesseract.js, sharp; optional robotjs, node-window-manager. |
| **Parsers / bins** | No custom parsers or bins in repo; ESLint/Prettier/Vitest/Playwright used as tools. |
| **Versions** | package.json pins major/minor; lockfile (e.g. package-lock.json) gitignored per .gitignore; versions and licenses consistent (UNLICENSED). |

**npm audit**: Documented in SECURITY_AUDIT_20260130.md; 6 moderate (esbuild/vitest, eslint), 0 high/critical; CI uses --audit-level=high so moderate do not block PRs.

---

## 4. Lint and format

| Tool | Config | When |
|------|--------|------|
| **ESLint** | .eslintrc.json | npm run lint, lint:fix; CI (ci.yml, quality-check.yml) |
| **Prettier** | .prettierrc.json | npm run format, format:check; quality-check runs format:check |
| **Centralized** | Single config at root; no conflicting per-dir overrides. Documented in config/README.md and scripts/README.md. |

**Status**: Lint and format checks pass in CI; codebase conforms.

---

## 5. Strings and env

| Area | Approach |
|------|----------|
| **Hardcoded strings** | No i18n layer; strings in code and prompts. Env var names (e.g. SHOPIFY_*, GitHub) documented in .env.example, .env.shopify.example, CREDENTIALS_SETUP.md. |
| **Secrets** | .env.local only (gitignored); never in code or commits. Rules: .cursor/rules/env-credentials.mdc; CI secret-scan (shpat*, ghp*, shpss*); .env.example and .env.shopify.example excluded from scan. |

---

## 6. Schemas and data contracts

| Data | Location | Notes |
|------|----------|-------|
| **Products** | data/products/*.json | Example schema in example-hoodie.json; sync to Shopify via scripts/shopify/sync-products.ps1. |
| **Manufacturers** | data/manufacturers/*.json | Example in example-manufacturer.json; see data/README.md. |
| **Samples** | data/samples/ | .gitkeep; add records as needed. |
| **Theme** | src/shopify/themes/aodrop-theme/ | Shopify theme structure; schema per Shopify theme architecture. |

No formal JSON Schema files in repo; structure documented in data/README.md and plan (Expert 9).

---

## 7. Script portability (resolved 2026-01-31)

The following scripts now derive repo root from script location (no hardcoded path):

- **scripts/git/pre-commit.ps1** — parent of parent of PSScriptRoot.
- **scripts/products/sync.ps1** — parent of parent of PSScriptRoot.
- **scripts/maintenance/security-scan.ps1** — same.
- **scripts/shared/utilities.ps1** — Set-RepoLocation derives repo from script dir when $RepoPath is null.

**Recommendation**: Any remaining scripts that assume a fixed path should be updated similarly; see scripts/README.md.

---

## 8. Recommendations

1. **Coverage**: Continue toward thresholds in vitest.config.js; track in COVERAGE_REMEDIATION_PLAN.md.
2. **Theme source**: When theme files are added under src/shopify/themes/aodrop-theme/, ensure sync-theme-branch.yml and theme-dev flow stay aligned (see docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md).
3. **Desktop automation**: Optional dependencies (robotjs, node-window-manager) may require native build; document in README or OPERATOR_RUNBOOK if needed for contributors.
4. **Apps/extensions**: No app or extension code in repo beyond theme; document if custom app is added.

---

## 9. Summary

- **Layout**: src/ (shopify theme, browser-automation, desktop-automation); tests/ (unit, integration, e2e, shopify-admin, desktop-automation). Coherent; no TODO/FIXME in src/ or tests/.
- **Lint/test**: ESLint, Prettier, Vitest pass; CI and quality-check run on main.
- **Env/secrets**: .env.local only; rules and CI aligned; token echo removed in get-access-token.ps1.
- **Portability**: Key scripts (pre-commit, sync, security-scan, utilities) use repo-root detection.
- **Deliverable**: This document; main README and docs point to scripts/README.md and config/README.md for script and config index.

_Last updated: 2026-01-31. Track G complete._
