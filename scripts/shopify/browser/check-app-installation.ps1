# Check Shopify app installation status via browser

param(
    [string]$StoreDomain = $env:SHOPIFY_STORE_DOMAIN
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

if ([string]::IsNullOrWhiteSpace($StoreDomain)) {
    $StoreDomain = "aodrop.com"
}

Write-Host "=== Shopify App Installation Check ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "App: AO" -ForegroundColor Yellow
if ([string]::IsNullOrWhiteSpace($env:SHOPIFY_API_KEY)) {
    Write-Host "Client ID: (set SHOPIFY_API_KEY in .env.local)" -ForegroundColor Cyan
} else {
    Write-Host "Client ID: $($env:SHOPIFY_API_KEY)" -ForegroundColor Cyan
}
Write-Host ""
Write-Host "Check installation status:" -ForegroundColor Yellow
Write-Host "1. Go to: https://$StoreDomain/admin/apps" -ForegroundColor White
Write-Host "2. Look for 'AO' app" -ForegroundColor White
Write-Host "3. Check installation status" -ForegroundColor White
Write-Host ""
Write-Host "Browser automation for this check coming soon..." -ForegroundColor Gray
