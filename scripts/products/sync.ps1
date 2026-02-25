# Sync products bidirectionally between local data and Shopify.
# Compatibility wrapper retained for import/export orchestration; canonical import/apply script is scripts/shopify/sync-products.ps1.

param(
    [ValidateSet("import", "export", "both")]
    [string]$Direction = "both",
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$Token = $env:SHOPIFY_ACCESS_TOKEN,
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"
# Repo root: script is scripts/products/sync.ps1 -> repo = parent of parent of PSScriptRoot
$repoPath = if ($PSScriptRoot) {
    $parent = Join-Path $PSScriptRoot ".."
    $grandParent = Join-Path $parent ".."
    (Resolve-Path $grandParent).Path
} else {
    (Get-Location).Path
}
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
