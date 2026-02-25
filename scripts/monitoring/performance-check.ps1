# Performance monitoring and health checks

param(
    [ValidateSet("all", "site", "api", "shopify")]
    [string]$Check = "all",
    [string]$OutputFile = "docs/status/performance-report.json"
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Performance Monitoring ===" -ForegroundColor Cyan
Write-Host ""

$report = @{
    timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    checks = @()
}

# Ensure output directory exists
$outputDir = Split-Path $OutputFile -Parent
if ($outputDir -and -not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

function Check-SitePerformance {
    Write-Host "Checking site performance..." -ForegroundColor Yellow

    $siteUrl = "https://aodrop.com"
    $check = @{
        type = "site"
        url = $siteUrl
        status = "unknown"
        response_time_ms = $null
        status_code = $null
        error = $null
    }

    try {
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $response = Invoke-WebRequest -Uri $siteUrl -Method Get -TimeoutSec 10 -UseBasicParsing
        $stopwatch.Stop()

        $check.status = "online"
        $check.response_time_ms = $stopwatch.ElapsedMilliseconds
        $check.status_code = $response.StatusCode

        Write-Host "  [OK] Site is online ($($check.response_time_ms)ms)" -ForegroundColor Green
    } catch {
        $check.status = "offline"
        $check.error = $_.Exception.Message
        Write-Host "  [FAIL] Site check failed: $_" -ForegroundColor Red
    }

    $report.checks += $check
}

function Check-ShopifyAPI {
    Write-Host "Checking Shopify API connectivity..." -ForegroundColor Yellow

    $store = $env:SHOPIFY_STORE_DOMAIN
    $token = $env:SHOPIFY_ACCESS_TOKEN

    $check = @{
        type = "shopify_api"
        store = $store
        status = "unknown"
        response_time_ms = $null
        error = $null
    }

    if ([string]::IsNullOrWhiteSpace($store) -or [string]::IsNullOrWhiteSpace($token)) {
        $check.status = "not_configured"
        $check.error = "Shopify credentials not configured"
        Write-Host "  [WARN] Shopify API not configured" -ForegroundColor Yellow
        $report.checks += $check
        return
    }

    try {
        $headers = @{
            "X-Shopify-Access-Token" = $token
        }

        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $response = Invoke-RestMethod -Uri "https://$store/admin/api/2026-01/shop.json" `
            -Headers $headers -Method Get -TimeoutSec 10
        $stopwatch.Stop()

        $check.status = "online"
        $check.response_time_ms = $stopwatch.ElapsedMilliseconds
        $check.shop_name = $response.shop.name

        Write-Host "  [OK] Shopify API is accessible ($($check.response_time_ms)ms)" -ForegroundColor Green
        Write-Host "    Shop: $($response.shop.name)" -ForegroundColor Cyan
    } catch {
        $check.status = "error"
        $check.error = $_.Exception.Message
        Write-Host "  [FAIL] Shopify API check failed: $_" -ForegroundColor Red
    }

    $report.checks += $check
}

function Check-GitHubAPI {
    Write-Host "Checking GitHub API connectivity..." -ForegroundColor Yellow

    $token = $env:GITHUB_TOKEN
    $repo = $env:GITHUB_REPO
    $username = $env:GITHUB_USERNAME

    $check = @{
        type = "github_api"
        repository = "$username/$repo"
        status = "unknown"
        response_time_ms = $null
        error = $null
    }

    if ([string]::IsNullOrWhiteSpace($token)) {
        $check.status = "not_configured"
        $check.error = "GitHub token not configured"
        Write-Host "  [WARN] GitHub API not configured" -ForegroundColor Yellow
        $report.checks += $check
        return
    }

    try {
        $headers = @{
            "Authorization" = "token $token"
            "Accept" = "application/vnd.github.v3+json"
        }

        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $response = Invoke-RestMethod -Uri "https://api.github.com/repos/$username/$repo" `
            -Headers $headers -Method Get -TimeoutSec 10
        $stopwatch.Stop()

        $check.status = "online"
        $check.response_time_ms = $stopwatch.ElapsedMilliseconds
        $check.repo_name = $response.name
        $check.repo_status = if ($response.private) { "private" } else { "public" }

        Write-Host "  [OK] GitHub API is accessible ($($check.response_time_ms)ms)" -ForegroundColor Green
        Write-Host "    Repository: $($response.full_name)" -ForegroundColor Cyan
    } catch {
        $check.status = "error"
        $check.error = $_.Exception.Message
        Write-Host "  [FAIL] GitHub API check failed: $_" -ForegroundColor Red
    }

    $report.checks += $check
}

# Run checks based on parameter
if ($Check -eq "all" -or $Check -eq "site") {
    Check-SitePerformance
}

if ($Check -eq "all" -or $Check -eq "api") {
    Check-GitHubAPI
}

if ($Check -eq "all" -or $Check -eq "shopify") {
    Check-ShopifyAPI
}

# Save report
$report | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host ""
Write-Host "[OK] Performance check complete!" -ForegroundColor Green
Write-Host "Report saved to: $OutputFile" -ForegroundColor Cyan
