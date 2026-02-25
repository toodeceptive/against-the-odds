# GitHub Repository Settings Optimization Guide

## Repository Information

### Description

```text
Official Against The Odds (AO) brand website and Shopify store. Complete development infrastructure with automated workflows, Shopify integration, and comprehensive project management.
```

### Topics

- `e-commerce`
- `shopify`
- `streetwear`
- `brand`
- `merchandise`
- `against-the-odds`
- `automation`
- `typescript`
- `powershell`

### Website

```text
https://aodrop.com
```

## Branch Protection Rules

### Main Branch Protection

**Settings Location**: Settings > Branches > Branch protection rules

**Rules to Enable**:

1. ✅ Require a pull request before merging
   - Require approvals: 1
   - Dismiss stale pull request approvals when new commits are pushed
   - Require review from Code Owners (if CODEOWNERS file exists)

2. ✅ Require status checks to pass before merging
   - Require branches to be up to date before merging
   - Status checks to require: `arch_guard`, `test`, `secret-scan`, `quality` (job names in `.github/workflows/ci.yml`)

3. ✅ Require conversation resolution before merging

4. ✅ Do not allow bypassing the above settings

5. ✅ Restrict who can push to matching branches
   - (Optional) Restrict to specific users/teams

### Develop Branch Protection

This repository is main-only. Do not configure a develop branch protection rule.

## GitHub Actions Settings

### Workflow Permissions

**Settings Location**: Settings > Actions > General > Workflow permissions

**Recommended Settings**:

- ✅ Read and write permissions
- ✅ Allow GitHub Actions to create and approve pull requests

### Secrets Configuration

**Settings Location**: Settings > Secrets and variables > Actions

**Required Secrets**:

- `SHOPIFY_STORE_DOMAIN` = `aodrop.com`
- `SHOPIFY_ACCESS_TOKEN` = (Your Shopify Admin API access token)
- `SHOPIFY_THEME_ID` = (Your Shopify theme ID)

**Optional Secrets**:

- `SHOPIFY_API_KEY` = (Your Shopify app client ID)
- `SHOPIFY_API_SECRET` = (Your Shopify API secret)
- `GITHUB_TOKEN` = (For enhanced GitHub API access)
- `CLOUDFLARE_API_TOKEN` = (If using Cloudflare)

## Repository Features

### Enable/Disable Features

**Settings Location**: Settings > General > Features

**Recommended**:

- ✅ Issues
- ✅ Projects
- ⚠️ Wiki (optional)
- ⚠️ Discussions (optional)
- ❌ Packages (unless needed)

## README Badges

Add to README.md:

```markdown
![CI](https://github.com/toodeceptive/against-the-odds/workflows/CI/badge.svg)
![Quality](https://github.com/toodeceptive/against-the-odds/workflows/Quality%20Check/badge.svg)
![License](https://img.shields.io/badge/license-UNLICENSED-red)
```

## Automation Scripts

Use the provided scripts to verify and optimize:

```powershell
# Verify authentication
.\scripts\github\verify-auth.ps1

# Test push/pull
.\scripts\github\test-push-pull.ps1

# Verify secrets
.\scripts\github\verify-secrets.ps1

# Get optimization recommendations
.\scripts\github\optimize-repo.ps1
```

## Next Steps

1. Update repository description and topics
2. Configure branch protection rules
3. Set up GitHub Actions secrets
4. Enable repository features
5. Add README badges
6. Verify all settings with scripts
