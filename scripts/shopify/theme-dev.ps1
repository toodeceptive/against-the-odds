
# Start Shopify theme dev server for live preview (hot-reload) before committing.
# Run from Cursor: Tasks > Run Task > "Shopify: Theme Dev". When the preview URL appears, click it or paste into View > Simple Browser.
# Uses "npx shopify theme dev" so the theme CLI is used (not a different global "shopify" e.g. Hydrogen).
# Repo root from script location.

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = $null,
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
# Default to this repo's store so CLI never gets an empty store
if ([string]::IsNullOrWhiteSpace($Store) -or $Store -notmatch '\.') {
    $Store = "aodrop.com"
    Write-Host "Using default store: aodrop.com (set SHOPIFY_STORE_DOMAIN in .env.local to override)" -ForegroundColor Gray
}

Write-Host "=== Shopify Theme Dev (preview before commit) ===" -ForegroundColor Cyan
Write-Host ""

. "$PSScriptRoot\Ensure-ShopifyCli.ps1"

if (-not (Test-Path $ThemePath)) {
    Write-Host "Theme path not found: $ThemePath" -ForegroundColor Yellow
    Write-Host "Run: .\scripts\shopify\theme-pull.ps1  to pull the live theme first." -ForegroundColor Yellow
    exit 1
}

# Theme dev requires a full theme (layout/, config/). If only assets/snippets exist, user must theme-pull first.
$layoutFile = Join-Path (Join-Path $ThemePath "layout") "theme.liquid"
if (-not (Test-Path $layoutFile)) {
    Write-Host "Error: Theme folder is not a full Shopify theme (missing layout/theme.liquid)." -ForegroundColor Red
    Write-Host "Run theme-pull first: .\scripts\shopify\theme-pull.ps1" -ForegroundColor Yellow
    Write-Host "That pulls the live theme from Shopify into this folder; then theme dev will work." -ForegroundColor Gray
    exit 1
}

# Use permanent store domain (myshopify.com) for theme CLI — matches theme-pull.
$storeForCli = $Store
if ($Store -eq "aodrop.com" -or $Store -match "^aodrop\.com$") {
    $storeForCli = "aodrop.com.myshopify.com"
} elseif ($Store -notmatch "\.myshopify\.com$") {
    $storeForCli = "$Store.myshopify.com"
}

$themeToken = $env:SHOPIFY_CLI_THEME_TOKEN
if ([string]::IsNullOrWhiteSpace($themeToken)) { $themeToken = $env:SHOPIFY_ACCESS_TOKEN }

Write-Host "Starting theme dev server (preview URL will appear below)..." -ForegroundColor Yellow
Write-Host "Store: $storeForCli  |  Path: $ThemePath" -ForegroundColor Cyan
if ($themeToken) { Write-Host "Using token (non-interactive)." -ForegroundColor Gray }
Write-Host ""
Write-Host "Using: npx shopify theme dev (theme CLI). Browser will open when ready (http://127.0.0.1:9292)." -ForegroundColor Gray
Write-Host ""

# Use npx explicitly so we always use @shopify/cli theme dev (avoids wrong global "shopify" e.g. Hydrogen).
# Pass --path and path as separate args so Windows paths (e.g. C:\...) are not mangled.
$devArgs = @("shopify", "theme", "dev", "--store=$storeForCli", "--path", $ThemePath, "--host", "127.0.0.1", "--port", "9292", "--open")
if ($themeToken) {
    $devArgs += "--password"
    $devArgs += $themeToken
}
if ($Live) {
    Write-Host "Previewing against LIVE theme context." -ForegroundColor Yellow
    $devArgs += "--theme=live"
}
& npx $devArgs
