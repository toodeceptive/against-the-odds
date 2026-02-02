# GitHub Workflows Guide

## Workflow Overview

The project uses GitHub Actions for CI/CD automation:

1. **CI**: Consolidated quality gate (lint, format, test, Trivy, secret-scan, npm audit, Lighthouse) on push/PR to main
2. **Sync**: Repository synchronization (main-only)
3. **Shopify Sync**: Product and theme sync
4. **Sync theme branch**: Subtree-split theme to shopify-theme branch for Shopify GitHub App
5. **Maintenance**: Dependency update PRs, weekly Trivy

## Workflow Files

### ci.yml

Runs on: Push to main, Pull requests targeting main

Actions:

- Lint, format check, unit tests, build
- Trivy security scan, secret-scan, npm audit (continue-on-error where appropriate)
- Optional coverage, Lighthouse (continue-on-error)

### shopify-sync.yml

Runs on: Daily at 2 AM, Push to main (product/theme changes)

Actions:

- Sync products to Shopify
- Backup store configuration

## Secrets Configuration

Required secrets in GitHub Settings > Secrets and variables > Actions:

- `SHOPIFY_STORE_DOMAIN`
- `SHOPIFY_ACCESS_TOKEN`
- `SHOPIFY_THEME_ID`

## Workflow Optimization

### Caching

```yaml
- uses: actions/cache@v3
  with:
    path: node_modules
    key: ${{ runner.os }}-node-${{ hashFiles('package-lock.json') }}
```

### Matrix Strategy

```yaml
strategy:
  matrix:
    node-version: [18, 20]
```

### Conditional Execution

```yaml
if: github.ref == 'refs/heads/main'
```

## Troubleshooting

### Workflow Failures

1. Check workflow logs in GitHub Actions
2. Verify secrets are configured
3. Check workflow syntax
4. Verify permissions

### Secret Issues

1. Verify secrets exist: `.\scripts\github\verify-secrets.ps1`
2. Check secret names match workflow
3. Ensure secrets have correct values

## Best Practices

1. **Use secrets**: Never hardcode credentials
2. **Cache dependencies**: Speed up workflows
3. **Fail fast**: Stop on first error
4. **Parallel execution**: Run independent jobs in parallel
5. **Conditional steps**: Skip unnecessary steps

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax)
