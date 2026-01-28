# Pull the current Shopify theme into the repo

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = "src\shopify\themes\aodrop-theme",
    [string]$Theme = "live"
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
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
    Write-Host "✗ Theme pull failed" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Theme pull complete" -ForegroundColor Green

