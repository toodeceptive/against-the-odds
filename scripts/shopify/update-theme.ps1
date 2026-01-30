# Deploy theme updates to Shopify
# Syncs local theme files to Shopify store

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = "src\shopify\themes\aodrop-theme",
    [string]$ThemeId = $env:SHOPIFY_THEME_ID,
    [switch]$Live = $false
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Shopify Theme Update ===" -ForegroundColor Cyan
Write-Host ""

# Check if Shopify CLI is installed
if (-not (Get-Command shopify -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Shopify CLI not found" -ForegroundColor Red
    Write-Host "Install with: npm install -g @shopify/cli @shopify/theme" -ForegroundColor Yellow
    exit 1
}

# Check if theme directory exists
if (-not (Test-Path $ThemePath)) {
    Write-Host "Error: Theme directory not found: $ThemePath" -ForegroundColor Red
    Write-Host "Initialize theme first or check the path" -ForegroundColor Yellow
    exit 1
}

# Use Shopify CLI to deploy theme
Write-Host "Deploying theme..." -ForegroundColor Yellow

if ($Live) {
    Write-Host "Warning: Deploying to LIVE theme!" -ForegroundColor Red
    $confirm = Read-Host "Are you sure? (yes/no)"
    if ($confirm -ne "yes") {
        Write-Host "Deployment cancelled." -ForegroundColor Yellow
        exit 0
    }
    shopify theme push --store=$Store --theme=live --path=$ThemePath
} else {
    if ([string]::IsNullOrWhiteSpace($ThemeId)) {
        Write-Host "Deploying to development theme..." -ForegroundColor Yellow
        shopify theme push --store=$Store --path=$ThemePath
    } else {
        Write-Host "Deploying to theme ID: $ThemeId" -ForegroundColor Yellow
        shopify theme push --store=$Store --theme=$ThemeId --path=$ThemePath
    }
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Theme deployed successfully!" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Theme deployment failed" -ForegroundColor Red
    exit 1
}
