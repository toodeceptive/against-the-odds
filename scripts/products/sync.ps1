# Sync products bidirectionally between local data and Shopify

param(
    [ValidateSet("import", "export", "both")]
    [string]$Direction = "both",
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$Token = $env:SHOPIFY_ACCESS_TOKEN,
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Product Sync (Bidirectional) ===" -ForegroundColor Cyan
Write-Host ""

if ($Direction -eq "import" -or $Direction -eq "both") {
    Write-Host "--- Importing products from local to Shopify ---" -ForegroundColor Yellow
    & "scripts\shopify\sync-products.ps1" -Store $Store -Token $Token -DryRun:$DryRun
    Write-Host ""
}

if ($Direction -eq "export" -or $Direction -eq "both") {
    Write-Host "--- Exporting products from Shopify to local ---" -ForegroundColor Yellow
    & "scripts\products\export.ps1" -Store $Store -Token $Token
    Write-Host ""
}

Write-Host "[OK] Sync complete!" -ForegroundColor Green
