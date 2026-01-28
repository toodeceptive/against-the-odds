# Import products to Shopify from local data files

param(
    [string]$DataDir = "data\products",
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Product Import ===" -ForegroundColor Cyan
Write-Host ""

# Use the sync-products script
& "scripts\shopify\sync-products.ps1" -DryRun:$DryRun
