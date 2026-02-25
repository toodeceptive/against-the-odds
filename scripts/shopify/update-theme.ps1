# Deploy theme updates to Shopify
# Uses "npx shopify theme push" so the theme CLI is used (not a different global "shopify" e.g. Hydrogen).
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
if ([string]::IsNullOrWhiteSpace($ThemeId)) { $ThemeId = $env:SHOPIFY_THEME_ID }

# Default to this repo's store so CLI never gets an empty store (".myshopify.com" error)
if ([string]::IsNullOrWhiteSpace($Store) -or $Store -notmatch '\.') {
    $Store = "aodrop.com"
    Write-Host "Using default store: aodrop.com (set SHOPIFY_STORE_DOMAIN in .env.local to override)" -ForegroundColor Gray
}

Write-Host "=== Shopify Theme Update ===" -ForegroundColor Cyan
Write-Host ""

. "$PSScriptRoot\Ensure-ShopifyCli.ps1"

if (-not (Test-Path $ThemePath)) {
    Write-Host "Error: Theme directory not found: $ThemePath" -ForegroundColor Red
    Write-Host "Initialize theme first or check the path" -ForegroundColor Yellow
    exit 1
}

# Use permanent store domain (myshopify.com) for theme CLI — matches theme-pull.
$storeForCli = $Store
if ($Store -eq "aodrop.com" -or $Store -match "^aodrop\.com$") {
    $storeForCli = "aodrop.com.myshopify.com"
} elseif ($Store -notmatch "\.myshopify\.com$") {
    $storeForCli = "$Store.myshopify.com"
}
Write-Host "Store: $storeForCli" -ForegroundColor Cyan

$themeToken = $env:SHOPIFY_CLI_THEME_TOKEN
if ([string]::IsNullOrWhiteSpace($themeToken)) { $themeToken = $env:SHOPIFY_ACCESS_TOKEN }

Write-Host "Deploying theme (npx shopify theme push)..." -ForegroundColor Yellow
if ($themeToken) { Write-Host "Using token (non-interactive)." -ForegroundColor Gray }

# Use npx explicitly so we always use @shopify/cli theme push. Pass --path and path as separate args.
$pushArgs = @("shopify", "theme", "push", "--store=$storeForCli", "--path", $ThemePath)
if ($themeToken) {
    $pushArgs += "--password"
    $pushArgs += $themeToken
}
if ($Live) {
    Write-Host "Warning: Deploying to LIVE theme!" -ForegroundColor Red
    $confirm = Read-Host "Are you sure? (yes/no)"
    if ($confirm -ne "yes") {
        Write-Host "Deployment cancelled." -ForegroundColor Yellow
        exit 0
    }
    $pushArgs += "--theme=live"
} else {
    if ([string]::IsNullOrWhiteSpace($ThemeId)) {
        Write-Host "Deploying to development theme..." -ForegroundColor Yellow
    } else {
        Write-Host "Deploying to theme ID: $ThemeId" -ForegroundColor Yellow
        $pushArgs += "--theme=$ThemeId"
    }
}
& npx $pushArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Theme deployed successfully!" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Theme deployment failed" -ForegroundColor Red
    exit 1
}
