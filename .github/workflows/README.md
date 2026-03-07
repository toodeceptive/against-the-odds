# GitHub Actions Workflows

## Required Secrets

These workflows require the following secrets to be configured in GitHub:

### Repository Secrets (Settings > Secrets and variables > Actions)

1. **SHOPIFY_STORE_DOMAIN**
   - Value: `aodrop.com`
   - Used by: `shopify-sync.yml`

2. **SHOPIFY_ACCESS_TOKEN**
   - Value: Your Shopify Admin API access token
   - Used by: `shopify-sync.yml`

3. **SHOPIFY_THEME_ID** (optional)
   - Value: Your Shopify theme ID
   - Used by: local theme dev; not required for workflows

## Workflow Files

### `ci.yml` (consolidated gate)

- Runs on: Push to `main`, Pull requests targeting `main`
- Actions: **arch_guard** (signature verification + recomputed structural hash verification + data schema-version enforcement), test job (`npm test` safe baseline + **theme branch export verification** + build + informational npm audit/Trivy upload), **secret-scan**, **e2e_smoke** (`npm run test:e2e:smoke` in Chromium against the checked-out repo), **quality** (`npm run quality` as the deterministic required gate, plus Lighthouse as informational `continue-on-error`), and a **continuous_ai_bridge** status-mirroring job for PRs. Single workflow for all required native quality gates.

**Full verify-pipeline is local-only**: The full pipeline (including theme branch export verification, repo quality gate, product sync dry-run, and optional runbook) is run locally via `npm run verify:pipeline`. CI runs `arch_guard`, the `npm test` safe baseline, theme branch export verification, `secret-scan`, `e2e_smoke`, `quality`, Trivy, and npm audit. The default local verify auto-skips the runbook step when `SHOPIFY_ACCESS_TOKEN` is absent; use `npm run verify:pipeline:strict` when you want the full local integration gate, including `test:integration` and `test:e2e:smoke`.

### `codeql.yml` (CodeQL analysis)

- Runs on: Push to `main`, Pull requests targeting `main`, weekly schedule.
- Actions: CodeQL init + analyze (JavaScript). **Job has `continue-on-error: true`** so a CodeQL failure does not block the run.

### `shopify-sync.yml`

- Runs on: Daily at 2 AM, Push to `main` (data/products only), Manual trigger
- Actions: Syncs products to Shopify; backup-store job backs up theme to `shopify-theme-backup` branch (theme pull REST + push)
- **Resilience**: The product-sync job now fails loudly if required Shopify secrets are missing or if any product apply step fails. Keep `SHOPIFY_STORE_DOMAIN` and `SHOPIFY_ACCESS_TOKEN` configured for scheduled/manual syncs. The backup job still expects those secrets to exist.

### `sync-theme-branch.yml`

- Runs on: Push to `main` when `src/shopify/themes/aodrop-theme/**` changes
- Actions: Subtree-split theme to `shopify-theme` branch and push (for Shopify “Connect from GitHub”). This branch is the canonical theme deploy target when using the Shopify GitHub App with the repo's nested theme directory.
- Verification counterpart: `npm run verify:theme-branch` proves the subtree export shape locally and in CI before merge.

### `sync.yml`

- Runs on: Schedule (every 6 h), Manual trigger
- Actions: Repository sync (fetch, checkout main; no develop branch)

### `governance-verify.yml`

- Runs on: Weekly Monday, Manual trigger
- Actions: Verifies `main` branch protection settings against repo policy using `scripts/github/verify-governance-settings.js`
- Requires: `GITHUB_ADMIN_TOKEN` secret (admin-capable token). When the secret is absent, the job is skipped.

### `maintenance.yml`

- Runs on: Schedule (weekly Sunday), Manual trigger
- Actions: Dependency update PR, Trivy security scan (weekly; CI runs Trivy on every push)

## Setup Instructions

1. Go to your repository on GitHub
2. Navigate to: **Settings > Secrets and variables > Actions**
3. Click **New repository secret**
4. Add each secret listed above
5. Workflows will automatically use these secrets when triggered

## Notes

- Secrets are encrypted and only accessible to workflows
- Never commit secrets to the repository
- Use `.env.local` for local development (gitignored)

## CI troubleshooting

- **Format check fails**: Run `npm run format` at repo root, then commit and push. CI runs `format:check`, `lint`, `test:unit`, and `e2e_smoke` on push/PR to main.
- **Dependabot PR fails**: Major bumps (e.g. eslint 10, @types/node 25) may need config or dependency alignment; update and push to the PR branch or merge main into it and re-run.
- **CodeQL failing**: The `codeql.yml` workflow runs CodeQL analysis on push/PR to main. The analyze job has `continue-on-error: true` so a CodeQL failure does not block the run. To fix CodeQL itself: ensure JavaScript/TypeScript files are discoverable; see [CodeQL troubleshooting](https://docs.github.com/en/code-security/code-scanning/troubleshooting-code-scanning).
- **Continuous AI statuses fail on PRs**: This repo treats native CI as authoritative. The `continuous_ai_bridge` job posts success back to the known `Continuous AI: ...` status contexts after `arch_guard`, `test`, `secret-scan`, `e2e_smoke`, and `quality` pass, so external paid-app failures do not block merges.

## Branch protection (required on `main`)

- **update-branch-protection-status-checks.js**: Run `node scripts/github/update-branch-protection-status-checks.js` (with GITHUB_TOKEN or .env.local) to set required status checks for `main` to the native CI job names: `arch_guard`, `test`, `secret-scan`, `e2e_smoke`, `quality`.
- **verify-governance-settings.js**: Run `node scripts/github/verify-governance-settings.js` (or `npm run verify:governance`) with `GITHUB_ADMIN_TOKEN` to verify PR reviews, code-owner reviews, required checks, conversation resolution, and include-admin settings on `main`.
- **Required checks**: `arch_guard`, `test`, `secret-scan`, `e2e_smoke`, and `quality`.
- **Best practice**: Do not require external Codacy or Continuous AI status contexts in branch protection. Native GitHub Actions checks are the authoritative repo merge gate in this repo.
- **If a governance script returns 403 `Resource not accessible by integration`**: the token lacks repo-admin permission to read or update branch protection. Use an admin-scoped token (`GITHUB_ADMIN_TOKEN`) or verify settings manually in GitHub.

## Implemented

- **shopify-sync.yml backup-store job**: Implemented. Theme pull via REST; pushes backup to `shopify-theme-backup` branch. See `shopify-sync.yml` backup-store job.
