# Performance Optimization Techniques

## API Optimization

### Request Batching

Batch multiple operations into single requests:

```powershell
# Instead of multiple requests
foreach ($product in $products) {
    Invoke-RestMethod -Uri "$baseUrl/products/$product.id.json"
}

# Use batch endpoint
$body = @{ products = $products } | ConvertTo-Json
Invoke-RestMethod -Uri "$baseUrl/products/bulk.json" -Method Post -Body $body
```

### Pagination

Use pagination for large datasets:

```powershell
$page = 1
$hasMore = $true
while ($hasMore) {
    $response = Invoke-RestMethod -Uri "$baseUrl/products.json?page=$page&limit=250"
    # Process products
    $hasMore = $response.products.Count -eq 250
    $page++
}
```

### Caching

Implement caching for frequently accessed data:

```powershell
$cacheFile = "cache/shop-info.json"
$cacheAge = 5 # minutes

if (Test-Path $cacheFile) {
    $fileAge = (Get-Date) - (Get-Item $cacheFile).LastWriteTime
    if ($fileAge.TotalMinutes -lt $cacheAge) {
        $shopInfo = Get-Content $cacheFile | ConvertFrom-Json
    } else {
        $shopInfo = Invoke-RestMethod -Uri "$baseUrl/shop.json"
        $shopInfo | ConvertTo-Json | Out-File $cacheFile
    }
} else {
    $shopInfo = Invoke-RestMethod -Uri "$baseUrl/shop.json"
    $shopInfo | ConvertTo-Json | Out-File $cacheFile
}
```

## Script Optimization

### Parallel Processing

Use PowerShell jobs for parallel execution:

```powershell
$jobs = $items | ForEach-Object -Parallel {
    # Process item
    Process-Item $_
} -ThrottleLimit 5

$results = $jobs | Receive-Job -Wait
```

### Reduce Function Calls

Cache function results:

```powershell
$envVars = @{}
function Get-EnvVar-Cached {
    param([string]$Name)
    if (-not $envVars.ContainsKey($Name)) {
        $envVars[$Name] = Get-EnvVar $Name
    }
    return $envVars[$Name]
}
```

## Browser Automation Optimization

### Reuse Browser Context

```javascript
// Good: Reuse context
const context = await browser.newContext();
const page1 = await context.newPage();
const page2 = await context.newPage();

// Bad: New context each time
```

### Optimize Selectors

```javascript
// Good: Specific, stable selector
await page.locator('[data-testid="submit-button"]').click();

// Bad: Fragile selector
await page.locator('div > button').nth(3).click();
```

### Reduce Wait Times

```javascript
// Good: Wait for specific condition
await page.waitForSelector('[data-loaded="true"]', { timeout: 5000 });

// Bad: Fixed timeout
await page.waitForTimeout(5000);
```

## Network Optimization

### Connection Pooling

Reuse HTTP connections:

```powershell
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "AgainstTheOdds/1.0"

# Reuse session
Invoke-RestMethod -Uri $url1 -WebSession $session
Invoke-RestMethod -Uri $url2 -WebSession $session
```

### Compression

Enable compression for large responses:

```powershell
$headers = @{
    "Accept-Encoding" = "gzip, deflate"
}
```

## Monitoring Optimization

### Efficient Health Checks

Check only critical systems:

```powershell
$criticalSystems = @("git", "shopify_api", "github_api")
foreach ($system in $criticalSystems) {
    Test-System $system
}
```

### Caching Health Data

```powershell
$healthCache = "cache/health.json"
$cacheAge = 10 # minutes

if (Test-Path $healthCache) {
    $age = (Get-Date) - (Get-Item $healthCache).LastWriteTime
    if ($age.TotalMinutes -lt $cacheAge) {
        return Get-Content $healthCache | ConvertFrom-Json
    }
}

# Run fresh check
$health = Get-HealthStatus
$health | ConvertTo-Json | Out-File $healthCache
```

## Best Practices

1. **Measure First**: Profile before optimizing
2. **Cache Aggressively**: Cache frequently accessed data
3. **Batch Operations**: Combine multiple operations
4. **Use Parallel Processing**: For independent operations
5. **Optimize Selectors**: Use specific, stable selectors
6. **Reduce Network Calls**: Minimize API requests
7. **Monitor Performance**: Track metrics over time

## Performance Targets

- Script execution: < 30 seconds
- API response: < 1 second
- Browser automation: < 10 seconds per page
- Health check: < 5 seconds
- Test suite: < 2 minutes

## References

- [PowerShell Performance](https://docs.microsoft.com/en-us/powershell/scripting/dev-cross-plat/performance)
- [Playwright Performance](https://playwright.dev/docs/performance)
- [API Optimization](https://shopify.dev/docs/api/usage/rate-limits)
