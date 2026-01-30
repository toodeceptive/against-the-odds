# Optimization Guide

## Performance Optimization

### Script Optimization

#### Reduce API Calls

**Before**:

```powershell
foreach ($product in $products) {
    $response = Invoke-RestMethod -Uri "$baseUrl/products/$product.id.json"
}
```

**After**:

```powershell
# Batch requests or use pagination
$response = Invoke-RestMethod -Uri "$baseUrl/products.json?limit=250"
```

#### Implement Caching

```powershell
$cacheFile = "cache/products.json"
if (Test-Path $cacheFile -NewerThan (Get-Date).AddMinutes(-5)) {
    $products = Get-Content $cacheFile | ConvertFrom-Json
} else {
    $products = Invoke-RestMethod -Uri "$baseUrl/products.json"
    $products | ConvertTo-Json | Out-File $cacheFile
}
```

#### Use Parallel Processing

```powershell
$jobs = $items | ForEach-Object -Parallel {
    # Process item
} -ThrottleLimit 5
```

### Browser Automation Optimization

#### Reuse Browser Context

```javascript
// Good: Reuse browser
const browser = await connectToBrowser({ useExisting: true });
const context = await browser.newContext();
const page = await context.newPage();

// Bad: Launch new browser each time
```

#### Optimize Selectors

```javascript
// Good: Specific selector
await page.locator('[data-product-id="123"]').click();

// Bad: Generic selector
await page.locator('div').nth(5).click();
```

#### Reduce Wait Times

```javascript
// Good: Wait for specific element
await page.waitForSelector('[data-loaded]', { timeout: 5000 });

// Bad: Fixed sleep
await page.waitForTimeout(5000);
```

## Code Quality Optimization

### Error Handling

#### Comprehensive Error Handling

```powershell
try {
    $result = Invoke-RestMethod -Uri $url
} catch {
    $errorMessage = $_.Exception.Message
    if ($_.ErrorDetails.Message) {
        $errorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
        $errorMessage = $errorDetails.errors -join '; '
    }
    Write-ErrorWithContext -Message "API call failed" -Exception $_
    throw
}
```

### Code Reusability

#### Use Shared Utilities

```powershell
# Load utilities
. "scripts\shared\utilities.ps1"

# Use shared functions
$store = Get-EnvVar "SHOPIFY_STORE_DOMAIN"
$result = Invoke-ShopifyAPI -Store $store -Token $token -Endpoint "shop.json"
```

## Network Optimization

### Request Batching

```powershell
# Batch multiple products in one request
$products = @($product1, $product2, $product3)
$body = @{ products = $products } | ConvertTo-Json
Invoke-RestMethod -Uri "$baseUrl/products.json" -Method Post -Body $body
```

### Connection Pooling

```powershell
# Reuse HTTP connections
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "AgainstTheOdds/1.0"

# Use session for multiple requests
Invoke-RestMethod -Uri $url1 -WebSession $session
Invoke-RestMethod -Uri $url2 -WebSession $session
```

## Monitoring Optimization

### Efficient Health Checks

```powershell
# Check only critical systems
$criticalChecks = @("git", "shopify_api", "github_api")
foreach ($check in $criticalChecks) {
    # Quick check
}
```

### Caching Health Data

```powershell
$healthCache = "cache/health.json"
if (Test-Path $healthCache -NewerThan (Get-Date).AddMinutes(-10)) {
    # Use cached data
} else {
    # Run fresh check
}
```

## Security Optimization

### Credential Management

```powershell
# Use secure storage
$token = [System.Environment]::GetEnvironmentVariable('SHOPIFY_ACCESS_TOKEN', 'User')

# Or Windows Credential Manager
$cred = Get-StoredCredential -Target "shopify-api"
$token = $cred.GetNetworkCredential().Password
```

### API Key Rotation

```powershell
# Implement key rotation
function Rotate-APIKey {
    # Generate new key
    # Update in secure storage
    # Verify new key works
    # Remove old key
}
```

## Documentation Optimization

### Auto-Generated Docs

```powershell
# Generate API docs from code
.\scripts\docs\auto-generate.ps1 -Type api

# Update changelog automatically
.\scripts\docs\auto-generate.ps1 -Type changelog
```

### Keep Docs Updated

- Run documentation generation regularly
- Review and update manually as needed
- Link related documentation
- Include examples and use cases

## Best Practices Summary

1. **Minimize API Calls**: Batch requests, use pagination, implement caching
2. **Optimize Selectors**: Use specific, stable selectors
3. **Error Handling**: Comprehensive error handling with context
4. **Code Reuse**: Use shared utilities and functions
5. **Monitoring**: Efficient health checks with caching
6. **Security**: Secure credential storage and rotation
7. **Documentation**: Keep documentation current and comprehensive

## Performance Metrics

### Target Metrics

- Script execution: < 30 seconds for most operations
- API response time: < 1 second per request
- Browser automation: < 10 seconds per page
- Health check: < 5 seconds
- Test suite: < 2 minutes

### Monitoring

Track these metrics:

- Script execution times
- API response times
- Error rates
- Success rates
- Resource usage

## Continuous Improvement

1. **Regular Reviews**: Review performance monthly
2. **Optimization Opportunities**: Identify and address bottlenecks
3. **Update Dependencies**: Keep tools and libraries updated
4. **Refactor Code**: Improve code quality and performance
5. **Monitor Trends**: Track performance over time

## References

- [PowerShell Performance](https://docs.microsoft.com/en-us/powershell/scripting/dev-cross-plat/performance)
- [Playwright Best Practices](https://playwright.dev/docs/best-practices)
- [API Optimization](docs/knowledge-base/optimization-techniques.md)
