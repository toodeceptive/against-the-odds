# Start Shopify theme dev server for live preview (hot-reload) before committing.
# Run from Cursor: Tasks > Run Task > "Shopify: Theme Dev". When the preview URL appears, click it or paste into View > Simple Browser.
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

Write-Host "=== Shopify Theme Dev (preview before commit) ===" -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command shopify -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Shopify CLI not found." -ForegroundColor Red
    Write-Host "Install with: npm install -g @shopify/cli @shopify/theme" -ForegroundColor Yellow
    exit 1
}

if ([string]::IsNullOrWhiteSpace($Store)) {
    Write-Host "Error: SHOPIFY_STORE_DOMAIN not set (e.g. aodrop.com). Set in .env.local or pass -Store." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $ThemePath)) {
    Write-Host "Theme path not found: $ThemePath" -ForegroundColor Yellow
    Write-Host "Run: .\scripts\shopify\theme-pull.ps1  to pull the live theme first." -ForegroundColor Yellow
    exit 1
}

Write-Host "Starting theme dev server (preview URL will appear below)..." -ForegroundColor Yellow
Write-Host "Store: $Store  |  Path: $ThemePath" -ForegroundColor Cyan
Write-Host ""
Write-Host "Browser will open automatically when the server is ready (default: http://127.0.0.1:9292)." -ForegroundColor Gray
Write-Host "You can also click the URL in the terminal or paste into Cursor > View > Simple Browser." -ForegroundColor Gray
Write-Host ""

# Auto-open preview URL in default browser after server has time to start (runs in background)
$previewUrl = "http://127.0.0.1:9292"
$openJob = Start-Job -ScriptBlock {
    param($url)
    Start-Sleep -Seconds 6
    try { Start-Process $url } catch { }
} -ArgumentList $previewUrl

if ($Live) {
    Write-Host "Previewing against LIVE theme context." -ForegroundColor Yellow
    shopify theme dev --store=$Store --theme=live --path=$ThemePath
} else {
    shopify theme dev --store=$Store --path=$ThemePath
}
