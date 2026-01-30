# GitHub Workflows Guide

## Workflow Overview

The project uses GitHub Actions for CI/CD automation:

1. **CI**: Continuous Integration on every push
2. **Deploy**: Automated deployment
3. **Sync**: Repository synchronization
4. **Shopify Sync**: Product and theme sync
5. **Quality**: Code quality checks
6. **Maintenance**: Automated maintenance tasks

## Workflow Files

### ci.yml

Runs on: Push to main/develop, Pull requests

Actions:

- Lint code
- Run tests
- Build verification
- Security scanning

### deploy.yml

Runs on: Push to main/develop, Manual trigger

Actions:

- Deploy to staging (develop branch)
- Deploy to production (main branch)
- Shopify theme deployment

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
