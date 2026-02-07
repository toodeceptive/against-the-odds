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
- Actions: Lint, format check, unit tests, build, Trivy (security scan), secret-scan, npm audit (continue-on-error), optional coverage, Lighthouse (continue-on-error). Single workflow for all quality gates.

### `shopify-sync.yml`

- Runs on: Daily at 2 AM, Push to `main` (data/products, src/shopify), Manual trigger
- Actions: Syncs products to Shopify; backup-store job is **placeholder** (implement or remove)
- **Resilience**: If `SHOPIFY_STORE_DOMAIN` or `SHOPIFY_ACCESS_TOKEN` are not set, the sync step skips gracefully (exit 0) so the workflow does not fail.

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

## CI troubleshooting

- **Format check fails**: Run `npm run format` at repo root, then commit and push. CI runs `format:check`, `lint`, `test:unit` on push/PR to main.
- **Dependabot PR fails**: Major bumps (e.g. eslint 10, @types/node 25) may need config or dependency alignment; update and push to the PR branch or merge main into it and re-run.

## To implement (optional)

- **shopify-sync.yml backup-store job**: To implement: add a step that runs a script (e.g. product/theme export to a GitHub Actions artifact or a branch). To remove: delete the `backup-store` job from the workflow.
