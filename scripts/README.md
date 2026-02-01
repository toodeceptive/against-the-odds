# Scripts — Index and Usage

**Purpose**: Single index of all PowerShell and automation scripts by domain. Run from **repo root** so paths resolve. See [OPERATOR_RUNBOOK.md](../OPERATOR_RUNBOOK.md) for daily checks and key workflows.

---

## npm Scripts (package.json)

| npm script                 | Invokes                                    | When to use                       |
| -------------------------- | ------------------------------------------ | --------------------------------- |
| `npm run test`             | vitest                                     | Unit/integration tests (watch)    |
| `npm run test:unit`        | vitest run tests/unit                      | Unit tests only                   |
| `npm run test:integration` | vitest run tests/integration               | Integration tests only            |
| `npm run test:e2e`         | playwright test                            | E2E (default config)              |
| `npm run test:shopify`     | playwright test (shopify config)           | Shopify admin E2E                 |
| `npm run test:coverage`    | vitest run --coverage                      | Coverage report                   |
| `npm run test:all`         | unit + integration                         | Pre-commit / CI                   |
| `npm run lint`             | eslint                                     | Lint JS/TS                        |
| `npm run lint:fix`         | eslint --fix                               | Auto-fix lint                     |
| `npm run format`           | prettier --write                           | Format tracked files              |
| `npm run format:check`     | prettier --check                           | CI format check                   |
| `npm run setup`            | scripts/setup-env.ps1                      | Initial env setup                 |
| `npm run setup:auto`       | scripts/setup/auto-configure-env.ps1       | Auto-configure env                |
| `npm run health`           | scripts/health/comprehensive-check.ps1     | Health check                      |
| `npm run sync`             | scripts/sync/sync-all.ps1                  | Repo sync (fetch, conflict check) |
| `npm run test:desktop`     | scripts/desktop-automation/test-system.ps1 | Desktop automation tests          |
| `npm run verify:pipeline`  | scripts/verify-pipeline.ps1                | Pipeline verification             |

---

## Scripts by Domain

### Shopify (scripts/shopify/)

| Script                                           | Purpose                                                | When to run                                                                           |
| ------------------------------------------------ | ------------------------------------------------------ | ------------------------------------------------------------------------------------- |
| **sync-products.ps1**                            | Bulk product sync repo → store (Admin API)             | Use `-DryRun` first; then apply after approval. Used by CI/shopify-sync workflow.     |
| **theme-dev.ps1**                                | Start `shopify theme dev`                              | Local theme preview (CLI auto-install, loads .env.local)                              |
| **test-connection.ps1**                          | Test Shopify API connectivity                          | After credentials change                                                              |
| **browser/get-access-token.ps1**                 | Obtain token via user's browser; optional `-SaveToEnv` | One-off token setup                                                                   |
| **browser/save-token-to-env.ps1**                | Write token to .env.local                              | After get-access-token                                                                |
| theme-pull.ps1, theme-init.ps1, update-theme.ps1 | Theme operations (Ensure-ShopifyCli.ps1 + .env.local)  | Per [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](../docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md) |

### Products (scripts/products/)

| Script       | Purpose                                                  | When to run                                                                        |
| ------------ | -------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| **sync.ps1** | Bidirectional wrapper; `-Direction import\|export\|both` | Import from store or export to repo; import delegates to shopify/sync-products.ps1 |
| export.ps1   | Export products from store to repo                       | Backup or local data refresh                                                       |
| import.ps1   | Import (delegates to sync-products)                      | Use sync.ps1 -Direction import or sync-products.ps1                                |

### Git (scripts/git/)

| Script                                        | Purpose                                                    | When to run             |
| --------------------------------------------- | ---------------------------------------------------------- | ----------------------- |
| **pre-commit.ps1**                            | Pre-commit checks (invoked by config/git-hooks/pre-commit) | Automatically on commit |
| auto-commit.ps1, auto-push.ps1, sync-repo.ps1 | Commit/push/sync helpers                                   | As needed               |

### GitHub (scripts/github/)

| Script                                                  | Purpose                                 | When to run                                     |
| ------------------------------------------------------- | --------------------------------------- | ----------------------------------------------- |
| verify-auth.ps1, verify-secrets.ps1, test-push-pull.ps1 | Auth and repo verification              | After GitHub setup                              |
| optimize-repo.ps1                                       | Repo optimization (topics, description) | One-off or per .github/settings.optimization.md |

### Health & Monitoring (scripts/health/, scripts/monitoring/)

| Script                                                                              | Purpose                   | When to run                     |
| ----------------------------------------------------------------------------------- | ------------------------- | ------------------------------- |
| comprehensive-check.ps1                                                             | Full health check         | Daily or before deploy          |
| alert-on-issues.ps1, auto-repair.ps1, generate-report.ps1, monitor-continuously.ps1 | Alerts, repair, reporting | Per OPERATOR_RUNBOOK            |
| performance-check.ps1                                                               | Performance checks        | Optional; CI may run Lighthouse |

### Maintenance (scripts/maintenance/)

| Script                  | Purpose                                | When to run                                   |
| ----------------------- | -------------------------------------- | --------------------------------------------- |
| **security-scan.ps1**   | Local secret scan (shpat*, ghp*, etc.) | Before push; CI runs secret-scan in workflows |
| update-dependencies.ps1 | Dependency update                      | Periodic or per maintenance.yml               |

### Sync (scripts/sync/)

| Script                                         | Purpose                         | When to run                                         |
| ---------------------------------------------- | ------------------------------- | --------------------------------------------------- |
| sync-all.ps1                                   | Fetch, checkout, conflict check | Scheduled or manual; see .github/workflows/sync.yml |
| health-check.ps1, verify-all.ps1, auto-fix.ps1 | Sync health and verification    | As needed                                           |

### Setup (scripts/setup/)

| Script                                                               | Purpose                  | When to run                                      |
| -------------------------------------------------------------------- | ------------------------ | ------------------------------------------------ |
| setup-env.ps1 (root), auto-configure-env.ps1, verify-credentials.ps1 | Env and credential setup | First-time setup; verify after credential change |

### Quality (scripts/quality/)

| Script        | Purpose        | When to run                                                        |
| ------------- | -------------- | ------------------------------------------------------------------ |
| check-all.ps1 | Quality checks | Local or CI (quality-check.yml runs lint, format, coverage, audit) |

### Other (root-level scripts/)

| Script                        | Purpose                                        | When to run                          |
| ----------------------------- | ---------------------------------------------- | ------------------------------------ |
| **run-runbook.ps1**           | Run OPERATOR_RUNBOOK daily checks              | Daily                                |
| **open-pending-approval.ps1** | Open docs/status/pending-approval.md in editor | Before/after store-affecting changes |
| **start-theme-preview.ps1**   | Start theme dev and open preview URL           | Theme preview workflow               |
| verify-pipeline.ps1           | Verify Cursor–GitHub–Shopify pipeline          | After workflow or config change      |

### Archive / Legacy

- **scripts/archive/root-scripts-legacy/** — Legacy root scripts (create-and-push.ps1, create-repo.ps1, sync-repository.ps1); not used by current workflow.

---

## Config and Environment

- **Lint/format**: ESLint 9 (`eslint.config.mjs` flat config), Prettier (`.prettierrc.json`). Centralized; CI runs `lint` and `format:check`.
- **Env**: `.env.example`, `.env.shopify.example` (templates); `.env.local` (local secrets, gitignored). See [docs/CREDENTIALS_SETUP.md](../docs/CREDENTIALS_SETUP.md).
- **.tmp / temp**: No repo-level .tmp directory. CI uses `cache: 'npm'`. Scripts that use temp files (e.g. browser token extraction) clean up after use.

---

## Alignment with CI/CD

- **ci.yml**: Lint, test, build, Trivy, secret-scan, Lighthouse (main only).
- **quality-check.yml**: Coverage, lint, format check, npm audit, Lighthouse (main only).
- **shopify-sync.yml**: Calls product sync (data/products, src/shopify); backup-store job is placeholder.
- **sync-theme-branch.yml**: Subtree-split theme to `shopify-theme` branch on push to main when theme files change.
- **sync.yml**: Repository sync (fetch, main); no develop branch.

_Last updated: 2026-01-31_
