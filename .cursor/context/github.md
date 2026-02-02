# GitHub Integration Context

## Repository Information

- **Repository**: https://github.com/toodeceptive/against-the-odds.git
- **Username**: toodeceptive
- **Default Branch**: main

## Authentication

- **Method**: Personal Access Token (PAT)
- **Storage**: `.env.local` or Windows Credential Manager
- **Verification**: `scripts/github/verify-auth.ps1`

## Workflows

- **Branch strategy**: main-only (no develop branch).
- CI: `.github/workflows/ci.yml` (push/PR to main; consolidated lint, format, test, Trivy, secret-scan, npm audit, Lighthouse)
- Shopify Sync: `.github/workflows/shopify-sync.yml`
- Sync theme branch: `.github/workflows/sync-theme-branch.yml` (main → shopify-theme)
- Maintenance: `.github/workflows/maintenance.yml`
- Sync: `.github/workflows/sync.yml` (repo sync; main-only status)

## Secrets Required

- SHOPIFY_STORE_DOMAIN
- SHOPIFY_ACCESS_TOKEN
- SHOPIFY_THEME_ID

## Common Operations

- Verify auth: `scripts/github/verify-auth.ps1`
- Test push/pull: `scripts/github/test-push-pull.ps1`
- Verify secrets: `scripts/github/verify-secrets.ps1`
