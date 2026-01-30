# Deploy theme updates to Shopify
# Syncs local theme files to Shopify store. Repo root from script location.

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = $null,
    [string]$ThemeId = $env:SHOPIFY_THEME_ID,
    [switch]$Live = $false
)

$ErrorActionPreference = "Stop"

$repoPath = if ($PSScriptRoot) {
    $parent = Join-Path $PSScriptRoot ".."
    (Resolve-Path (Join-Path $parent "..")).Path
} else {
    (Get-Location).Path
}
if (-not $ThemePath) {
    $ThemePath = Join-Path (Join-Path (Join-Path (Join-Path $repoPath "src") "shopify") "themes") "aodrop-theme"
}
Set-Location $repoPath

Write-Host "=== Shopify Theme Update ===" -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command shopify -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Shopify CLI not found" -ForegroundColor Red
    Write-Host "Install with: npm install -g @shopify/cli @shopify/theme" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $ThemePath)) {
    Write-Host "Error: Theme directory not found: $ThemePath" -ForegroundColor Red
    Write-Host "Initialize theme first or check the path" -ForegroundColor Yellow
    exit 1
}

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
