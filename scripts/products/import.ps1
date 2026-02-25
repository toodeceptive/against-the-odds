# Import products to Shopify from local data files.
# Compatibility entrypoint retained for older commands; canonical script is scripts/shopify/sync-products.ps1.

param(
    [string]$DataDir = "data\products",
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Product Import ===" -ForegroundColor Cyan
Write-Host ""

# Use the sync-products script
& "scripts\shopify\sync-products.ps1" -DryRun:$DryRun
