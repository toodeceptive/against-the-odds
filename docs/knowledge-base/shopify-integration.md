# Shopify Integration Deep Dive

## Architecture Overview

The Shopify integration uses a multi-layered approach:

1. **Admin API**: RESTful API for product, order, and store management
2. **Storefront API**: GraphQL API for headless commerce (if needed)
3. **Theme API**: For theme development and deployment
4. **Browser Automation**: For complex UI workflows and credential extraction

## API Versions

- **Current**: 2026-01
- **Update Frequency**: Quarterly
- **Deprecation**: 2 years after release

## Authentication Methods

### Admin API Access Token

- Format: `shpat_` followed by 32+ characters
- Scope: Defined in app settings
- Storage: `.env.local` or Windows Credential Manager
- Rotation: Recommended every 90 days

### API Key and Secret

- Used for OAuth flows
- Client ID: `your_shopify_api_key_here`
- Secret: Stored securely, never in code

## Common Operations

### Product Management

```powershell
# Sync products
.\scripts\products\sync.ps1 -Direction import

# Export products
.\scripts\products\export.ps1

# Import products
.\scripts\products\import.ps1
```

### Theme Development

```powershell
# Start theme development
.\scripts\shopify\theme-dev.ps1

# Pull theme
.\scripts\shopify\theme-pull.ps1

# Deploy theme
.\scripts\shopify\update-theme.ps1
```

## Rate Limits

- **Admin API**: 40 requests per app per store per minute
- **Storefront API**: 2 requests per second
- **Best Practice**: Implement retry logic with exponential backoff

## Error Handling

### Common Errors

- **401 Unauthorized**: Invalid or expired token
- **403 Forbidden**: Insufficient permissions
- **429 Too Many Requests**: Rate limit exceeded
- **422 Unprocessable Entity**: Invalid request data

### Retry Strategy

```powershell
function Invoke-WithRetry {
    param([scriptblock]$ScriptBlock, [int]$MaxRetries = 3)

    $attempt = 0
    while ($attempt -lt $MaxRetries) {
        try {
            return & $ScriptBlock
        } catch {
            if ($_.Exception.Response.StatusCode -eq 429) {
                $retryAfter = $_.Exception.Response.Headers['Retry-After']
                Start-Sleep -Seconds $retryAfter
            }
            $attempt++
        }
    }
}
```

## Webhooks

### Setup

Webhooks can be configured for:

- Order creation/updates
- Product creation/updates
- Customer events
- Inventory changes

### Handling

Use Google Cloud Pub/Sub or Amazon EventBridge for high-volume webhooks.

## Best Practices

1. **Use API versioning**: Always specify API version
2. **Handle rate limits**: Implement retry logic
3. **Validate data**: Check data before sending to API
4. **Use webhooks**: For real-time updates
5. **Cache responses**: Reduce API calls
6. **Monitor usage**: Track API usage and costs

## References

- [Shopify Admin API](https://shopify.dev/docs/api/admin)
- [API Versioning](https://shopify.dev/docs/api/usage/versioning)
- [Rate Limits](https://shopify.dev/docs/api/usage/rate-limits)
