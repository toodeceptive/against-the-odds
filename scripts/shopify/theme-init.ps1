# Initialize a Shopify theme workspace

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = "src\shopify\themes\aodrop-theme"
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Shopify Theme Init ===" -ForegroundColor Cyan
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

$existingFiles = Get-ChildItem -Path $ThemePath -Force -ErrorAction SilentlyContinue
if ($existingFiles.Count -gt 1) {
    Write-Host "Theme path already contains files. Skipping init." -ForegroundColor Yellow
    Write-Host "Path: $ThemePath" -ForegroundColor Cyan
    exit 0
}

Write-Host "Initializing a new Shopify theme in: $ThemePath" -ForegroundColor Yellow
shopify theme init --path=$ThemePath

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Theme init failed" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Theme initialized" -ForegroundColor Green

