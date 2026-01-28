# Start Shopify theme dev server (local preview + sync)

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = "src\shopify\themes\aodrop-theme",
    [switch]$Live = $false
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Shopify Theme Dev ===" -ForegroundColor Cyan
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

if (-not (Test-Path $ThemePath)) {
    Write-Host "Theme path not found: $ThemePath" -ForegroundColor Yellow
    Write-Host "Run: .\\scripts\\shopify\\theme-init.ps1  (new theme) OR .\\scripts\\shopify\\theme-pull.ps1 (pull live)" -ForegroundColor Yellow
    exit 1
}

Write-Host "Starting theme dev server..." -ForegroundColor Yellow
Write-Host "Store: $Store" -ForegroundColor Cyan
Write-Host "Path:  $ThemePath" -ForegroundColor Cyan
Write-Host ""

if ($Live) {
    Write-Host "Note: previewing LIVE theme context (still uses dev preview URL)." -ForegroundColor Yellow
    shopify theme dev --store=$Store --theme=live --path=$ThemePath
} else {
    shopify theme dev --store=$Store --path=$ThemePath
}

