# Fetch store configuration and data from Shopify
# Useful for backing up store settings and product data

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$Token = $env:SHOPIFY_ACCESS_TOKEN,
    [string]$OutputDir = "data\shopify-backup"
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Fetch Shopify Store Data ===" -ForegroundColor Cyan
Write-Host ""

# Validate environment
if ([string]::IsNullOrWhiteSpace($Store) -or [string]::IsNullOrWhiteSpace($Token)) {
    Write-Host "Error: Shopify credentials not configured" -ForegroundColor Red
    Write-Host "Set SHOPIFY_STORE_DOMAIN and SHOPIFY_ACCESS_TOKEN in .env.local" -ForegroundColor Yellow
    exit 1
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

$baseUrl = "https://$Store/admin/api/2024-01"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

Write-Host "Fetching store data..." -ForegroundColor Yellow

# Fetch shop information
try {
    Write-Host "  Fetching shop information..." -ForegroundColor Cyan
    $shop = Invoke-RestMethod -Uri "$baseUrl/shop.json" -Headers $headers -Method Get
    $shop | ConvertTo-Json -Depth 10 | Out-File "$OutputDir\shop_$timestamp.json"
    Write-Host "  ✓ Shop data saved" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to fetch shop data: $_" -ForegroundColor Red
}

# Fetch products
try {
    Write-Host "  Fetching products..." -ForegroundColor Cyan
    $products = Invoke-RestMethod -Uri "$baseUrl/products.json?limit=250" -Headers $headers -Method Get
    $products | ConvertTo-Json -Depth 10 | Out-File "$OutputDir\products_$timestamp.json"
    Write-Host "  ✓ Fetched $($products.products.Count) product(s)" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to fetch products: $_" -ForegroundColor Red
}

# Fetch collections
try {
    Write-Host "  Fetching collections..." -ForegroundColor Cyan
    $collections = Invoke-RestMethod -Uri "$baseUrl/collections.json?limit=250" -Headers $headers -Method Get
    $collections | ConvertTo-Json -Depth 10 | Out-File "$OutputDir\collections_$timestamp.json"
    Write-Host "  ✓ Fetched $($collections.collections.Count) collection(s)" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to fetch collections: $_" -ForegroundColor Red
}

# Fetch themes
try {
    Write-Host "  Fetching themes..." -ForegroundColor Cyan
    $themes = Invoke-RestMethod -Uri "$baseUrl/themes.json" -Headers $headers -Method Get
    $themes | ConvertTo-Json -Depth 10 | Out-File "$OutputDir\themes_$timestamp.json"
    Write-Host "  ✓ Fetched $($themes.themes.Count) theme(s)" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to fetch themes: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "✓ Store data backup complete!" -ForegroundColor Green
Write-Host "Backup location: $OutputDir" -ForegroundColor Cyan
