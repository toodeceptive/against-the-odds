# Monitoring & Performance Tracking

## Overview

This document outlines the monitoring and performance tracking systems for the Against The Odds project, including site performance, API health, and automated maintenance.

## Monitoring Components

### 1. Performance Monitoring

**Script**: `scripts/monitoring/performance-check.ps1`

Monitors:
- Site availability and response times
- Shopify API connectivity
- GitHub API connectivity
- Response times for all services

**Usage**:
```powershell
# Check all services
.\scripts\monitoring\performance-check.ps1

# Check specific service
.\scripts\monitoring\performance-check.ps1 -Check site
.\scripts\monitoring\performance-check.ps1 -Check shopify
.\scripts\monitoring\performance-check.ps1 -Check api
```

**Output**: Performance reports saved to `docs/status/performance-report.json`

### 2. Site Performance

**Metrics Tracked**:
- HTTP response codes
- Response times (milliseconds)
- Availability status
- Error messages (if any)

**Targets**:
- Response time: < 2 seconds
- Uptime: > 99.9%
- Status code: 200 OK

### 3. Shopify API Monitoring

**Metrics Tracked**:
- API connectivity
- Response times
- Shop information retrieval
- Authentication status

**Targets**:
- Response time: < 1 second
- Availability: 100%
- Authentication: Valid

### 4. GitHub API Monitoring

**Metrics Tracked**:
- Repository access
- API response times
- Authentication status
- Repository status

**Targets**:
- Response time: < 500ms
- Availability: 100%
- Authentication: Valid

## Automated Monitoring

### GitHub Actions Workflow

The `.github/workflows/maintenance.yml` workflow includes automated monitoring:

- **Schedule**: Runs daily at 2 AM UTC
- **Checks**: Performance monitoring, security scanning, dependency updates
- **Notifications**: Sends alerts on failures

### Local Monitoring

Run performance checks manually:
```powershell
.\scripts\monitoring\performance-check.ps1
```

## Performance Reports

Reports are stored in `docs/status/performance-report.json`:

```json
{
  "timestamp": "2026-01-28 12:00:00",
  "checks": [
    {
      "type": "site",
      "url": "https://aodrop.com",
      "status": "online",
      "response_time_ms": 450,
      "status_code": 200
    },
    {
      "type": "shopify_api",
      "store": "aodrop.com",
      "status": "online",
      "response_time_ms": 320,
      "shop_name": "Against The Odds"
    }
  ]
}
```

## Maintenance Tasks

### Automated Maintenance

**Script**: `.github/workflows/maintenance.yml`

**Tasks**:
1. Dependency updates
2. Security scanning
3. Performance monitoring
4. Code quality checks

### Manual Maintenance

**Script**: `scripts/maintenance/update-dependencies.ps1`

Updates project dependencies:
```powershell
.\scripts\maintenance\update-dependencies.ps1
```

**Script**: `scripts/maintenance/security-scan.ps1`

Scans for security vulnerabilities:
```powershell
.\scripts\maintenance\security-scan.ps1
```

## Alerting

### Failure Notifications

When monitoring detects failures:
1. Log error to performance report
2. Create GitHub issue (if configured)
3. Send notification (if configured)

### Performance Degradation

When performance degrades:
1. Log warning to performance report
2. Create GitHub issue for investigation
3. Alert team (if configured)

## Best Practices

1. **Regular Monitoring**: Run performance checks daily
2. **Baseline Metrics**: Establish baseline performance metrics
3. **Alert Thresholds**: Set appropriate alert thresholds
4. **Documentation**: Document all monitoring configurations
5. **Review Reports**: Regularly review performance reports
6. **Optimization**: Act on performance issues promptly

## Configuration

### Environment Variables

Required for monitoring:
- `SHOPIFY_STORE_DOMAIN` - Shopify store domain
- `SHOPIFY_ACCESS_TOKEN` - Shopify API token
- `GITHUB_TOKEN` - GitHub API token
- `GITHUB_USERNAME` - GitHub username
- `GITHUB_REPO` - Repository name

### Monitoring Configuration

Configuration files in `config/monitoring/`:
- `performance-thresholds.json` - Performance thresholds
- `alert-config.json` - Alert configuration

## Troubleshooting

### Site Not Responding

1. Check site URL is correct
2. Verify DNS resolution
3. Check server status
4. Review error logs

### API Connectivity Issues

1. Verify API credentials
2. Check network connectivity
3. Review API rate limits
4. Check authentication tokens

### Performance Degradation

1. Review performance reports
2. Check server resources
3. Review recent changes
4. Optimize slow queries/endpoints

## Next Steps

1. Set up automated monitoring schedule
2. Configure alert thresholds
3. Establish baseline metrics
4. Set up notification system
5. Create performance dashboard

## References

- [Performance Monitoring Best Practices](https://example.com)
- [API Monitoring Guide](docs/guides/api-monitoring.md)
- [Performance Optimization](docs/guides/performance-optimization.md)
