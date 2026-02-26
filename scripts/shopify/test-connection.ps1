# Test Shopify API connection

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$Token = $env:SHOPIFY_ACCESS_TOKEN
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

# Load .env.local into process env when present (same pattern as run-runbook.ps1)
if (Test-Path ".env.local") {
    Get-Content ".env.local" | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line -match "^([^=]+)=(.*)$") {
            $key = $matches[1].Trim()
            $val = $matches[2].Trim()
            [Environment]::SetEnvironmentVariable($key, $val, "Process")
        }
    }
}
# Use env after load (param binding runs before .env.local is loaded)
if ([string]::IsNullOrWhiteSpace($Store)) { $Store = $env:SHOPIFY_STORE_DOMAIN }
if ([string]::IsNullOrWhiteSpace($Token)) { $Token = $env:SHOPIFY_ACCESS_TOKEN }

Write-Host "=== Shopify Connection Test ===" -ForegroundColor Cyan
Write-Host ""

# Validate environment
if ([string]::IsNullOrWhiteSpace($Store)) {
    Write-Host "Error: SHOPIFY_STORE_DOMAIN not set" -ForegroundColor Red
    Write-Host "Set it in .env.local or pass -Store parameter" -ForegroundColor Yellow
    exit 1
}

if ([string]::IsNullOrWhiteSpace($Token)) {
    Write-Host "Error: SHOPIFY_ACCESS_TOKEN not set" -ForegroundColor Red
    Write-Host "Set it in .env.local or pass -Token parameter" -ForegroundColor Yellow
    exit 1
}

# Setup API headers
$headers = @{
    "X-Shopify-Access-Token" = $Token
    "Content-Type" = "application/json"
}

$baseUrl = "https://$Store/admin/api/2026-01"
$requestTimeoutSec = 30

Write-Host "Testing connection to: $Store" -ForegroundColor Yellow
Write-Host ""

# Test 1: Get shop information
Write-Host "Test 1: Fetching shop information..." -ForegroundColor Cyan
try {
    $shop = Invoke-RestMethod -Uri "$baseUrl/shop.json" -Headers $headers -Method Get -TimeoutSec $requestTimeoutSec
    Write-Host "  [OK] Connected successfully!" -ForegroundColor Green
    Write-Host "  Shop Name: $($shop.shop.name)" -ForegroundColor Cyan
    Write-Host "  Shop Domain: $($shop.shop.domain)" -ForegroundColor Cyan
    Write-Host "  Shop Email: $($shop.shop.email)" -ForegroundColor Cyan
    Write-Host "  Currency: $($shop.shop.currency)" -ForegroundColor Cyan
} catch {
    Write-Host "  [X] Failed to fetch shop information" -ForegroundColor Red
    Write-Host ('  Error: ' + $_) -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 2: Get products count
Write-Host "Test 2: Fetching products..." -ForegroundColor Cyan
try {
    $products = Invoke-RestMethod -Uri "$baseUrl/products.json?limit=1" -Headers $headers -Method Get -TimeoutSec $requestTimeoutSec
    $productCount = if ($products.products) { $products.products.Count } else { 0 }
    Write-Host "  [OK] Products API accessible" -ForegroundColor Green
    Write-Host "  Products found: $productCount" -ForegroundColor Cyan
} catch {
    Write-Host "  [X] Failed to fetch products" -ForegroundColor Red
    Write-Host ('  Error: ' + $_) -ForegroundColor Red
}

Write-Host ""

# Test 3: Get themes
Write-Host "Test 3: Fetching themes..." -ForegroundColor Cyan
try {
    $themes = Invoke-RestMethod -Uri "$baseUrl/themes.json" -Headers $headers -Method Get -TimeoutSec $requestTimeoutSec
    $themeCount = if ($themes.themes) { $themes.themes.Count } else { 0 }
    Write-Host "  [OK] Themes API accessible" -ForegroundColor Green
    Write-Host "  Themes found: $themeCount" -ForegroundColor Cyan

    if ($themes.themes) {
        foreach ($theme in $themes.themes) {
            $role = if ($theme.role -eq "main") { "LIVE" } else { $theme.role.ToUpper() }
            Write-Host "    - $($theme.name) ($role)" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "  [X] Failed to fetch themes" -ForegroundColor Red
    Write-Host ('  Error: ' + $_) -ForegroundColor Red
}

Write-Host ""
Write-Host '[OK] Connection test complete!' -ForegroundColor Green
