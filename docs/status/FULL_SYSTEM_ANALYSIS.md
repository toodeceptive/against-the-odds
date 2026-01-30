# Full System Analysis

**Date**: 2026-01-30  
**Author**: Systems Designer Agent (Multi-Agent Perfection Plan)  
**Purpose**: Structured system analysis for downstream agents (architecture, testing, fix, optimization, verification).

---

## 1. End-to-end system map

### 1.1 Components

| Layer                | Components               | Location / trigger                                                                                             |
| -------------------- | ------------------------ | -------------------------------------------------------------------------------------------------------------- |
| **Version control**  | Git, GitHub repo         | Local worktree(s), `origin`; branches: main, develop, feature branches                                         |
| **CI/CD**            | GitHub Actions           | `.github/workflows/`: ci.yml, deploy.yml, quality-check.yml, shopify-sync.yml, sync.yml, maintenance.yml       |
| **Runtime**          | Node.js                  | `package.json` scripts; Vitest, Playwright, ESLint, Prettier                                                   |
| **Scripts**          | PowerShell               | `scripts/`: setup, health, sync, shopify, products, manufacturing, monitoring, maintenance, git, docs, quality |
| **Application code** | JS (Node)                | `src/`: browser-automation, desktop-automation, shopify/themes                                                 |
| **Data**             | Config + JSON            | `config/`, `data/` (products, manufacturers, samples), `.env.local` (gitignored)                               |
| **Store / hosting**  | Shopify, optional static | Store: aodrop.com; optional static: toodeceptive.github.io/against-the-odds (Lighthouse target)                |

### 1.2 Data flows

- **Config**: `config/github-auth.md`, `config/shopify/.shopify-cli.yml` (no secrets); env from `.env.local` (GitHub PAT, Shopify API key/secret/access token, store domain/URL, theme ID).
- **Secrets**: `.env.local` only; CI uses GitHub Secrets (SHOPIFY\_\*, etc.); never committed.
- **Product/manufacturer data**: `data/products/`, `data/manufacturers/` (JSON); consumed by scripts (e.g. `scripts/products/sync.ps1`, `scripts/manufacturing/track-samples.ps1`).
- **Scripts and src**: Scripts call Node where needed; `src/browser-automation` and `src/desktop-automation` are used by tests and automation; theme assets under `src/shopify/themes/aodrop-theme/`.

### 1.3 Integration points

- **GitHub API**: Auth via PAT in `.env.local`; scripts: `scripts/github/verify-auth.ps1`, `test-push-pull.ps1`, `verify-secrets.ps1`; CI has `contents: read`, security uploads.
- **Shopify API**: Admin API (store domain, theme API); credentials in `.env.local`; scripts: `scripts/shopify/test-connection.ps1`, `theme-dev.ps1`, `sync-products.ps1`, browser helpers under `scripts/shopify/browser/`.
- **Playwright**: Default config `playwright.config.js` (baseURL: GitHub Pages); `playwright.shopify.config.js` (Shopify admin, baseURL from env); E2E under `tests/e2e/`, `tests/shopify-admin/`.
- **Local vs cloud**: CI runs on `ubuntu-latest` (lint, test:all, build check, Trivy, Lighthouse). Shopify and credential-dependent flows require local or secrets in CI; E2E against live store is env-dependent.

---

## 2. Alignment with existing analyses and docs

- **expert-analyses/**: 10 guru reports (avg 6.4/10); Integration & Workflow (#9) notes: repo sync, workflow automation, integration clarity. This analysis confirms: workflows exist and are documented; automation is script + CI; integration points are as above.
- **Gaps/conflicts**: (1) CI triggers on `main` and `develop`; repo may use other branches (e.g. perfection runs)—document which branches run CI. (2) Deploy workflow is placeholder (echo only); Shopify theme deploy is via Shopify GitHub App per deploy.yml comment. (3) Lighthouse in CI points at GitHub Pages URL; ensure that URL is the intended front-end or document alternate.

---

## 3. Risks and unknowns for later agents

| Risk / unknown                                                     | Owner / next step                                                  |
| ------------------------------------------------------------------ | ------------------------------------------------------------------ |
| Prettier: 206 files not formatted                                  | Agent 2 (Architecture): run `npm run format`, then format:check    |
| Coverage: thresholds 90% in vitest.config; actual coverage unknown | Agent 4 (Testing): run test:coverage, meet or add remediation plan |
| E2E: shopify-admin and credential-dependent tests                  | Agent 5: document env requirements; fix or quarantine flaky tests  |
| Desktop automation tests: Windows-only gating                      | Agent 4/5: keep gating; document in README or test docs            |
| CI branch list (main, develop) vs actual branching model           | Agent 3 (Business/Ops): align workflow triggers with doc           |
| Shopify/Cloudflare live state                                      | Deferred (Phase 0); verify when credentials available              |
| Deploy workflow placeholders                                       | Agent 3 or 7: document or implement non-Shopify deploy steps       |

---

## 4. Output summary

- **Structured system analysis**: This document (components, data flows, integration points).
- **Risk/unknowns list**: Section 3 above for use by Architecture, Testing, E2E, Debug, Optimization, and Verification agents.
