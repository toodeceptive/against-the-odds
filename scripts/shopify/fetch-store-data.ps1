# Fetch store configuration and data from Shopify
# Useful for backing up store settings and product data

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$Token = $env:SHOPIFY_ACCESS_TOKEN,
    [string]$OutputDir = "data\shopify-backup"
)

$ErrorActionPreference = "Stop"

# Repo root resolved from script location for portability (worktrees/CI)
$repoPath = if ($PSScriptRoot) {
    $parent = Join-Path $PSScriptRoot ".."
    (Resolve-Path (Join-Path $parent "..")).Path
} else {
    (Get-Location).Path
}
Set-Location $repoPath

# Load .env.local if present (gitignored)
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

if ([string]::IsNullOrWhiteSpace($Store)) { $Store = $env:SHOPIFY_STORE_DOMAIN }
if ([string]::IsNullOrWhiteSpace($Token)) { $Token = $env:SHOPIFY_ACCESS_TOKEN }

Write-Host "=== Fetch Shopify Store Data ===" -ForegroundColor Cyan
Write-Host ""

# Validate environment
if ([string]::IsNullOrWhiteSpace($Store) -or [string]::IsNullOrWhiteSpace($Token)) {
    Write-Host "Error: Shopify credentials not configured" -ForegroundColor Red
    Write-Host "Set SHOPIFY_STORE_DOMAIN and SHOPIFY_ACCESS_TOKEN in .env.local" -ForegroundColor Yellow
    exit 1
}

# Resolve output path (relative paths are relative to repo root)
if (-not [System.IO.Path]::IsPathRooted($OutputDir)) {
    $OutputDir = Join-Path $repoPath $OutputDir
}

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
}

# Setup API headers
$headers = @{
    "X-Shopify-Access-Token" = $Token
    "Content-Type" = "application/json"
}

$storeHost = $Store
if ($Store -eq "aodrop.com" -or $Store -match "^aodrop\.com$") {
    $storeHost = "aodrop.com.myshopify.com"
}

$apiVersion = $env:SHOPIFY_ADMIN_API_VERSION
if ([string]::IsNullOrWhiteSpace($apiVersion)) { $apiVersion = "2026-01" }

$baseUrl = "https://$storeHost/admin/api/$apiVersion"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$requestTimeoutSec = 60

Write-Host "Fetching store data..." -ForegroundColor Yellow

# Fetch shop information
try {
    Write-Host "  Fetching shop information..." -ForegroundColor Cyan
    $shop = Invoke-RestMethod -Uri "$baseUrl/shop.json" -Headers $headers -Method Get -TimeoutSec $requestTimeoutSec
    $shop | ConvertTo-Json -Depth 10 | Out-File (Join-Path $OutputDir "shop_$timestamp.json")
    Write-Host "  [OK] Shop data saved" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Failed to fetch shop data: $_" -ForegroundColor Red
}

# Fetch products
try {
    Write-Host "  Fetching products..." -ForegroundColor Cyan
    $products = Invoke-RestMethod -Uri "$baseUrl/products.json?limit=250" -Headers $headers -Method Get -TimeoutSec $requestTimeoutSec
    $products | ConvertTo-Json -Depth 10 | Out-File (Join-Path $OutputDir "products_$timestamp.json")
    Write-Host "  [OK] Fetched $($products.products.Count) product(s)" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Failed to fetch products: $_" -ForegroundColor Red
}

# Fetch collections
try {
    Write-Host "  Fetching collections..." -ForegroundColor Cyan
    $collections = Invoke-RestMethod -Uri "$baseUrl/collections.json?limit=250" -Headers $headers -Method Get -TimeoutSec $requestTimeoutSec
    $collections | ConvertTo-Json -Depth 10 | Out-File (Join-Path $OutputDir "collections_$timestamp.json")
    Write-Host "  [OK] Fetched $($collections.collections.Count) collection(s)" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Failed to fetch collections: $_" -ForegroundColor Red
}

# Fetch themes
try {
    Write-Host "  Fetching themes..." -ForegroundColor Cyan
    $themes = Invoke-RestMethod -Uri "$baseUrl/themes.json" -Headers $headers -Method Get -TimeoutSec $requestTimeoutSec
    $themes | ConvertTo-Json -Depth 10 | Out-File (Join-Path $OutputDir "themes_$timestamp.json")
    Write-Host "  [OK] Fetched $($themes.themes.Count) theme(s)" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Failed to fetch themes: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "[OK] Store data backup complete!" -ForegroundColor Green
Write-Host "Backup location: $OutputDir" -ForegroundColor Cyan
