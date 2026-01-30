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

### `ci.yml`

- Runs on: Push to `main`/`develop`, Pull requests
- Actions: Linting, testing, security scanning

### `deploy.yml`

- Runs on: Push to `main`/`develop`, Manual trigger
- Actions: Deploys to staging/production, Shopify theme deployment

### `shopify-sync.yml`

- Runs on: Daily at 2 AM, Push to `main` (product/theme changes), Manual trigger
- Actions: Syncs products to Shopify, backs up store configuration

### `sync.yml`

- Runs on: Schedule, Manual trigger
- Actions: Repository synchronization

### `quality-check.yml`

- Runs on: Pull requests
- Actions: Code quality checks

### `maintenance.yml`

- Runs on: Schedule (daily)
- Actions: Dependency updates, security scanning, performance monitoring

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
