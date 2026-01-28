# Backup store settings via browser automation (screenshots and data)

param(
    [string]$StoreDomain = $env:SHOPIFY_STORE_DOMAIN,
    [string]$OutputDir = "docs\screenshots\store-backup"
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

if ([string]::IsNullOrWhiteSpace($StoreDomain)) {
    $StoreDomain = "aodrop.com"
}

Write-Host "=== Store Settings Backup ===" -ForegroundColor Cyan
Write-Host ""

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
}

Write-Host "Backup locations:" -ForegroundColor Yellow
Write-Host "1. Store settings: $OutputDir\settings-$(Get-Date -Format 'yyyyMMdd-HHmmss').png" -ForegroundColor White
Write-Host "2. Payment settings: $OutputDir\payments-$(Get-Date -Format 'yyyyMMdd-HHmmss').png" -ForegroundColor White
Write-Host "3. Shipping settings: $OutputDir\shipping-$(Get-Date -Format 'yyyyMMdd-HHmmss').png" -ForegroundColor White
Write-Host ""
Write-Host "Browser automation for automatic backup coming soon..." -ForegroundColor Gray
Write-Host "For now, manually screenshot store settings pages" -ForegroundColor Yellow
