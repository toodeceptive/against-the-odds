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

- CI: `.github/workflows/ci.yml`
- Deploy: `.github/workflows/deploy.yml`
- Shopify Sync: `.github/workflows/shopify-sync.yml`
- Quality: `.github/workflows/quality-check.yml`
- Maintenance: `.github/workflows/maintenance.yml`
- Sync: `.github/workflows/sync.yml`

## Secrets Required

- SHOPIFY_STORE_DOMAIN
- SHOPIFY_ACCESS_TOKEN
- SHOPIFY_THEME_ID

## Common Operations

- Verify auth: `scripts/github/verify-auth.ps1`
- Test push/pull: `scripts/github/test-push-pull.ps1`
- Verify secrets: `scripts/github/verify-secrets.ps1`
