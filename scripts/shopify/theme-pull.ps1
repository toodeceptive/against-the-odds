# Pull the current Shopify theme into the repo
# Repo root resolved from script location for cross-platform/CI.

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = $null,
    [string]$Theme = "live"
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

Write-Host "=== Shopify Theme Pull ===" -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command shopify -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Shopify CLI not found." -ForegroundColor Red
    Write-Host "Install with: npm install -g @shopify/cli @shopify/theme" -ForegroundColor Yellow
    exit 1
}

if ([string]::IsNullOrWhiteSpace($Store)) {
    Write-Host "Error: SHOPIFY_STORE_DOMAIN not set (expected aodrop.com)." -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Force -Path $ThemePath | Out-Null

Write-Host "Pulling theme '$Theme' from $Store into $ThemePath" -ForegroundColor Yellow
shopify theme pull --store=$Store --theme=$Theme --path=$ThemePath

if ($LASTEXITCODE -ne 0) {
    Write-Host "[FAIL] Theme pull failed" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Theme pull complete" -ForegroundColor Green
