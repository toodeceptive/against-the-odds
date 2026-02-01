# GitHub Actions Workflows

## Required Secrets

These workflows require the following secrets to be configured in GitHub:

### Repository Secrets (Settings > Secrets and variables > Actions)

1. **SHOPIFY_STORE_DOMAIN**
   - Value: `aodrop.com`
   - Used by: `deploy.yml`, `shopify-sync.yml`

2. **SHOPIFY_ACCESS_TOKEN**
   - Value: Your Shopify Admin API access token
   - Used by: `deploy.yml`, `shopify-sync.yml`

3. **SHOPIFY_THEME_ID** (optional)
   - Value: Your Shopify theme ID
   - Used by: `deploy.yml`

## Workflow Files

### CI vs quality-check (both run on push/PR to main only)

- **`ci.yml`**: **Fast gate** — lint, test, build, Trivy (security scan), secret-scan, Lighthouse. Runs on every push/PR to `main`.
- **`quality-check.yml`**: **Deeper check** — code coverage, lint, format check, npm audit, Lighthouse. Same triggers. Overlap with CI: both run lint and Lighthouse; use both if you want a quick gate (CI) plus coverage/format (quality-check), or consider merging into one workflow later.

### `ci.yml`

- Runs on: Push to `main`, Pull requests targeting `main`
- Actions: Linting, testing, build, Trivy security scan, secret-scan, Lighthouse

### `quality-check.yml`

- Runs on: Push to `main`, Pull requests targeting `main`
- Actions: Code coverage, lint, format check, npm audit, Lighthouse

### `deploy.yml`

- Runs on: Push to `main`, Manual trigger (workflow_dispatch)
- Actions: **Placeholder** — deploy-staging (disabled; no develop branch) / deploy-production (echo only). Shopify theme deployment is via Shopify GitHub App / `sync-theme-branch.yml`.

### `shopify-sync.yml`

- Runs on: Daily at 2 AM, Push to `main` (data/products, src/shopify), Manual trigger
- Actions: Syncs products to Shopify; backup-store job is **placeholder** (implement or remove)

### `sync-theme-branch.yml`

- Runs on: Push to `main` when `src/shopify/themes/aodrop-theme/**` changes
- Actions: Subtree-split theme to `shopify-theme` branch and push (for Shopify “Connect from GitHub”)

### `sync.yml`

- Runs on: Schedule (every 6 h), Manual trigger
- Actions: Repository sync (fetch, checkout main; no develop branch)

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

## To implement (optional)

- **deploy.yml**: To add real deployment: add steps (e.g. `shopify theme push`, or call to your hosting API) in the `deploy-production` job; use secrets for credentials. To remove: delete the workflow file or replace jobs with a single no-op step.
- **shopify-sync.yml backup-store job**: To implement: add a step that runs a script (e.g. product/theme export to a GitHub Actions artifact or a branch). To remove: delete the `backup-store` job from the workflow.
