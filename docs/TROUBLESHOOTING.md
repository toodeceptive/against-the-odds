# Troubleshooting Guide

## Common Issues and Solutions

### Cursor IDE: "Failed to gather Agent Review context" (Error when executing 'git')

**Symptoms**: Red notification in Cursor: "Failed to gather Agent Review context. Caused by: Error when executing 'git':" or `git: 'credential-manager-core' is not a git command`.

**Cause**: Git is configured to use a credential helper (`credential-manager-core`) that is not installed or not in PATH when Cursor runs git.

**Permanent fix** (run once in a terminal):

```powershell
git config --global credential.helper manager
```

On Windows this uses Git Credential Manager (GCM). If you use another helper, set it to one that exists (e.g. `wincred` or `store`). After this, restart Cursor so Agent Review’s git calls use the fixed config.

### Environment Setup Issues

#### .env.local Not Found

**Symptoms**: Scripts fail with "environment variable not set"

**Solutions**:

1. Run automated setup: `.\scripts\setup\auto-configure-env.ps1`
2. Manually create: `Copy-Item .env.example .env.local`
3. Verify file exists: `Test-Path .env.local`

#### Credentials Not Working

**Symptoms**: API calls return 401/403 errors

**Solutions**:

1. Verify credentials in `.env.local`
2. Check for typos or extra spaces
3. Ensure credentials haven't expired
4. Re-extract credentials using browser automation
5. Run verification: `.\scripts\setup\verify-credentials.ps1`

### GitHub Issues

#### Authentication Failed

**Symptoms**: `git push` fails with authentication error

**Solutions**:

1. Verify GitHub token: `.\scripts\github\verify-auth.ps1`
2. Check token hasn't expired
3. Regenerate token if needed
4. Store in Windows Credential Manager:
   ```powershell
   cmdkey /generic:git:https://github.com /user:toodeceptive /pass:YOUR_TOKEN
   ```

#### Push/Pull Failures

**Symptoms**: Cannot push or pull from repository

**Solutions**:

1. Check network connectivity
2. Verify repository access: `.\scripts\github\test-push-pull.ps1`
3. Check for uncommitted changes: `git status`
4. Resolve conflicts: `git pull --rebase origin main`

### Shopify Issues

#### API Connection Failed

**Symptoms**: Shopify API calls return errors

**Solutions**:

1. Test connection: `.\scripts\shopify\test-connection.ps1`
2. Verify access token is valid
3. Check API version matches (2026-01)
4. Verify store domain is correct
5. Check API rate limits

#### Browser Automation Fails

**Symptoms**: Cannot connect to Chrome or extract data

**Solutions**:

1. Ensure Chrome is running
2. Launch Chrome with debugging: `chrome.exe --remote-debugging-port=9222`
3. Check if Shopify admin is logged in
4. Try launching new browser instead
5. Check Playwright is installed: `npx playwright --version`

#### Product Sync Issues

**Symptoms**: Products not syncing correctly

**Solutions**:

1. Check product JSON format is valid
2. Verify API permissions (read_products, write_products)
3. Run with dry-run first: `.\scripts\products\sync.ps1 -DryRun`
4. Check error messages in output
5. Verify product data structure matches Shopify format

### Script Execution Issues

#### PowerShell Execution Policy

**Symptoms**: "Script cannot be loaded because running scripts is disabled"

**Solutions**:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Node.js Not Found

**Symptoms**: Browser automation scripts fail

**Solutions**:

1. Install Node.js: https://nodejs.org/
2. Verify installation: `node --version`
3. Install dependencies: `npm install`

#### Module Not Found

**Symptoms**: "Cannot find module" errors

**Solutions**:

1. Install dependencies: `npm install`
2. Check package.json includes required packages
3. Verify node_modules exists

### Synchronization Issues

#### Git Out of Sync

**Symptoms**: Local and remote repositories differ

**Solutions**:

1. Check sync status: `.\scripts\sync\verify-all.ps1`
2. Auto-fix: `.\scripts\sync\auto-fix.ps1`
3. Manual sync: `git pull origin main`
4. Resolve conflicts if any

#### Environment Out of Sync

**Symptoms**: Different behavior on different machines

**Solutions**:

1. Verify `.env.local` is configured on all machines
2. Check `.env.example` is up to date
3. Ensure all required tools are installed
4. Run health check: `.\scripts\health\comprehensive-check.ps1`

### Performance Issues

#### Slow Script Execution

**Symptoms**: Scripts take too long to run

**Solutions**:

1. Check network connectivity
2. Verify API response times
3. Reduce batch sizes in API calls
4. Enable caching where possible
5. Check system resources

#### Browser Automation Slow

**Symptoms**: Browser automation is slow

**Solutions**:

1. Use existing browser instead of launching new
2. Reduce wait times (if safe)
3. Optimize selectors
4. Use headless mode for non-interactive tasks
5. Check Chrome performance

### Testing Issues

#### Tests Failing

**Symptoms**: Test suite reports failures

**Solutions**:

1. Check test output for specific errors
2. Verify environment is set up correctly
3. Ensure credentials are configured
4. Run tests individually to isolate issues
5. Check test timeout settings

#### Coverage Low

**Symptoms**: Test coverage below 90%

**Solutions**:

1. Add tests for uncovered code paths
2. Test error scenarios
3. Add integration tests
4. Test edge cases
5. Review coverage report: `npm run test:coverage`

## Diagnostic Commands

### Quick Diagnostics

```powershell
# Full system check
.\scripts\health\comprehensive-check.ps1

# Verify credentials
.\scripts\setup\verify-credentials.ps1

# Check synchronization
.\scripts\sync\verify-all.ps1

# Test connections
.\scripts\shopify\test-connection.ps1
.\scripts\github\verify-auth.ps1
```

### Detailed Diagnostics

```powershell
# Health report
.\scripts\health\generate-report.ps1

# Performance check
.\scripts\monitoring\performance-check.ps1

# GitHub verification
.\scripts\github\verify-auth.ps1 -TestPush -TestPull -CheckSecrets
```

## Getting Help

### Check Logs

- Health reports: `docs/status/health-report.json`
- Performance reports: `docs/status/performance-report.json`
- Alert logs: `docs/status/alerts-*.txt`

### Review Documentation

- [Environment Setup](ENVIRONMENT_SETUP.md)
- [Browser Automation](BROWSER_AUTOMATION.md)
- [Shopify Setup](SHOPIFY_SETUP.md)
- [GitHub Setup](SETUP_GITHUB.md)

### Common Error Codes

- **401 Unauthorized**: Invalid or expired credentials
- **403 Forbidden**: Insufficient permissions
- **404 Not Found**: Resource doesn't exist or wrong URL
- **429 Too Many Requests**: Rate limit exceeded, wait and retry
- **500 Server Error**: Shopify/GitHub server issue, retry later

## Prevention

### Best Practices

1. **Regular Verification**: Run health checks regularly
2. **Credential Rotation**: Rotate credentials periodically
3. **Backup Configuration**: Keep backups of working configurations
4. **Monitor Logs**: Review logs for early warning signs
5. **Update Dependencies**: Keep tools and packages updated
6. **Document Changes**: Document any manual changes made

### Automated Monitoring

Set up continuous monitoring:

```powershell
# Monitor continuously (every 5 minutes)
.\scripts\health\monitor-continuously.ps1 -IntervalSeconds 300

# Alert on issues
.\scripts\health\alert-on-issues.ps1
```

## Still Need Help?

1. Check all documentation in `docs/` directory
2. Review error messages carefully
3. Check GitHub Issues (if repository is public)
4. Verify all prerequisites are installed
5. Run comprehensive diagnostics
